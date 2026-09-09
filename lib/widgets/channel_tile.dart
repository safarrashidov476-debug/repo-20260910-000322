import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/channel.dart';

class ChannelTile extends StatelessWidget {
  final Channel channel;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onFavoriteToggle;

  const ChannelTile({
    super.key,
    required this.channel,
    required this.isFavorite,
    required this.onTap,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: channel.logo != null && channel.logo!.isNotEmpty
              ? CachedNetworkImage(
                  imageUrl: channel.logo!,
                  width: 56,
                  height: 56,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    width: 56,
                    height: 56,
                    color: Colors.grey.shade800,
                    child: const Icon(Icons.tv, color: Colors.white54),
                  ),
                  errorWidget: (context, url, error) => Container(
                    width: 56,
                    height: 56,
                    color: Colors.grey.shade800,
                    child: const Icon(Icons.tv, color: Colors.white54),
                  ),
                )
              : Container(
                  width: 56,
                  height: 56,
                  color: Colors.grey.shade800,
                  child: const Icon(Icons.tv, color: Colors.white54),
                ),
        ),
        title: Text(
          channel.name,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          _categoryLabel(channel.category),
          style: TextStyle(
            color: _categoryColor(channel.category),
            fontSize: 13,
          ),
        ),
        trailing: IconButton(
          icon: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: isFavorite ? Colors.redAccent : Colors.grey,
          ),
          onPressed: onFavoriteToggle,
        ),
        onTap: onTap,
      ),
    );
  }

  String _categoryLabel(String cat) {
    switch (cat) {
      case 'davlat':
        return 'Davlat (MTRK)';
      case 'xususiy':
        return 'Xususiy';
      case 'hududiy':
        return 'Hududiy';
      default:
        return 'Boshqa';
    }
  }

  Color _categoryColor(String cat) {
    switch (cat) {
      case 'davlat':
        return Colors.blueAccent;
      case 'xususiy':
        return Colors.greenAccent.shade400;
      case 'hududiy':
        return Colors.orangeAccent;
      default:
        return Colors.grey;
    }
  }
}
