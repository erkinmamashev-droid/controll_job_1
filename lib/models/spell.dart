class Spell {
  const Spell({required this.name, required this.use});

  final String name;
  final String use;

  factory Spell.fromJson(Map<String, dynamic> json) {
    return Spell(
      name: json['spell'] as String? ?? '',
      use: json['use'] as String? ?? '',
    );
  }
}
