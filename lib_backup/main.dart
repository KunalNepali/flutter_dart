import 'package:flutter/material.dart';
import 'screens/library_screen.dart';
import 'screens/player_screen.dart';
import 'models/music_track.dart';
import 'services/storage_service.dart';
import 'services/audio_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MusicPlayerApp());
}

class MusicPlayerApp extends StatelessWidget {
  const MusicPlayerApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Music Player',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
      ),
      home: const MainApp(),
    );
  }
}

class MainApp extends StatefulWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final StorageService _storageService = StorageService();
  final AudioService _audioService = AudioService();
  
  List<MusicTrack> _tracks = [];
  MusicTrack? _currentTrack;
  Duration _currentPosition = Duration.zero;
  Duration _duration = Duration.zero;
  bool _isPlaying = false;
  bool _isShuffled = false;
  bool _isRepeating = false;
  double _volume = 0.5;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await _loadTracks();
    await _loadSettings();
    _setupAudioListeners();
    _loadAudioFilesFromAssets();
  }

  Future<void> _loadTracks() async {
    final tracks = await _storageService.loadTracks();
    setState(() {
      _tracks = tracks;
    });
  }

  Future<void> _loadSettings() async {
    final settings = await _storageService.loadSettings();
    setState(() {
      _isShuffled = settings['shuffle'] ?? false;
      _isRepeating = settings['repeat'] ?? false;
      _volume = settings['volume'] ?? 0.5;
    });
  }

void _setupAudioListeners() {
  _audioService.playerStateStream.listen((PlayerState state) {
    if (mounted) {
      setState(() {
        _isPlaying = state.playing;
      });
    }
  });

  _audioService.positionStream.listen((Duration position) {
    if (mounted) {
      setState(() {
        _currentPosition = position;
      });
    }
  });

  _audioService.durationStream.listen((Duration? duration) {
    if (mounted && duration != null) {
      setState(() {
        _duration = duration;
      });
    }
  });
}

void _loadAudioFilesFromAssets() async {
  // Scan the assets/audio/file folder
  final audioFiles = [
    'assets/audio/file/song1.mp3',
    'assets/audio/file/song2.mp3',
    'assets/audio/file/song3.mp3',
    // Add all your actual file names here
  ];
  
  if (_tracks.isEmpty && audioFiles.isNotEmpty) {
    final sampleTracks = audioFiles.asMap().entries.map((entry) {
      final index = entry.key;
      final path = entry.value;
      final fileName = path.split('/').last.replaceAll('.mp3', '');
      
      return MusicTrack(
        id: '${index + 1}',
        title: fileName,
        artist: 'Unknown Artist',
        album: 'My Music Collection',
        audioPath: path,
        duration: 180, // You'll need to get actual duration
        dateAdded: DateTime.now(),
      );
    }).toList();
    
    setState(() {
      _tracks = sampleTracks;
    });
    await _storageService.saveTracks(sampleTracks);
  }
}

  Future<void> _playTrack(MusicTrack track) async {
    setState(() {
      _currentTrack = track;
    });
    
    await _audioService.loadPlaylist(_tracks, startIndex: _tracks.indexOf(track));
    await _audioService.play();
    
    // Update play count
    final updatedTrack = track.copyWith(playCount: track.playCount + 1);
    await _updateTrack(updatedTrack);
  }

  Future<void> _updateTrack(MusicTrack track) async {
    await _storageService.updateTrack(track);
    setState(() {
      final index = _tracks.indexWhere((t) => t.id == track.id);
      if (index != -1) {
        _tracks[index] = track;
      }
      if (_currentTrack?.id == track.id) {
        _currentTrack = track;
      }
    });
  }

  Future<void> _deleteTrack(String trackId) async {
    await _storageService.deleteTrack(trackId);
    setState(() {
      _tracks.removeWhere((track) => track.id == trackId);
      if (_currentTrack?.id == trackId) {
        _currentTrack = null;
        _audioService.stop();
      }
    });
  }

  Future<void> _saveSettings() async {
    await _storageService.saveSettings(
      shuffle: _isShuffled,
      repeat: _isRepeating,
      volume: _volume,
    );
  }

  @override
  void dispose() {
    _audioService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentTrack != null && _isPlaying
          ? PlayerScreen(
              track: _currentTrack!,
              currentPosition: _currentPosition,
              duration: _duration,
              isPlaying: _isPlaying,
              isShuffled: _isShuffled,
              isRepeating: _isRepeating,
              volume: _volume,
              onPlayPause: () async {
                if (_isPlaying) {
                  await _audioService.pause();
                } else {
                  await _audioService.play();
                }
              },
              onNext: () async {
                await _audioService.playNext();
                setState(() {
                  _currentTrack = _audioService.currentTrack;
                });
              },
              onPrevious: () async {
                await _audioService.playPrevious();
                setState(() {
                  _currentTrack = _audioService.currentTrack;
                });
              },
              onShuffle: () async {
                await _audioService.toggleShuffle();
                setState(() {
                  _isShuffled = _audioService.isShuffled;
                });
                await _saveSettings();
              },
              onRepeat: () async {
                setState(() {
                  _isRepeating = !_isRepeating;
                });
                await _saveSettings();
              },
              onSeek: (position) async {
                await _audioService.seek(position);
              },
              onVolumeChanged: (volume) async {
                setState(() {
                  _volume = volume;
                });
                await _audioService.setVolume(volume);
                await _saveSettings();
              },
            )
          : LibraryScreen(
              tracks: _tracks,
              currentlyPlaying: _currentTrack,
              onTrackSelected: _playTrack,
              onTrackUpdated: _updateTrack,
              onTrackDeleted: _deleteTrack,
            ),
      floatingActionButton: _currentTrack != null
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PlayerScreen(
                      track: _currentTrack!,
                      currentPosition: _currentPosition,
                      duration: _duration,
                      isPlaying: _isPlaying,
                      isShuffled: _isShuffled,
                      isRepeating: _isRepeating,
                      volume: _volume,
                      onPlayPause: () async {
                        if (_isPlaying) {
                          await _audioService.pause();
                        } else {
                          await _audioService.play();
                        }
                      },
                      onNext: () async {
                        await _audioService.playNext();
                        setState(() {
                          _currentTrack = _audioService.currentTrack;
                        });
                      },
                      onPrevious: () async {
                        await _audioService.playPrevious();
                        setState(() {
                          _currentTrack = _audioService.currentTrack;
                        });
                      },
                      onShuffle: () async {
                        await _audioService.toggleShuffle();
                        setState(() {
                          _isShuffled = _audioService.isShuffled;
                        });
                        await _saveSettings();
                      },
                      onRepeat: () async {
                        setState(() {
                          _isRepeating = !_isRepeating;
                        });
                        await _saveSettings();
                      },
                      onSeek: (position) async {
                        await _audioService.seek(position);
                      },
                      onVolumeChanged: (volume) async {
                        setState(() {
                          _volume = volume;
                        });
                        await _audioService.setVolume(volume);
                        await _saveSettings();
                      },
                    ),
                  ),
                );
              },
              child: Icon(
                _isPlaying ? Icons.pause : Icons.play_arrow,
              ),
            )
          : null,
    );
  }
}