import 'package:shared_preferences/shared_preferences.dart';
import '../models/music_track.dart';

class StorageService {
  static const String _tracksKey = 'music_tracks';
  static const String _playlistKey = 'current_playlist';
  static const String _settingsKey = 'app_settings';

  Future<void> saveTracks(List<MusicTrack> tracks) async {
    final prefs = await SharedPreferences.getInstance();
    final tracksJson = tracks.map((track) => track.toRawJson()).toList();
    await prefs.setStringList(_tracksKey, tracksJson);
  }

  Future<List<MusicTrack>> loadTracks() async {
    final prefs = await SharedPreferences.getInstance();
    final tracksJson = prefs.getStringList(_tracksKey) ?? [];
    
    return tracksJson
        .map((json) => MusicTrack.fromRawJson(json))
        .toList();
  }

  Future<void> saveCurrentPlaylist(List<String> trackIds) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_playlistKey, trackIds);
  }

  Future<List<String>> loadCurrentPlaylist() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_playlistKey) ?? [];
  }

  Future<void> saveSettings({
    bool? shuffle,
    bool? repeat,
    double? volume,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final settings = <String, dynamic>{};
    
    if (shuffle != null) settings['shuffle'] = shuffle;
    if (repeat != null) settings['repeat'] = repeat;
    if (volume != null) settings['volume'] = volume;
    
    await prefs.setString(_settingsKey, json.encode(settings));
  }

  Future<Map<String, dynamic>> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final settingsJson = prefs.getString(_settingsKey) ?? '{}';
    return json.decode(settingsJson);
  }

  Future<void> updateTrack(MusicTrack track) async {
    final tracks = await loadTracks();
    final index = tracks.indexWhere((t) => t.id == track.id);
    
    if (index != -1) {
      tracks[index] = track;
      await saveTracks(tracks);
    }
  }

  Future<void> deleteTrack(String trackId) async {
    final tracks = await loadTracks();
    tracks.removeWhere((track) => track.id == trackId);
    await saveTracks(tracks);
  }
}