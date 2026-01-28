import 'dart:io';
import 'package:path/path.dart';
import '../models/music_track.dart';

class AudioScanner {
  static Future<List<MusicTrack>> scanAudioFiles() async {
    final List<MusicTrack> tracks = [];
    
    // For demo, create sample tracks
    // In real app, you would scan the directory
    
    final audioFiles = [
      'assets/audio/file/song1.mp3',
      'assets/audio/file/song2.mp3',
      // Add all your actual files
    ];
    
    for (var i = 0; i < audioFiles.length; i++) {
      final path = audioFiles[i];
      final fileName = basename(path).replaceAll('.mp3', '');
      
      tracks.add(MusicTrack(
        id: DateTime.now().millisecondsSinceEpoch.toString() + i.toString(),
        title: fileName,
        artist: _extractArtist(fileName),
        album: 'My Music',
        audioPath: path,
        duration: 180, // Default duration
        dateAdded: DateTime.now(),
      ));
    }
    
    return tracks;
  }
  
  static String _extractArtist(String fileName) {
    // Simple extraction logic
    if (fileName.contains('-')) {
      return fileName.split('-')[0].trim();
    }
    return 'Unknown Artist';
  }
}