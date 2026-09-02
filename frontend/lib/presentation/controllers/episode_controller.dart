import 'package:flutter/foundation.dart';
import '../../core/errors/app_exception.dart';
import '../../data/models/character.dart';
import '../../data/repositories/episode_repository.dart';

enum EpisodeStatus { idle, loading, success, error }

class EpisodeController extends ChangeNotifier {
  EpisodeController(this.repository);
  final EpisodeRepository repository;
  EpisodeStatus status = EpisodeStatus.idle;
  List<Character> characters = const [];
  String? errorMessage;
  int? episodeId;
  static String? validateId(String value) {
    final input = value.trim();
    if (input.isEmpty) return 'Please enter an episode ID.';
    if (!RegExp(r'^\d+$').hasMatch(input) || int.tryParse(input) == 0) {
      return 'Please enter a positive whole number.';
    }
    return null;
  }

  Future<void> search(String value) async {
    if (status == EpisodeStatus.loading) return;
    final validation = validateId(value);
    if (validation != null) {
      status = EpisodeStatus.error;
      errorMessage = validation;
      notifyListeners();
      return;
    }
    status = EpisodeStatus.loading;
    errorMessage = null;
    notifyListeners();
    try {
      final result = await repository.getEpisode(int.parse(value.trim()));
      episodeId = result.id;
      characters = result.characters;
      status = EpisodeStatus.success;
      if (characters.isEmpty) {
        errorMessage = 'This episode has no characters.';
      }
    } on AppException catch (error) {
      status = EpisodeStatus.error;
      errorMessage = error.message;
    } catch (_) {
      status = EpisodeStatus.error;
      errorMessage = 'The search could not be completed.';
    }
    notifyListeners();
  }
}
