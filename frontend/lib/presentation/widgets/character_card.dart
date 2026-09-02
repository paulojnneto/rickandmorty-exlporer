import 'package:flutter/material.dart';
import '../../data/models/character.dart';

class CharacterCard extends StatefulWidget {
  const CharacterCard({super.key, required this.character});
  final Character character;

  @override
  State<CharacterCard> createState() => _CharacterCardState();
}

class _CharacterCardState extends State<CharacterCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedScale(
        scale: _isHovered ? 1.02 : 1,
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        child: Card(
          clipBehavior: Clip.antiAlias,
          elevation: _isHovered ? 8 : 1,
          shadowColor: colorScheme.primary.withValues(alpha: .3),
          surfaceTintColor: _isHovered
              ? colorScheme.primaryContainer
              : colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: _isHovered
                  ? colorScheme.primary.withValues(alpha: .65)
                  : Colors.transparent,
              width: 1.5,
            ),
          ),
          child: InkWell(
            onTap: () {
              setState(() => _isHovered = false);
              _showCharacterDialog(context);
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: 1.35,
                  child:
                      widget.character.image == null ||
                          widget.character.image!.isEmpty
                      ? const _UnavailableImage()
                      : Image.network(
                          widget.character.image!,
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
                        widget.character.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _InfoLine('Status', widget.character.status),
                      _InfoLine('Species', widget.character.species),
                      _InfoLine('Gender', widget.character.gender),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showCharacterDialog(BuildContext context) {
    final character = widget.character;

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(character.name),
        content: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: 1.2,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: character.image == null || character.image!.isEmpty
                        ? const _UnavailableImage()
                        : Image.network(
                            character.image!,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) =>
                                const _UnavailableImage(),
                          ),
                  ),
                ),
                const SizedBox(height: 18),
                _InfoCard(
                  children: [
                    _DialogInfoLine('ID', '${character.id}'),
                    _DialogInfoLine('Status', character.status),
                    _DialogInfoLine('Species', character.species),
                    _DialogInfoLine('Gender', character.gender),
                  ],
                ),
                const SizedBox(height: 8),
                if (_samePlace(character.origin, character.location))
                  _PlaceInfo('Origin/Current Location', character.origin)
                else ...[
                  _PlaceInfo('Origin', character.origin),
                  const SizedBox(height: 10),
                  _PlaceInfo('Current Location', character.location),
                ],
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

bool _samePlace(Place first, Place second) =>
    first.name == second.name &&
    first.type == second.type &&
    first.dimension == second.dimension;

class _PlaceInfo extends StatelessWidget {
  const _PlaceInfo(this.label, this.place);
  final String label;
  final Place place;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        _DialogInfoLine('Name', place.name),
        _DialogInfoLine('Type', place.type),
        _DialogInfoLine('Dimension', place.dimension),
      ],
    ),
  );
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    ),
  );
}

class _DialogInfoLine extends StatelessWidget {
  const _DialogInfoLine(this.label, this.value);
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: '$label: ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(text: value),
        ],
      ),
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
        Text('Image unavailable'),
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
