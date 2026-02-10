import 'package:just_audio/just_audio.dart';
import '../models/music_track.dart';

class AudioService {
  final AudioPlayer _audioPlayer = AudioPlayer();
  List<MusicTrack> _playlist = [];
  int _currentIndex = 0;
  bool _isShuffled = false;
  bool _isRepeating = false;
  double _volume = 1.0;

  // Use dynamic type for now to avoid type errors
  Stream get playerStateStream => _audioPlayer.playerStateStream;
  Stream<Duration?> get durationStream => _audioPlayer.durationStream;
  Stream<Duration> get positionStream => _audioPlayer.positionStream;

  AudioService() {
    _setupAudioPlayer();
  }

  void _setupAudioPlayer() {
    _audioPlayer.playerStateStream.listen((state) {
      // Check processing state dynamically
      try {
        // Try to access processingState property
        final processingState = state.processingState;
        if (processingState.toString().contains('completed') || 
            processingState.toString().contains('Completed')) {
          _playNext();
        }
      } catch (e) {
        print('Error checking processing state: $e');
      }
    });
    
    _audioPlayer.setVolume(_volume);
  }

  Future<void> loadPlaylist(List<MusicTrack> playlist, {int startIndex = 0}) async {
    _playlist = playlist;
    if (_playlist.isEmpty) return;
    
    _currentIndex = startIndex.clamp(0, playlist.length - 1);
    await _loadCurrentTrack();
  }

  Future<void> _loadCurrentTrack() async {
    if (_playlist.isEmpty) return;
    
    final track = _playlist[_currentIndex];
    try {
      // Try simpler method first
      await _audioPlayer.setAsset(track.audioPath);
    } catch (e) {
      print('Error loading track with setAsset: $e');
      try {
        // Alternative method
        await _audioPlayer.setAudioSource(
          AudioSource.uri(Uri.parse('asset:///${track.audioPath}')),
        );
      } catch (e2) {
        print('Error loading track with setAudioSource: $e2');
      }
    }
  }

  Future<void> play() async {
    try {
      await _audioPlayer.play();
    } catch (e) {
      print('Error playing: $e');
    }
  }

  Future<void> pause() async {
    await _audioPlayer.pause();
  }

  Future<void> stop() async {
    await _audioPlayer.stop();
  }

  Future<void> seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  Future<void> _playNext() async {
    if (_playlist.isEmpty) return;
    
    if (_isRepeating) {
      await _audioPlayer.seek(Duration.zero);
      await play();
    } else {
      _currentIndex = (_currentIndex + 1) % _playlist.length;
      await _loadCurrentTrack();
      await play();
    }
  }

  Future<void> playNext() async {
    if (_playlist.isEmpty) return;
    
    _currentIndex = (_currentIndex + 1) % _playlist.length;
    await _loadCurrentTrack();
    await play();
  }

  Future<void> playPrevious() async {
    if (_playlist.isEmpty) return;
    
    final currentPosition = await _audioPlayer.position;
    if (currentPosition.inSeconds > 3) {
      await seek(Duration.zero);
    } else {
      _currentIndex = (_currentIndex - 1 + _playlist.length) % _playlist.length;
      await _loadCurrentTrack();
      await play();
    }
  }

  Future<void> toggleShuffle() async {
    _isShuffled = !_isShuffled;
    if (_isShuffled && _playlist.length > 1) {
      // Create a shuffled copy of indices
      final List<MusicTrack> shuffled = List.from(_playlist)..shuffle();
      _playlist = shuffled;
      _currentIndex = 0;
    }
  }

  Future<void> toggleRepeat() async {
    _isRepeating = !_isRepeating;
  }

  Future<void> setVolume(double volume) async {
    _volume = volume.clamp(0.0, 1.0);
    await _audioPlayer.setVolume(_volume);
  }

  Future<void> dispose() async {
    await _audioPlayer.dispose();
  }

  MusicTrack? get currentTrack {
    if (_playlist.isEmpty) return null;
    return _playlist[_currentIndex];
  }

  bool get isPlaying => _audioPlayer.playing;
  bool get isShuffled => _isShuffled;
  bool get isRepeating => _isRepeating;
  double get volume => _volume;
}