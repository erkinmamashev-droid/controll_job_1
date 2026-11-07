class Character {
  const Character({
    required this.fullName,
    required this.nickname,
    required this.house,
    required this.actor,
    required this.children,
    required this.image,
    required this.birthdate,
  });

  final String fullName;
  final String nickname;
  final String house;
  final String actor;
  final List<String> children;
  final String image;
  final String birthdate;

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      fullName: json['fullName'] as String? ?? '',
      nickname: json['nickname'] as String? ?? '',
      house: json['hogwartsHouse'] as String? ?? '',
      actor: json['interpretedBy'] as String? ?? '',
      children: (json['children'] as List<dynamic>? ?? const [])
          .map((child) => child as String)
          .toList(),
      image: json['image'] as String? ?? '',
      birthdate: json['birthdate'] as String? ?? '',
    );
  }
}
