import 'package:just_audio/just_audio.dart';
import '../models/music_track.dart';

class AudioService {
  final AudioPlayer _audioPlayer = AudioPlayer();
  List<MusicTrack> _playlist = [];
  int _currentIndex = 0;
  bool _isShuffled = false;
  List<int> _shuffledIndices = [];
  bool _isRepeating = false;
  double _volume = 1.0;

  Stream<PlayerState> get playerStateStream => _audioPlayer.playerStateStream;
  Stream<Duration?> get durationStream => _audioPlayer.durationStream;
  Stream<Duration> get positionStream => _audioPlayer.positionStream;
  Stream<Duration?> get bufferedPositionStream => _audioPlayer.bufferedPositionStream;

  AudioService() {
    _setupAudioPlayer();
  }

  void _setupAudioPlayer() {
    _audioPlayer.playerStateStream.listen((PlayerState state) {
      if (state.processingState == ProcessingState.completed) {
        _playNext();
      }
    });
    
    _audioPlayer.setVolume(_volume);
  }

  Future<void> loadPlaylist(List<MusicTrack> playlist, {int startIndex = 0}) async {
    _playlist = playlist;
    _currentIndex = startIndex.clamp(0, playlist.length - 1);
    
    if (_isShuffled) {
      _generateShuffleIndices();
    }
    
    await _loadCurrentTrack();
  }

  Future<void> _loadCurrentTrack() async {
    if (_playlist.isEmpty) return;
    
    final track = _playlist[_getCurrentTrackIndex()];
    try {
      await _audioPlayer.setAudioSource(
        AudioSource.asset(track.audioPath),
      );
    } catch (e) {
      print('Error loading track: $e');
    }
  }

  int _getCurrentTrackIndex() {
    if (!_isShuffled || _shuffledIndices.isEmpty) return _currentIndex;
    return _shuffledIndices[_currentIndex];
  }

  void _generateShuffleIndices() {
    _shuffledIndices = List.generate(_playlist.length, (index) => index)
      ..shuffle();
  }

  Future<void> play() async {
    await _audioPlayer.play();
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
      // If repeating, play the same track again
      await _audioPlayer.seek(Duration.zero);
      await play();
    } else {
      // Move to next track
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
      // If we're more than 3 seconds into the track, restart it
      await seek(Duration.zero);
    } else {
      // Otherwise, go to previous track
      _currentIndex = (_currentIndex - 1 + _playlist.length) % _playlist.length;
      await _loadCurrentTrack();
      await play();
    }
  }

  Future<void> toggleShuffle() async {
    _isShuffled = !_isShuffled;
    if (_isShuffled) {
      _generateShuffleIndices();
    }
    // Reload current track with new shuffle state
    if (_playlist.isNotEmpty) {
      await _loadCurrentTrack();
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
    return _playlist[_getCurrentTrackIndex()];
  }

  bool get isPlaying => _audioPlayer.playing;
  bool get isShuffled => _isShuffled;
  bool get isRepeating => _isRepeating;
  double get volume => _volume;
  
  // Add method to get current state
  PlayerState get playerState => _audioPlayer.playerState;
}