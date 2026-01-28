import 'package:log_screen_ui/models/log_entry.dart';

class AppState {
  final List<LogEntry> logs;
  final Set<LogLevel> visibleLevels;
  final String? searchQuery;
  final DateTime? dateFilter;

  const AppState({
    required this.logs,
    this.visibleLevels = const {
      LogLevel.info,
      LogLevel.warning,
      LogLevel.error,
      LogLevel.debug,
    },
    this.searchQuery,
    this.dateFilter,
  });

  AppState copyWith({
    List<LogEntry>? logs,
    Set<LogLevel>? visibleLevels,
    String? searchQuery,
    DateTime? dateFilter,
  }) {
    return AppState(
      logs: logs ?? this.logs,
      visibleLevels: visibleLevels ?? this.visibleLevels,
      searchQuery: searchQuery ?? this.searchQuery,
      dateFilter: dateFilter ?? this.dateFilter,
    );
  }

  List<LogEntry> get filteredLogs {
    var filtered = logs;

    // Filter by level
    if (visibleLevels.isNotEmpty) {
      filtered = filtered.where((log) => visibleLevels.contains(log.level)).toList();
    }

    // Filter by search query
    if (searchQuery != null && searchQuery!.isNotEmpty) {
      final query = searchQuery!.toLowerCase();
      filtered = filtered.where((log) =>
          log.message.toLowerCase().contains(query) ||
          (log.source?.toLowerCase() ?? '').contains(query)).toList();
    }

    // Filter by date
    if (dateFilter != null) {
      filtered = filtered.where((log) =>
          log.timestamp.year == dateFilter!.year &&
          log.timestamp.month == dateFilter!.month &&
          log.timestamp.day == dateFilter!.day).toList();
    }

    return filtered.reversed.toList(); // Newest first
  }
}