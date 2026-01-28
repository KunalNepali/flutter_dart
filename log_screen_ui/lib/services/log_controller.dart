import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:log_screen_ui/models/app_state.dart';
import 'package:log_screen_ui/models/log_entry.dart';
import 'package:log_screen_ui/services/log_service.dart';

final logRepositoryProvider = Provider<LogRepository>((ref) {
  throw UnimplementedError('Provide LogRepository implementation');
});

final appStateProvider = StateNotifierProvider<AppStateNotifier, AppState>(
  (ref) => AppStateNotifier(ref.watch(logRepositoryProvider)),
);

class AppStateNotifier extends StateNotifier<AppState> {
  final LogRepository _repository;

  AppStateNotifier(this._repository) : super(const AppState(logs: [])) {
    _loadLogs();
  }

  Future<void> _loadLogs() async {
    final logs = await _repository.getLogs();
    state = state.copyWith(logs: logs);
  }

  Future<void> addLog(LogEntry log) async {
    await _repository.addLog(log);
    await _loadLogs();
  }

  Future<void> clearLogs() async {
    await _repository.clearLogs();
    state = state.copyWith(logs: []);
  }

  Future<void> deleteLog(String id) async {
    await _repository.deleteLog(id);
    await _loadLogs();
  }

  void toggleLevelVisibility(LogLevel level) {
    final newLevels = Set<LogLevel>.from(state.visibleLevels);
    if (newLevels.contains(level)) {
      newLevels.remove(level);
    } else {
      newLevels.add(level);
    }
    state = state.copyWith(visibleLevels: newLevels);
  }

  void setSearchQuery(String? query) {
    state = state.copyWith(searchQuery: query);
  }

  void setDateFilter(DateTime? date) {
    state = state.copyWith(dateFilter: date);
  }
}