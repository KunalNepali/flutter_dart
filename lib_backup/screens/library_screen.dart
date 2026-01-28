import 'package:flutter/material.dart';
import '../models/music_track.dart';
import '../services/storage_service.dart';
import '../widgets/music_card.dart';

class LibraryScreen extends StatefulWidget {
  final List<MusicTrack> tracks;
  final MusicTrack? currentlyPlaying;
  final Function(MusicTrack) onTrackSelected;
  final Function(MusicTrack) onTrackUpdated;
  final Function(String) onTrackDeleted;

  const LibraryScreen({
    Key? key,
    required this.tracks,
    required this.currentlyPlaying,
    required this.onTrackSelected,
    required this.onTrackUpdated,
    required this.onTrackDeleted,
  }) : super(key: key);

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  late List<MusicTrack> _filteredTracks;
  String _searchQuery = '';
  SortBy _sortBy = SortBy.dateAdded;

  @override
  void initState() {
    super.initState();
    _filteredTracks = widget.tracks;
    _sortTracks();
  }

  @override
  void didUpdateWidget(covariant LibraryScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.tracks != widget.tracks) {
      _filterAndSortTracks();
    }
  }

  void _filterAndSortTracks() {
    _filteredTracks = widget.tracks.where((track) {
      final query = _searchQuery.toLowerCase();
      return track.title.toLowerCase().contains(query) ||
          track.artist.toLowerCase().contains(query) ||
          track.album.toLowerCase().contains(query);
    }).toList();
    _sortTracks();
  }

  void _sortTracks() {
    switch (_sortBy) {
      case SortBy.title:
        _filteredTracks.sort((a, b) => a.title.compareTo(b.title));
        break;
      case SortBy.artist:
        _filteredTracks.sort((a, b) => a.artist.compareTo(b.artist));
        break;
      case SortBy.dateAdded:
        _filteredTracks.sort((a, b) => b.dateAdded.compareTo(a.dateAdded));
        break;
      case SortBy.playCount:
        _filteredTracks.sort((a, b) => b.playCount.compareTo(a.playCount));
        break;
    }
  }

  Future<void> _toggleFavorite(MusicTrack track) async {
    final updatedTrack = track.copyWith(isFavorite: !track.isFavorite);
    widget.onTrackUpdated(updatedTrack);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Music Library'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: MusicSearchDelegate(
                  tracks: widget.tracks,
                  onTrackSelected: widget.onTrackSelected,
                ),
              );
            },
          ),
          PopupMenuButton<SortBy>(
            onSelected: (value) {
              setState(() {
                _sortBy = value;
                _sortTracks();
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: SortBy.title,
                child: Text('Sort by Title'),
              ),
              const PopupMenuItem(
                value: SortBy.artist,
                child: Text('Sort by Artist'),
              ),
              const PopupMenuItem(
                value: SortBy.dateAdded,
                child: Text('Sort by Date Added'),
              ),
              const PopupMenuItem(
                value: SortBy.playCount,
                child: Text('Sort by Play Count'),
              ),
            ],
          ),
        ],
      ),
      body: _filteredTracks.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.music_off,
                    size: 64,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No music found',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Add some music files to the audio folder',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _filteredTracks.length,
              itemBuilder: (context, index) {
                final track = _filteredTracks[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: MusicCard(
                    track: track,
                    isPlaying: widget.currentlyPlaying?.id == track.id,
                    onTap: () => widget.onTrackSelected(track),
                    onFavoriteToggle: () => _toggleFavorite(track),
                    onDelete: () => widget.onTrackDeleted(track.id),
                  ),
                );
              },
            ),
    );
  }
}

enum SortBy { title, artist, dateAdded, playCount }

class MusicSearchDelegate extends SearchDelegate {
  final List<MusicTrack> tracks;
  final Function(MusicTrack) onTrackSelected;

  MusicSearchDelegate({
    required this.tracks,
    required this.onTrackSelected,
  });

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults();
  }

  Widget _buildSearchResults() {
    final results = tracks.where((track) {
      final queryLower = query.toLowerCase();
      return track.title.toLowerCase().contains(queryLower) ||
          track.artist.toLowerCase().contains(queryLower) ||
          track.album.toLowerCase().contains(queryLower);
    }).toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final track = results[index];
        return ListTile(
          leading: const Icon(Icons.music_note),
          title: Text(track.title),
          subtitle: Text('${track.artist} • ${track.album}'),
          onTap: () {
            onTrackSelected(track);
            close(context, null);
          },
        );
      },
    );
  }
}