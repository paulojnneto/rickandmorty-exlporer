import 'package:flutter/material.dart';
import 'data/datasources/episode_remote_datasource.dart';
import 'data/repositories/episode_repository_impl.dart';
import 'data/repositories/episode_repository.dart';
import 'presentation/pages/episode_page.dart';

void main() =>
    runApp(MyApp(repository: EpisodeRepositoryImpl(EpisodeRemoteDatasource())));

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.repository});
  final EpisodeRepository repository;
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Rick and Morty Explorer',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff5b21b6)),
      useMaterial3: true,
      scaffoldBackgroundColor: const Color(0xfff7f5fb),
    ),
    home: EpisodePage(repository: repository),
  );
}
