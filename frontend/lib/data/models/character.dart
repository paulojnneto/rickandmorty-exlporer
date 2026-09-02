class Place {
  const Place({
    required this.name,
    required this.type,
    required this.dimension,
  });
  factory Place.fromJson(Map<String, dynamic>? json) => Place(
    name: json?['name'] as String? ?? 'Unknown',
    type: json?['type'] as String? ?? 'Unknown',
    dimension: json?['dimension'] as String? ?? 'Unknown',
  );
  final String name;
  final String type;
  final String dimension;
}

class Character {
  const Character({
    required this.id,
    required this.name,
    required this.status,
    required this.species,
    required this.gender,
    required this.image,
    required this.origin,
    required this.location,
  });
  factory Character.fromJson(Map<String, dynamic> json) => Character(
    id: (json['id'] as num?)?.toInt() ?? 0,
    name: json['name'] as String? ?? 'Unknown',
    status: json['status'] as String? ?? 'Unknown',
    species: json['species'] as String? ?? 'Unknown',
    gender: json['gender'] as String? ?? 'Unknown',
    image: json['image'] as String?,
    origin: Place.fromJson(json['origin'] as Map<String, dynamic>?),
    location: Place.fromJson(json['location'] as Map<String, dynamic>?),
  );
  final int id;
  final String name;
  final String status;
  final String species;
  final String gender;
  final String? image;
  final Place origin;
  final Place location;
}
