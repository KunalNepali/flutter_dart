import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:log_screen_ui/models/log_entry.dart';
import 'package:log_screen_ui/services/log_controller.dart';

class LogLevelFilter extends ConsumerWidget {
  const LogLevelFilter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final visibleLevels = ref.watch(appStateProvider.select((state) => state.visibleLevels));

    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: LogLevel.values.map((level) {
        final isSelected = visibleLevels.contains(level);
        return FilterChip(
          label: Text('${level.emoji} ${level.name}'),
          selected: isSelected,
          onSelected: (_) =>
              ref.read(appStateProvider.notifier).toggleLevelVisibility(level),
          selectedColor: Theme.of(context).colorScheme.primaryContainer,
          showCheckmark: false,
        );
      }).toList(),
    );
  }
}