import '../datasources/episode_remote_datasource.dart';
import '../models/episode.dart';
import 'episode_repository.dart';

class EpisodeRepositoryImpl implements EpisodeRepository {
  const EpisodeRepositoryImpl(this.datasource);
  final EpisodeRemoteDatasource datasource;
  @override
  Future<Episode> getEpisode(int episodeId) => datasource.getEpisode(episodeId);
}
