import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/core/errors/app_exception.dart';
import 'package:frontend/data/models/character.dart';
import 'package:frontend/data/models/episode.dart';
import 'package:frontend/data/repositories/episode_repository.dart';
import 'package:frontend/presentation/controllers/episode_controller.dart';

class _Repository implements EpisodeRepository {
  _Repository(this.result);
  final Object result;
  @override
  Future<Episode> getEpisode(int episodeId) async {
    if (result is Exception) throw result;
    return result as Episode;
  }
}

void main() {
  test('validates empty, positive and whole-number IDs', () {
    expect(EpisodeController.validateId(''), isNotNull);
    expect(EpisodeController.validateId('0'), isNotNull);
    expect(EpisodeController.validateId('-1'), isNotNull);
    expect(EpisodeController.validateId('abc'), isNotNull);
    expect(EpisodeController.validateId('28'), isNull);
  });
  test('search success', () async {
    final controller = EpisodeController(
      _Repository(
        const Episode(
          id: 28,
          characters: [
            Character(
              id: 1,
              name: 'Rick',
              status: 'Alive',
              species: 'Human',
              gender: 'Male',
              image: null,
            ),
          ],
        ),
      ),
    );
    await controller.search('28');
    expect(controller.status, EpisodeStatus.success);
    expect(controller.characters, hasLength(1));
  });
  test('HTTP error', () async {
    final controller = EpisodeController(
      _Repository(const HttpAppException('HTTP failure', 404)),
    );
    await controller.search('28');
    expect(controller.status, EpisodeStatus.error);
    expect(controller.errorMessage, 'HTTP failure');
  });
  test('connection error', () async {
    final controller = EpisodeController(
      _Repository(const ConnectionAppException('No connection')),
    );
    await controller.search('28');
    expect(controller.status, EpisodeStatus.error);
    expect(controller.errorMessage, 'No connection');
  });
}
