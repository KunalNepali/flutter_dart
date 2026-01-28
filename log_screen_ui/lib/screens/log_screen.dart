import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:log_screen_ui/models/log_entry.dart';
import 'package:log_screen_ui/services/log_controller.dart';
import 'package:log_screen_ui/widgets/log_level_filter.dart';
import 'package:log_screen_ui/widgets/log_list_tile.dart';
import 'package:log_screen_ui/widgets/search_bar.dart';

class LogScreen extends ConsumerStatefulWidget {
  const LogScreen({super.key});

  @override
  ConsumerState<LogScreen> createState() => _LogScreenState();
}

class _LogScreenState extends ConsumerState<LogScreen> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(appStateProvider);
    final notifier = ref.read(appStateProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('System Logs'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              final log = LogEntry.create(
                level: LogLevel.info,
                message: 'Sample log entry created at ${DateTime.now()}',
                source: 'User Action',
              );
              await notifier.addLog(log);
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _showClearDialog(context, notifier),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const LogSearchBar(),
                const SizedBox(height: 16),
                Text(
                  'Filter by Level:',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 8),
                const LogLevelFilter(),
              ],
            ),
          ),
          Expanded(
            child: state.filteredLogs.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inbox_outlined,
                          size: 64,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No logs found',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(
                          state.searchQuery != null
                              ? 'Try changing your search'
                              : 'Add your first log',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.outline,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: state.filteredLogs.length,
                    itemBuilder: (context, index) {
                      final log = state.filteredLogs[index];
                      return LogListTile(
                        log: log,
                        onDelete: () => notifier.deleteLog(log.id),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final levels = [LogLevel.info, LogLevel.warning, LogLevel.error, LogLevel.debug];
          final randomLevel = levels[(DateTime.now().millisecond % 4)];
          
          await notifier.addLog(
            LogEntry.create(
              level: randomLevel,
              message: 'Automated log entry ${DateTime.now().millisecond}',
              source: 'System',
              metadata: {'randomValue': DateTime.now().millisecond},
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Sample'),
      ),
    );
  }

  Future<void> _showClearDialog(
      BuildContext context, AppStateNotifier notifier) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Logs'),
        content: const Text('Are you sure you want to delete all logs?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              notifier.clearLogs();
              Navigator.pop(context);
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }
}