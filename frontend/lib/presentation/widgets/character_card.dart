import 'package:flutter/material.dart';
import '../../data/models/character.dart';

class CharacterCard extends StatelessWidget {
  const CharacterCard({super.key, required this.character});
  final Character character;
  @override
  Widget build(BuildContext context) => Card(
    clipBehavior: Clip.antiAlias,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AspectRatio(
          aspectRatio: 1.35,
          child: character.image == null || character.image!.isEmpty
              ? const _UnavailableImage()
              : Image.network(
                  character.image!,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => const _UnavailableImage(),
                ),
        ),
        Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                character.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
              const SizedBox(height: 10),
              _InfoLine('Status', character.status),
              _InfoLine('Espécie', character.species),
              _InfoLine('Gênero', character.gender),
            ],
          ),
        ),
      ],
    ),
  );
}

class _UnavailableImage extends StatelessWidget {
  const _UnavailableImage();
  @override
  Widget build(BuildContext context) => Container(
    color: Theme.of(context).colorScheme.surfaceContainerHighest,
    alignment: Alignment.center,
    child: const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.image_not_supported_outlined, size: 36),
        SizedBox(height: 6),
        Text('Imagem indisponível'),
      ],
    ),
  );
}

class _InfoLine extends StatelessWidget {
  const _InfoLine(this.label, this.value);
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 4),
    child: Text(
      '$label: $value',
      style: TextStyle(color: Colors.grey.shade700),
    ),
  );
}
