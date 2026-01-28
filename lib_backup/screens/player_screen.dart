import 'package:flutter/material.dart';
import '../models/music_track.dart';
import '../widgets/player_controls.dart';
import '../widgets/seek_bar.dart';

class PlayerScreen extends StatefulWidget {
  final MusicTrack track;
  final Duration currentPosition;
  final Duration duration;
  final bool isPlaying;
  final bool isShuffled;
  final bool isRepeating;
  final double volume;
  final VoidCallback onPlayPause;
  final VoidCallback onNext;
  final VoidCallback onPrevious;
  final VoidCallback onShuffle;
  final VoidCallback onRepeat;
  final ValueChanged<Duration> onSeek;
  final ValueChanged<double> onVolumeChanged;

  const PlayerScreen({
    Key? key,
    required this.track,
    required this.currentPosition,
    required this.duration,
    required this.isPlaying,
    required this.isShuffled,
    required this.isRepeating,
    required this.volume,
    required this.onPlayPause,
    required this.onNext,
    required this.onPrevious,
    required this.onShuffle,
    required this.onRepeat,
    required this.onSeek,
    required this.onVolumeChanged,
  }) : super(key: key);

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              _showTrackOptions(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Album Art
              Container(
                width: 280,
                height: 280,
                margin: const EdgeInsets.only(bottom: 32),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                  image: widget.track.coverImage != null
                      ? DecorationImage(
                          image: AssetImage(widget.track.coverImage!),
                          fit: BoxFit.cover,
                        )
                      : null,
                  color: widget.track.coverImage == null
                      ? theme.colorScheme.primaryContainer
                      : null,
                ),
                child: widget.track.coverImage == null
                    ? Center(
                        child: Icon(
                          Icons.music_note,
                          size: 64,
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                      )
                    : null,
              ),
              
              // Track Info
              Text(
                widget.track.title,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Text(
                widget.track.artist,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                widget.track.album,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.outline,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 32),
              
              // Seek Bar
              SeekBar(
                currentPosition: widget.currentPosition,
                duration: widget.duration,
                onSeek: widget.onSeek,
              ),
              
              const SizedBox(height: 32),
              
              // Player Controls
              PlayerControls(
                isPlaying: widget.isPlaying,
                isShuffled: widget.isShuffled,
                isRepeating: widget.isRepeating,
                onPlayPause: widget.onPlayPause,
                onNext: widget.onNext,
                onPrevious: widget.onPrevious,
                onShuffle: widget.onShuffle,
                onRepeat: widget.onRepeat,
                volume: widget.volume,
                onVolumeChanged: widget.onVolumeChanged,
              ),
              
              const SizedBox(height: 24),
              
              // Additional Info
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildInfoItem(
                    context,
                    icon: Icons.favorite,
                    value: widget.track.isFavorite ? 'Liked' : 'Like',
                  ),
                  _buildInfoItem(
                    context,
                    icon: Icons.play_circle_filled,
                    value: '${widget.track.playCount} plays',
                  ),
                  _buildInfoItem(
                    context,
                    icon: Icons.calendar_today,
                    value: _formatDate(widget.track.dateAdded),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem(BuildContext context, {required IconData icon, required String value}) {
    return Column(
      children: [
        Icon(
          icon,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          size: 24,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.outline,
              ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  void _showTrackOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.info),
                title: const Text('Track Details'),
                onTap: () {
                  Navigator.pop(context);
                  _showTrackDetails(context);
                },
              ),
              ListTile(
                leading: Icon(
                  widget.track.isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: widget.track.isFavorite
                      ? Theme.of(context).colorScheme.error
                      : null,
                ),
                title: Text(widget.track.isFavorite ? 'Remove from Favorites' : 'Add to Favorites'),
                onTap: () {
                  Navigator.pop(context);
                  // Handle favorite toggle
                },
              ),
              ListTile(
                leading: const Icon(Icons.playlist_add),
                title: const Text('Add to Playlist'),
                onTap: () {
                  Navigator.pop(context);
                  // Handle add to playlist
                },
              ),
              ListTile(
                leading: const Icon(Icons.share),
                title: const Text('Share'),
                onTap: () {
                  Navigator.pop(context);
                  // Handle share
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showTrackDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Track Details'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDetailRow('Title', widget.track.title),
                _buildDetailRow('Artist', widget.track.artist),
                _buildDetailRow('Album', widget.track.album),
                _buildDetailRow('Duration', _formatDuration(Duration(seconds: widget.track.duration))),
                _buildDetailRow('Date Added', _formatDate(widget.track.dateAdded)),
                _buildDetailRow('Play Count', widget.track.playCount.toString()),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds.remainder(60);
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }
}