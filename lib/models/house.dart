class House {
  const House({
    required this.name,
    required this.emoji,
    required this.founder,
    required this.colors,
    required this.animal,
  });

  final String name;
  final String emoji;
  final String founder;
  final List<String> colors;
  final String animal;

  factory House.fromJson(Map<String, dynamic> json) {
    return House(
      name: json['house'] as String? ?? '',
      emoji: json['emoji'] as String? ?? '',
      founder: json['founder'] as String? ?? '',
      colors: (json['colors'] as List<dynamic>? ?? const [])
          .map((color) => color as String)
          .toList(),
      animal: json['animal'] as String? ?? '',
    );
  }
}
