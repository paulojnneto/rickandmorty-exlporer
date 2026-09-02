import 'character.dart';

class Episode {
  const Episode({required this.id, required this.characters});
  factory Episode.fromJson(Map<String, dynamic> json) {
    final raw = json['characters'];
    if (json['id'] is! num || raw is! List) throw const FormatException();
    return Episode(
      id: (json['id'] as num).toInt(),
      characters: raw
          .whereType<Map<String, dynamic>>()
          .map(Character.fromJson)
          .toList(),
    );
  }
  final int id;
  final List<Character> characters;
}
