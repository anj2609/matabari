import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:matabari/config/utils/colors.dart';
import 'package:matabari/config/utils/dimensions.dart';
import 'package:matabari/config/utils/style.dart';

class AartiPlayerScreen extends StatefulWidget {
  final Map<String, dynamic> aarti;
  final List<Map<String, dynamic>> related;

  const AartiPlayerScreen({
    super.key,
    required this.aarti,
    this.related = const [],
  });

  @override
  State<AartiPlayerScreen> createState() => _AartiPlayerScreenState();
}

class _AartiPlayerScreenState extends State<AartiPlayerScreen> {
  static const LinearGradient _redGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xffC42118), Color(0xff9D1911), Color(0xff650E07)],
    stops: [0.0, 0.45, 1.0],
  );

  final AudioPlayer _player = AudioPlayer();
  final ScrollController _lyricsScrollController = ScrollController();
  StreamSubscription? _durationSub;
  StreamSubscription? _positionSub;
  StreamSubscription? _stateSub;
  Timer? _autoScrollTimer;
  Timer? _sleepTimer;

  bool isPlaying = false;
  bool isFavorite = false;
  bool isRepeat = false;
  bool isBookmarked = false;
  bool autoScroll = true;
  int selectedTab = 0;
  double lyricsFontSize = 16;
  Duration position = Duration.zero;
  Duration total = const Duration(seconds: 1);

  bool get _isChalisa => (widget.aarti['type'] as String?) == 'chalisa';
  String get _contentLabel {
    switch (widget.aarti['type'] as String?) {
      case 'chalisa':
        return "Chalisa";
      case 'bhajan':
        return "Bhajan";
      default:
        return "Aarti";
    }
  }

  static const List<String> _lyrics = [
    "जय त्रिपुरा सुंदरी माता |",
    "मंगल करनी करुणा की खान ||",
    "जय त्रिपुरा सुंदरी माता |",
    "",
    "सुख दुःख हरता संकट टलता |",
    "भक्तन के सब काज सुधरता ||",
    "",
    "शक्ति स्वरूपा जग की माता |",
    "तीनों लोकों में शीश नवाता ||",
    "",
    "कृपा दृष्टि इस पर रखियो |",
    "भक्त जनों के दुख हर लीजो ||",
  ];

  static const List<String> _meaning = [
    "This aarti invokes Maa Tripura Sundari, the divine mother who "
        "presides over the three worlds and grants beauty, prosperity "
        "and inner peace to her devotees.",
    "",
    "Singing it with devotion is believed to remove sorrow and "
        "obstacles, and to fill the household with harmony and "
        "protection.",
  ];

  @override
  void initState() {
    super.initState();
    total = _parseDuration(widget.aarti['duration'] as String? ?? '1 Min');

    _durationSub = _player.onDurationChanged.listen((d) {
      if (mounted) setState(() => total = d);
    });
    _positionSub = _player.onPositionChanged.listen((p) {
      if (mounted) setState(() => position = p);
    });
    _stateSub = _player.onPlayerStateChanged.listen((s) {
      if (mounted) setState(() => isPlaying = s == PlayerState.playing);
    });

    _play();

    _autoScrollTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (!autoScroll || !isPlaying || selectedTab != 0) return;
      if (!_lyricsScrollController.hasClients) return;
      final max = _lyricsScrollController.position.maxScrollExtent;
      final next = (_lyricsScrollController.offset + 30).clamp(0, max);
      _lyricsScrollController.animateTo(
        next.toDouble(),
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _durationSub?.cancel();
    _positionSub?.cancel();
    _stateSub?.cancel();
    _autoScrollTimer?.cancel();
    _sleepTimer?.cancel();
    _player.dispose();
    _lyricsScrollController.dispose();
    super.dispose();
  }

  Duration _parseDuration(String label) {
    final minutes = int.tryParse(RegExp(r'\d+').firstMatch(label)?.group(0) ?? '1') ?? 1;
    return Duration(minutes: minutes);
  }

  String _formatDuration(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$m:$s";
  }

  Future<void> _play() async {
    final audio = (widget.aarti['audio'] as String).replaceFirst('assets/', '');
    await _player.play(AssetSource(audio));
  }

  Future<void> _togglePlayPause() async {
    if (isPlaying) {
      await _player.pause();
    } else {
      await _player.resume();
    }
  }

  Future<void> _toggleRepeat() async {
    setState(() => isRepeat = !isRepeat);
    await _player.setReleaseMode(isRepeat ? ReleaseMode.loop : ReleaseMode.release);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(isRepeat ? "Repeat enabled" : "Repeat disabled")),
    );
  }

  void _openInRelated(int offset) {
    if (widget.related.isEmpty) return;
    final queue = [widget.aarti, ...widget.related];
    final currentIndex = queue.indexWhere((e) => e['title'] == widget.aarti['title']);
    final nextIndex = (currentIndex + offset) % queue.length;
    final next = queue[(nextIndex + queue.length) % queue.length];
    final nextRelated = queue.where((e) => e['title'] != next['title']).toList();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => AartiPlayerScreen(aarti: next, related: nextRelated),
      ),
    );
  }

  Future<void> _pickSleepTimer() async {
    final minutes = await showModalBottomSheet<int>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [15, 30, 45, 60]
                .map(
                  (m) => ListTile(
                    leading: const Icon(Icons.bedtime_outlined, color: Color(0xff9D1911)),
                    title: Text(
                      "$m minutes",
                      style: cormorantInfantBold.copyWith(fontSize: Dimensions.spacingSize16),
                    ),
                    onTap: () => Navigator.pop(context, m),
                  ),
                )
                .toList(),
          ),
        );
      },
    );

    if (minutes == null || !mounted) return;
    _sleepTimer?.cancel();
    _sleepTimer = Timer(Duration(minutes: minutes), () => _player.pause());
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Sleep timer set for $minutes minutes")),
    );
  }

  Future<void> _pickTextSize() async {
    final size = await showModalBottomSheet<double>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final options = {"Small": 13.0, "Medium": 16.0, "Large": 20.0};
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: options.entries
                .map(
                  (e) => ListTile(
                    leading: const Icon(Icons.text_fields, color: Color(0xff9D1911)),
                    title: Text(
                      e.key,
                      style: cormorantInfantBold.copyWith(fontSize: e.value),
                    ),
                    trailing: lyricsFontSize == e.value
                        ? const Icon(Icons.check, color: Color(0xff9D1911))
                        : null,
                    onTap: () => Navigator.pop(context, e.value),
                  ),
                )
                .toList(),
          ),
        );
      },
    );

    if (size == null) return;
    setState(() => lyricsFontSize = size);
  }

  void _notify(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final aarti = widget.aarti;
    final String image = aarti['image'] as String? ?? '';
    final String title = aarti['title'] as String? ?? '';
    final String sub = aarti['sub'] as String? ?? _contentLabel;
    final String plays = aarti['plays'] as String? ?? (_isChalisa ? '10K Reads' : '10K Plays');
    final String? duration = aarti['duration'] as String?;
    final String? badge = aarti['badge'] as String?;

    return Scaffold(
      backgroundColor: const Color(0xffF8F5F0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 90),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _header(image, title, sub, plays, duration, badge),
            Transform.translate(
              offset: const Offset(0, -24),
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xffF8F5F0),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                padding: const EdgeInsets.fromLTRB(18, 24, 18, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _playerCard(),
                    const SizedBox(height: 20),
                    _tabsRow(),
                    const SizedBox(height: 14),
                    _tabContent(),
                    const SizedBox(height: 20),
                    _actionIconsRow(),
                    const SizedBox(height: 24),
                    if (widget.related.isNotEmpty) ...[
                      _sectionHeader("Related $_contentLabel"),
                      const SizedBox(height: 12),
                      _relatedRow(),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _miniPlayerBar(image, title, sub),
    );
  }

  Widget _gradientText(String text, TextStyle style) {
    return ShaderMask(
      shaderCallback: (bounds) => _redGradient.createShader(bounds),
      child: Text(text, style: style.copyWith(color: Colors.white)),
    );
  }

  /// ---------------- HEADER ----------------
  Widget _header(
    String image,
    String title,
    String sub,
    String plays,
    String? duration,
    String? badge,
  ) {
    return SizedBox(
      height: 320,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(image, fit: BoxFit.cover),

          /// Red overlay - kept translucent so the image stays clearly visible
          Container(color: const Color(0x59650E07)),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _circleIconButton(
                        icon: Icons.arrow_back,
                        onTap: () => Navigator.maybePop(context),
                      ),
                      Row(
                        children: [
                          _circleIconButton(
                            icon: isFavorite ? Icons.favorite : Icons.favorite_border,
                            iconColor: isFavorite ? const Color(0xFFE07A00) : Colors.white,
                            onTap: () => setState(() => isFavorite = !isFavorite),
                          ),
                          const SizedBox(width: 10),
                          _circleIconButton(
                            icon: Icons.share_outlined,
                            onTap: () => _notify("Sharing $title"),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Spacer(),
                  if (badge != null) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: ColorResources.kOrange,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        badge,
                        style: avenirNextCyr.copyWith(
                          color: Colors.white,
                          fontSize: Dimensions.fontSizeSmall,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                  Text(
                    title,
                    style: cormorantInfantBold.copyWith(
                      color: Colors.white,
                      fontSize: Dimensions.fontSizeOverLarge,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        _isChalisa ? Icons.menu_book_outlined : Icons.wb_sunny_outlined,
                        color: Colors.white,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        sub,
                        style: avenirNextCyr.copyWith(
                          color: Colors.white,
                          fontSize: Dimensions.fontSizeDefault,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Icon(
                        _isChalisa ? Icons.auto_stories_outlined : Icons.headphones,
                        color: Colors.white,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        plays,
                        style: avenirNextCyr.copyWith(
                          color: Colors.white,
                          fontSize: Dimensions.fontSizeDefault,
                        ),
                      ),
                      if (duration != null) ...[
                        const SizedBox(width: 10),
                        Text(
                          "•",
                          style: avenirNextCyr.copyWith(
                            color: Colors.white70,
                            fontSize: Dimensions.fontSizeDefault,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          duration,
                          style: avenirNextCyr.copyWith(
                            color: Colors.white,
                            fontSize: Dimensions.fontSizeDefault,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 36),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _circleIconButton({
    required IconData icon,
    required VoidCallback onTap,
    Color iconColor = Colors.white,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 36,
        width: 36,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withValues(alpha: .2),
        ),
        child: Icon(icon, color: iconColor, size: 18),
      ),
    );
  }

  /// ---------------- PLAYER CARD ----------------
  Widget _playerCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xffF3D8B3)),
      ),
      child: Column(
        children: [
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 3,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
              activeTrackColor: const Color(0xff9D1911),
              inactiveTrackColor: const Color(0xffF3D8B3),
              thumbColor: const Color(0xff9D1911),
            ),
            child: Slider(
              value: position.inSeconds
                  .toDouble()
                  .clamp(0, total.inSeconds.toDouble() <= 0 ? 1 : total.inSeconds.toDouble()),
              max: total.inSeconds.toDouble() <= 0 ? 1 : total.inSeconds.toDouble(),
              onChanged: (v) => setState(() => position = Duration(seconds: v.toInt())),
              onChangeEnd: (v) => _player.seek(Duration(seconds: v.toInt())),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatDuration(position),
                  style: avenirNextRegular.copyWith(
                    color: ColorResources.textLight,
                    fontSize: Dimensions.fontSizeSmall,
                  ),
                ),
                Text(
                  _formatDuration(total),
                  style: avenirNextRegular.copyWith(
                    color: ColorResources.textLight,
                    fontSize: Dimensions.fontSizeSmall,
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: _toggleRepeat,
                child: Icon(
                  Icons.repeat,
                  color: isRepeat ? const Color(0xff9D1911) : ColorResources.textLight,
                  size: 22,
                ),
              ),
              GestureDetector(
                onTap: () => _openInRelated(-1),
                child: Icon(Icons.skip_previous, color: ColorResources.blackColor, size: 30),
              ),
              GestureDetector(
                onTap: _togglePlayPause,
                child: Container(
                  height: 58,
                  width: 58,
                  decoration: const BoxDecoration(gradient: _redGradient, shape: BoxShape.circle),
                  child: Icon(
                    isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => _openInRelated(1),
                child: Icon(Icons.skip_next, color: ColorResources.blackColor, size: 30),
              ),
              GestureDetector(
                onTap: _pickSleepTimer,
                child: const Icon(Icons.bedtime_outlined, color: ColorResources.textLight, size: 22),
              ),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  /// ---------------- TABS ----------------
  Widget _tabsRow() {
    final labels = ["Lyrics", "Meaning", "Info"];
    return Row(
      children: List.generate(labels.length, (index) {
        final selected = selectedTab == index;
        return Expanded(
          child: GestureDetector(
            onTap: () => setState(() => selectedTab = index),
            child: Container(
              padding: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: selected ? const Color(0xff9D1911) : Colors.transparent,
                    width: 2,
                  ),
                ),
              ),
              child: Text(
                labels[index],
                textAlign: TextAlign.center,
                style: cormorantInfantBold.copyWith(
                  color: selected ? const Color(0xff9D1911) : ColorResources.textLight,
                  fontSize: Dimensions.spacingSize16,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _tabContent() {
    if (selectedTab == 1) return _meaningContent();
    if (selectedTab == 2) return _infoContent();
    return _lyricsContent();
  }

  Widget _lyricsContent() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xffF3D8B3)),
      ),
      child: IntrinsicHeight(
        child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            width: 4,
            decoration: const BoxDecoration(
              color: Color(0xFFE07A00),
              borderRadius: BorderRadius.horizontal(left: Radius.circular(16)),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 170,
                    child: ListView.builder(
                      controller: _lyricsScrollController,
                      itemCount: _lyrics.length,
                      itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        child: Text(
                          _lyrics[index],
                          style: cormorantInfantMedium.copyWith(
                            color: ColorResources.blackColor,
                            fontSize: lyricsFontSize,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "Auto Scroll",
                        style: avenirNextRegular.copyWith(
                          color: ColorResources.textLight,
                          fontSize: Dimensions.fontSizeSmall,
                        ),
                      ),
                      Switch(
                        value: autoScroll,
                        activeThumbColor: const Color(0xff9D1911),
                        onChanged: (v) => setState(() => autoScroll = v),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
        ),
      ),
    );
  }

  Widget _meaningContent() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xffF3D8B3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _meaning
            .map(
              (line) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text(
                  line,
                  style: avenirNextRegular.copyWith(
                    color: ColorResources.textLight,
                    fontSize: Dimensions.fontSizeDefault,
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _infoContent() {
    final rows = {
      "Deity": "Maa Tripura Sundari",
      "Best Time": "Morning & Evening",
      "Duration": _formatDuration(total),
      "Language": "Sanskrit / Hindi",
    };

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xffF3D8B3)),
      ),
      child: Column(
        children: rows.entries
            .map(
              (e) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      e.key,
                      style: avenirNextRegular.copyWith(
                        color: ColorResources.textLight,
                        fontSize: Dimensions.fontSizeDefault,
                      ),
                    ),
                    Text(
                      e.value,
                      style: cormorantInfantBold.copyWith(
                        color: ColorResources.blackColor,
                        fontSize: Dimensions.spacingSize16,
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  /// ---------------- ACTION ICONS ----------------
  Widget _actionIconsRow() {
    final actions = _isChalisa
        ? [
            {"icon": Icons.download_outlined, "label": "Download"},
            {"icon": Icons.bookmark_border, "label": "Bookmark"},
            {"icon": Icons.share_outlined, "label": "Share"},
            {"icon": Icons.repeat, "label": "Repeat"},
            {"icon": Icons.text_fields, "label": "Text Size"},
          ]
        : [
            {"icon": Icons.download_outlined, "label": "Download"},
            {"icon": Icons.playlist_add, "label": "Add to Playlist"},
            {"icon": Icons.share_outlined, "label": "Share"},
            {"icon": Icons.repeat, "label": "Repeat"},
            {"icon": Icons.bedtime_outlined, "label": "Sleep Timer"},
          ];

    return Row(
      children: actions.map((a) {
        final active = (a["label"] == "Repeat" && isRepeat) ||
            (a["label"] == "Bookmark" && isBookmarked);
        return Expanded(
          child: GestureDetector(
            onTap: () {
              switch (a["label"]) {
                case "Download":
                  _notify("Downloading ${widget.aarti['title']}...");
                  break;
                case "Add to Playlist":
                  _notify("Added to playlist");
                  break;
                case "Bookmark":
                  setState(() => isBookmarked = !isBookmarked);
                  _notify(isBookmarked ? "Bookmarked" : "Bookmark removed");
                  break;
                case "Share":
                  _notify("Sharing ${widget.aarti['title']}");
                  break;
                case "Repeat":
                  _toggleRepeat();
                  break;
                case "Sleep Timer":
                  _pickSleepTimer();
                  break;
                case "Text Size":
                  _pickTextSize();
                  break;
              }
            },
            child: Column(
              children: [
                Container(
                  height: 46,
                  width: 46,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: active ? const Color(0xff9D1911) : const Color(0xffF3D8B3),
                    ),
                    color: const Color(0xFFFFFBF2),
                  ),
                  child: Icon(
                    (a["label"] == "Bookmark" && isBookmarked)
                        ? Icons.bookmark
                        : a["icon"] as IconData,
                    color: const Color(0xff9D1911),
                    size: 20,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  a["label"] as String,
                  textAlign: TextAlign.center,
                  style: avenirNextRegular.copyWith(
                    color: ColorResources.blackColor,
                    fontSize: 9,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  /// ---------------- STICKY MINI PLAYER ----------------
  Widget _miniPlayerBar(String image, String title, String sub) {
    final progress = total.inSeconds > 0
        ? (position.inSeconds / total.inSeconds).clamp(0.0, 1.0)
        : 0.0;

    return Container(
      padding: const EdgeInsets.fromLTRB(10, 8, 14, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .08),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 3,
                backgroundColor: const Color(0xffF3D8B3),
                valueColor: const AlwaysStoppedAnimation(Color(0xff9D1911)),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(image, height: 42, width: 42, fit: BoxFit.cover),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: cormorantInfantBold.copyWith(
                          color: ColorResources.blackColor,
                          fontSize: Dimensions.spacingSize14,
                        ),
                      ),
                      Text(
                        sub,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: avenirNextRegular.copyWith(
                          color: ColorResources.textLight,
                          fontSize: 9,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => _openInRelated(-1),
                  child: Icon(Icons.skip_previous, color: ColorResources.blackColor, size: 24),
                ),
                const SizedBox(width: 6),
                GestureDetector(
                  onTap: _togglePlayPause,
                  child: Container(
                    height: 36,
                    width: 36,
                    decoration: const BoxDecoration(gradient: _redGradient, shape: BoxShape.circle),
                    child: Icon(
                      isPlaying ? Icons.pause : Icons.play_arrow,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                GestureDetector(
                  onTap: () => _openInRelated(1),
                  child: Icon(Icons.skip_next, color: ColorResources.blackColor, size: 24),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Row(
      children: [
        _gradientText(
          title,
          cormorantInfantBold.copyWith(fontSize: Dimensions.spacingSize18),
        ),
        const Spacer(),
        Text(
          "View All",
          style: avenirNextCyr.copyWith(
            color: ColorResources.kOrange,
            fontSize: Dimensions.fontSizeDefault,
          ),
        ),
      ],
    );
  }

  /// ---------------- RELATED AARTIS ----------------
  Widget _relatedRow() {
    return SizedBox(
      height: 128,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: widget.related.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final item = widget.related[index];
          return GestureDetector(
            onTap: () {
              final rest = widget.related.where((e) => e != item).toList();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => AartiPlayerScreen(aarti: item, related: rest),
                ),
              );
            },
            child: Container(
              width: 130,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xffF3D8B3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      item['image'] as String,
                      height: 68,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item['title'] as String,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: cormorantInfantBold.copyWith(
                      color: ColorResources.blackColor,
                      fontSize: Dimensions.spacingSize14,
                    ),
                  ),
                  Text(
                    item['plays'] as String? ?? '',
                    style: avenirNextRegular.copyWith(
                      color: ColorResources.textLight,
                      fontSize: 9,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
