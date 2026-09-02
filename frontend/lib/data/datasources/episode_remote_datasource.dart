import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants/app_constants.dart';
import '../../core/errors/app_exception.dart';
import '../models/episode.dart';

class EpisodeRemoteDatasource {
  EpisodeRemoteDatasource({http.Client? client})
    : _client = client ?? http.Client();
  final http.Client _client;
  Future<Episode> getEpisode(int episodeId) async {
    try {
      final response = await _client
          .get(Uri.parse('${AppConstants.backendUrl}/episode/$episodeId'))
          .timeout(const Duration(seconds: 10));
      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw HttpAppException(
          response.statusCode >= 500
              ? 'The server encountered a problem. Please try again.'
              : 'Episode not found or invalid.',
          response.statusCode,
        );
      }
      try {
        final json = jsonDecode(response.body);
        if (json is! Map<String, dynamic>) {
          throw const FormatException();
        }
        return Episode.fromJson(json);
      } on FormatException {
        throw const InvalidResponseException(
          'The server returned an invalid response.',
        );
      }
    } on TimeoutException {
      throw const TimeoutAppException(
        'The request took too long. Please try again.',
      );
    } on http.ClientException {
      throw const ConnectionAppException('Could not connect to the backend.');
    } on AppException {
      rethrow;
    } catch (_) {
      throw const ConnectionAppException('Could not connect to the backend.');
    }
  }
}
