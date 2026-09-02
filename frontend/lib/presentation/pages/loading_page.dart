import 'package:flutter/material.dart';

import '../../data/repositories/episode_repository.dart';
import 'episode_page.dart';

/// Camada opaca reutilizável que bloqueia a tela filha durante a animação.
class LoadingOverlay extends StatefulWidget {
  const LoadingOverlay({
    super.key,
    required this.child,
    this.visible = true,
    this.onFinished,
    this.backgroundColor = const Color(0xCCFFFFFF),
  });

  final Widget child;
  final bool visible;
  final VoidCallback? onFinished;
  final Color backgroundColor;

  @override
  State<LoadingOverlay> createState() => _LoadingOverlayState();
}

class _LoadingOverlayState extends State<LoadingOverlay>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final AnimationController _rotationController;
  late final Animation<double> _logoScale;
  late final Animation<double> _logoOpacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    );
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
    _logoScale = TweenSequence<double>([
      TweenSequenceItem(tween: ConstantTween(1), weight: 30),
      TweenSequenceItem(tween: Tween(begin: 1, end: 5), weight: 2),
    ]).animate(_controller);
    _logoOpacity = TweenSequence<double>([
      TweenSequenceItem(tween: ConstantTween(1), weight: 30),
      TweenSequenceItem(tween: Tween(begin: 1, end: 0), weight: 2),
    ]).animate(_controller);
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) widget.onFinished?.call();
    });
    if (widget.visible) _controller.forward();
  }

  @override
  void didUpdateWidget(covariant LoadingOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.visible && !oldWidget.visible) {
      _controller
        ..reset()
        ..forward();
      _rotationController
        ..reset()
        ..repeat();
    } else if (!widget.visible && oldWidget.visible) {
      _controller.stop();
      _rotationController.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        widget.child,
        if (widget.visible)
          Positioned.fill(
            child: AbsorbPointer(
              child: ColoredBox(
                color: widget.backgroundColor,
                child: Center(
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (context, _) => Opacity(
                      opacity: _logoOpacity.value,
                      child: Transform.scale(
                        scale: _logoScale.value,
                        child: RotationTransition(
                          turns: _rotationController,
                          child: Image.asset(
                            'assets/portal.png',
                            width: 450,
                            height: 450,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// Exemplo inicial: a tela real fica montada atrás do loading.
class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key, required this.repository});

  final EpisodeRepository repository;

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  bool _loading = true;

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      visible: _loading,
      onFinished: () => setState(() => _loading = false),
      child: EpisodePage(repository: widget.repository),
    );
  }
}
