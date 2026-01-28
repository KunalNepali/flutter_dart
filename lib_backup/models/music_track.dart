import 'dart:convert';

class MusicTrack {
  final String id;
  final String title;
  final String artist;
  final String album;
  final String audioPath;
  final int duration; // in seconds
  final String? coverImage;
  final DateTime dateAdded;
  bool isFavorite;
  int playCount;

  MusicTrack({
    required this.id,
    required this.title,
    required this.artist,
    required this.album,
    required this.audioPath,
    required this.duration,
    this.coverImage,
    required this.dateAdded,
    this.isFavorite = false,
    this.playCount = 0,
  });

  MusicTrack copyWith({
    String? id,
    String? title,
    String? artist,
    String? album,
    String? audioPath,
    int? duration,
    String? coverImage,
    DateTime? dateAdded,
    bool? isFavorite,
    int? playCount,
  }) {
    return MusicTrack(
      id: id ?? this.id,
      title: title ?? this.title,
      artist: artist ?? this.artist,
      album: album ?? this.album,
      audioPath: audioPath ?? this.audioPath,
      duration: duration ?? this.duration,
      coverImage: coverImage ?? this.coverImage,
      dateAdded: dateAdded ?? this.dateAdded,
      isFavorite: isFavorite ?? this.isFavorite,
      playCount: playCount ?? this.playCount,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'artist': artist,
      'album': album,
      'audioPath': audioPath,
      'duration': duration,
      'coverImage': coverImage,
      'dateAdded': dateAdded.toIso8601String(),
      'isFavorite': isFavorite,
      'playCount': playCount,
    };
  }

  factory MusicTrack.fromJson(Map<String, dynamic> json) {
    return MusicTrack(
      id: json['id'],
      title: json['title'],
      artist: json['artist'],
      album: json['album'],
      audioPath: json['audioPath'],
      duration: json['duration'],
      coverImage: json['coverImage'],
      dateAdded: DateTime.parse(json['dateAdded']),
      isFavorite: json['isFavorite'],
      playCount: json['playCount'],
    );
  }

  String toRawJson() => json.encode(toJson());
  factory MusicTrack.fromRawJson(String str) =>
      MusicTrack.fromJson(json.decode(str));

  @override
  String toString() {
    return 'MusicTrack(title: $title, artist: $artist, duration: $duration)';
  }
}