import 'package:flutter/material.dart';
import '../models/music_track.dart';

class MusicCard extends StatelessWidget {
  final MusicTrack track;
  final bool isPlaying;
  final VoidCallback onTap;
  final VoidCallback onFavoriteToggle;
  final VoidCallback? onDelete;

  const MusicCard({
    Key? key,
    required this.track,
    required this.isPlaying,
    required this.onTap,
    required this.onFavoriteToggle,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(track.id),
      direction: onDelete != null
          ? DismissDirection.endToStart
          : DismissDirection.none,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      onDismissed: (_) => onDelete?.call(),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          leading: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: track.coverImage != null
                  ? null
                  : Theme.of(context).colorScheme.primaryContainer,
              image: track.coverImage != null
                  ? DecorationImage(
                      image: AssetImage(track.coverImage!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: track.coverImage == null
                ? Icon(
                    Icons.music_note,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  )
                : null,
          ),
          title: Text(
            track.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: isPlaying ? FontWeight.bold : FontWeight.normal,
                ),
          ),
          subtitle: Text(
            '${track.artist} • ${track.album}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: IconButton(
            icon: Icon(
              track.isFavorite ? Icons.favorite : Icons.favorite_border,
              color: track.isFavorite
                  ? Theme.of(context).colorScheme.error
                  : null,
            ),
            onPressed: onFavoriteToggle,
          ),
          onTap: onTap,
          tileColor: isPlaying
              ? Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.3)
              : null,
        ),
      ),
    );
  }
}