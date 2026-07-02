class OnboardingModel {
  final String image;
  final String header;
  final String title;
  final String subtitle;
  final List<String> features;
  final String buttonText;
  final String group;
  final double titleFontSize;

  OnboardingModel({
    required this.image,
    this.header = '',
    required this.title,
    required this.subtitle,
    required this.features,
    required this.buttonText,
    required this.group,
    this.titleFontSize = 36,
  });
}
