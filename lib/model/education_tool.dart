class EducationTool {
  final int id;
  final String name;
  final String description;
  final String imageUrl;

  EducationTool({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
  });

  factory EducationTool.fromJson(Map<String, dynamic> json) {
    return EducationTool(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      imageUrl:
          'https://demos.creative-tim.com/soft-ui-design-system-pro/assets/img/curved-images/curved11.jpg',
    );
  }
}
