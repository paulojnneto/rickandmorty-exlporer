class Character {
  const Character({
    required this.id,
    required this.name,
    required this.status,
    required this.species,
    required this.gender,
    required this.image,
  });
  factory Character.fromJson(Map<String, dynamic> json) => Character(
    id: (json['id'] as num?)?.toInt() ?? 0,
    name: json['name'] as String? ?? 'Desconhecido',
    status: json['status'] as String? ?? 'Desconhecido',
    species: json['species'] as String? ?? 'Desconhecida',
    gender: json['gender'] as String? ?? 'Desconhecido',
    image: json['image'] as String?,
  );
  final int id;
  final String name;
  final String status;
  final String species;
  final String gender;
  final String? image;
}
