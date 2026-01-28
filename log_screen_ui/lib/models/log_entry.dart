import 'package:intl/intl.dart';

enum LogLevel {
  info,
  warning,
  error,
  debug,
}

extension LogLevelExtension on LogLevel {
  String get name {
    switch (this) {
      case LogLevel.info:
        return 'INFO';
      case LogLevel.warning:
        return 'WARNING';
      case LogLevel.error:
        return 'ERROR';
      case LogLevel.debug:
        return 'DEBUG';
    }
  }

  String get emoji {
    switch (this) {
      case LogLevel.info:
        return 'ℹ️';
      case LogLevel.warning:
        return '⚠️';
      case LogLevel.error:
        return '❌';
      case LogLevel.debug:
        return '🐛';
    }
  }
}

class LogEntry {
  final String id;
  final DateTime timestamp;
  final LogLevel level;
  final String message;
  final String? source;
  final Map<String, dynamic>? metadata;

  LogEntry({
    required this.id,
    required this.timestamp,
    required this.level,
    required this.message,
    this.source,
    this.metadata,
  });

  factory LogEntry.create({
    required LogLevel level,
    required String message,
    String? source,
    Map<String, dynamic>? metadata,
  }) {
    return LogEntry(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      timestamp: DateTime.now(),
      level: level,
      message: message,
      source: source,
      metadata: metadata,
    );
  }

  String get formattedTime => DateFormat('HH:mm:ss').format(timestamp);
  String get formattedDate => DateFormat('yyyy-MM-dd').format(timestamp);

  Map<String, dynamic> toJson() => {
        'id': id,
        'timestamp': timestamp.toIso8601String(),
        'level': level.index,
        'message': message,
        'source': source,
        'metadata': metadata,
      };

  factory LogEntry.fromJson(Map<String, dynamic> json) => LogEntry(
        id: json['id'],
        timestamp: DateTime.parse(json['timestamp']),
        level: LogLevel.values[json['level']],
        message: json['message'],
        source: json['source'],
        metadata: json['metadata'],
      );
}