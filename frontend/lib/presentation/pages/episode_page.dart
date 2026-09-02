import 'package:flutter/material.dart';
import '../../data/repositories/episode_repository.dart';
import '../controllers/episode_controller.dart';
import '../widgets/character_card.dart';

class EpisodePage extends StatefulWidget {
  const EpisodePage({super.key, required this.repository});
  final EpisodeRepository repository;
  @override
  State<EpisodePage> createState() => _EpisodePageState();
}

class _EpisodePageState extends State<EpisodePage> {
  late final EpisodeController controller;
  final idController = TextEditingController();
  @override
  void initState() {
    super.initState();
    controller = EpisodeController(widget.repository);
  }

  @override
  void dispose() {
    idController.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rick and Morty Explorer')),
      body: AnimatedBuilder(
        animation: controller,
        builder: (context, _) => SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Explore an episode',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  const Text('Enter an episode ID to see its characters.'),
                  const SizedBox(height: 24),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final input = TextField(
                        controller: idController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Episode ID',
                          hintText: 'e.g. 28',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                        ),
                        onSubmitted: (_) =>
                            controller.search(idController.text),
                      );
                      final button = SizedBox(
                        height: 56,
                        child: FilledButton.icon(
                          style: FilledButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: controller.status == EpisodeStatus.loading
                              ? null
                              : () => controller.search(idController.text),
                          icon: controller.status == EpisodeStatus.loading
                              ? const SizedBox.square(
                                  dimension: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Icon(Icons.search),
                          label: const Text('Search'),
                        ),
                      );
                      return constraints.maxWidth < 500
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                input,
                                const SizedBox(height: 12),
                                button,
                              ],
                            )
                          : Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(child: input),
                                const SizedBox(width: 12),
                                button,
                              ],
                            );
                    },
                  ),
                  if (controller.errorMessage != null) ...[
                    const SizedBox(height: 18),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.errorContainer,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        controller.errorMessage!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onErrorContainer,
                        ),
                      ),
                    ),
                  ],
                  if (controller.status == EpisodeStatus.success &&
                      controller.characters.isNotEmpty) ...[
                    const SizedBox(height: 32),
                    Text(
                      'Characters in episode ${controller.episodeId}',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 14),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final count = constraints.maxWidth >= 900
                            ? 4
                            : constraints.maxWidth >= 600
                            ? 3
                            : 2;
                        return GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: count,
                                crossAxisSpacing: 14,
                                mainAxisSpacing: 14,
                                childAspectRatio: .68,
                              ),
                          itemCount: controller.characters.length,
                          itemBuilder: (_, index) => CharacterCard(
                            character: controller.characters[index],
                          ),
                        );
                      },
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
