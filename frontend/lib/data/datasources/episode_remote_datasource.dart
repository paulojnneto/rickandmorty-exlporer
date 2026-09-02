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
              ? 'O servidor encontrou um problema. Tente novamente.'
              : 'Episódio não encontrado ou inválido.',
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
          'A resposta do servidor é inválida.',
        );
      }
    } on TimeoutException {
      throw const TimeoutAppException(
        'A busca demorou demais. Tente novamente.',
      );
    } on http.ClientException {
      throw const ConnectionAppException(
        'Não foi possível conectar ao backend.',
      );
    } on AppException {
      rethrow;
    } catch (_) {
      throw const ConnectionAppException(
        'Não foi possível conectar ao backend.',
      );
    }
  }
}
