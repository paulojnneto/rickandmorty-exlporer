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
        String? resource;
        try {
          final payload = jsonDecode(response.body);
          resource = payload is Map<String, dynamic>
              ? payload['resource'] as String?
              : null;
        } catch (_) {
          // The status code still provides a safe fallback message.
        }
        throw HttpAppException(
          _messageForHttpError(response.statusCode, resource),
          response.statusCode,
          resource: resource ?? 'episode',
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

  String _messageForHttpError(int statusCode, String? resource) {
    final label = switch (resource) {
      'character' => 'character',
      'location' => 'location',
      _ => 'episode',
    };
    if (statusCode == 404) return 'Could not find the requested $label.';
    return 'Could not load the $label. Please try again.';
  }
}
