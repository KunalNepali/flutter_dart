import 'package:flutter/material.dart';

class PlayerControls extends StatelessWidget {
  final bool isPlaying;
  final bool isShuffled;
  final bool isRepeating;
  final VoidCallback onPlayPause;
  final VoidCallback onNext;
  final VoidCallback onPrevious;
  final VoidCallback onShuffle;
  final VoidCallback onRepeat;
  final double volume;
  final ValueChanged<double> onVolumeChanged;

  const PlayerControls({
    Key? key,
    required this.isPlaying,
    required this.isShuffled,
    required this.isRepeating,
    required this.onPlayPause,
    required this.onNext,
    required this.onPrevious,
    required this.onShuffle,
    required this.onRepeat,
    required this.volume,
    required this.onVolumeChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(
                isShuffled ? Icons.shuffle_on : Icons.shuffle,
                color: isShuffled
                    ? Theme.of(context).colorScheme.primary
                    : null,
              ),
              onPressed: onShuffle,
              iconSize: 30,
            ),
            IconButton(
              icon: const Icon(Icons.skip_previous),
              onPressed: onPrevious,
              iconSize: 40,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.primary,
              ),
              child: IconButton(
                icon: Icon(
                  isPlaying ? Icons.pause : Icons.play_arrow,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
                onPressed: onPlayPause,
                iconSize: 36,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.skip_next),
              onPressed: onNext,
              iconSize: 40,
            ),
            IconButton(
              icon: Icon(
                isRepeating ? Icons.repeat_one : Icons.repeat,
                color: isRepeating
                    ? Theme.of(context).colorScheme.primary
                    : null,
              ),
              onPressed: onRepeat,
              iconSize: 30,
            ),
          ],
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Row(
            children: [
              Icon(
                Icons.volume_down,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              Expanded(
                child: Slider(
                  value: volume,
                  onChanged: onVolumeChanged,
                  min: 0,
                  max: 1,
                  divisions: 10,
                ),
              ),
              Icon(
                Icons.volume_up,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ],
    );
  }
}