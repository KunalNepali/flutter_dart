import 'package:flutter/material.dart';

class SeekBar extends StatelessWidget {
  final Duration currentPosition;
  final Duration duration;
  final ValueChanged<Duration> onSeek;
  final Color? activeColor;

  const SeekBar({
    Key? key,
    required this.currentPosition,
    required this.duration,
    required this.onSeek,
    this.activeColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progress = duration.inSeconds > 0
        ? currentPosition.inSeconds / duration.inSeconds
        : 0.0;

    String formatDuration(Duration duration) {
      final minutes = duration.inMinutes.remainder(60);
      final seconds = duration.inSeconds.remainder(60);
      return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }

    return Column(
      children: [
        Slider(
          value: progress.clamp(0.0, 1.0),
          onChanged: (value) {
            final newPosition = Duration(
              seconds: (value * duration.inSeconds).toInt(),
            );
            onSeek(newPosition);
          },
          min: 0,
          max: 1,
          activeColor: activeColor ?? theme.colorScheme.primary,
          inactiveColor: theme.colorScheme.surfaceVariant,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                formatDuration(currentPosition),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                formatDuration(duration),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}