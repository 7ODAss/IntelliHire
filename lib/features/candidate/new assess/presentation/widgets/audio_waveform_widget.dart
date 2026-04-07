import 'dart:math';
import 'package:flutter/material.dart';

/// Animated waveform bars shown during recording.
/// StatefulWidget: owns AnimationController (ticker resource).
class AudioWaveformWidget extends StatefulWidget {
  final bool isAnimating;
  final Color color;
  final int barCount;

  const AudioWaveformWidget({
    super.key,
    required this.isAnimating,
    this.color = const Color(0xFF3B82F6),
    this.barCount = 28,
  });

  @override
  State<AudioWaveformWidget> createState() => _AudioWaveformWidgetState();
}

class _AudioWaveformWidgetState extends State<AudioWaveformWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  final _random = Random();
  late List<double> _heights;

  @override
  void initState() {
    super.initState();
    _heights = List.generate(widget.barCount, (_) => _randomHeight());
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed && widget.isAnimating) {
          _randomize();
          _controller.forward(from: 0);
        }
      });
    if (widget.isAnimating) _controller.forward();
  }

  void _randomize() {
    setState(() {
      _heights = List.generate(widget.barCount, (_) => _randomHeight());
    });
  }

  double _randomHeight() => 4 + _random.nextDouble() * 36;

  @override
  void didUpdateWidget(AudioWaveformWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isAnimating && !oldWidget.isAnimating) {
      _controller.forward(from: 0);
    } else if (!widget.isAnimating && oldWidget.isAnimating) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (_, __) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: List.generate(widget.barCount, (i) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 1.5),
                width: 4,
                height: _heights[i],
                decoration: BoxDecoration(
                  color: widget.color.withOpacity(0.7 + 0.3 * (i % 3 == 0 ? 1 : 0)),
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}
