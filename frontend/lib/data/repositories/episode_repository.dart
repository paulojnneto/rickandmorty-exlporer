import '../models/episode.dart';

abstract interface class EpisodeRepository {
  Future<Episode> getEpisode(int episodeId);
}
