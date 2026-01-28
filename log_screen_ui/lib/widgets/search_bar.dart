import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:log_screen_ui/services/log_controller.dart';

class LogSearchBar extends ConsumerWidget {
  const LogSearchBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchQuery = ref.watch(appStateProvider.select((state) => state.searchQuery));

    return TextField(
      decoration: InputDecoration(
        hintText: 'Search logs...',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: searchQuery != null && searchQuery.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () =>
                    ref.read(appStateProvider.notifier).setSearchQuery(null),
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
      ),
      onChanged: (value) =>
          ref.read(appStateProvider.notifier).setSearchQuery(value),
    );
  }
}