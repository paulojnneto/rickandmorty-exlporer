import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/data/models/character.dart';
import 'package:frontend/data/models/episode.dart';
import 'package:frontend/data/repositories/episode_repository.dart';
import 'package:frontend/main.dart';

class _FakeRepository implements EpisodeRepository {
  @override
  Future<Episode> getEpisode(int episodeId) async => const Episode(
    id: 28,
    characters: [
      Character(
        id: 1,
        name: 'Rick Sanchez',
        status: 'Alive',
        species: 'Human',
        gender: 'Male',
        image: null,
      ),
    ],
  );
}

void main() {
  testWidgets('busca e exibe um personagem', (tester) async {
    await tester.pumpWidget(MyApp(repository: _FakeRepository()));
    await tester.enterText(find.byType(TextField), '28');
    await tester.tap(find.text('Buscar'));
    await tester.pumpAndSettle();
    expect(find.text('Rick Sanchez'), findsOneWidget);
    expect(find.text('Status: Alive'), findsOneWidget);
    expect(find.text('Imagem indisponível'), findsOneWidget);
  });
}
