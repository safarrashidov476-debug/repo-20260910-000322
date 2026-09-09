import 'package:http/http.dart' as http;
import '../models/channel.dart';

class PlaylistService {
  // iptv-org ochiq manbali O'zbekiston playlisti
  static const String defaultPlaylistUrl =
      'https://raw.githubusercontent.com/iptv-org/iptv/master/streams/uz.m3u';

  /// M3U playlistni yuklab, Channel ro'yxatiga aylantiradi
  Future<List<Channel>> fetchChannels({String? customUrl}) async {
    final url = customUrl ?? defaultPlaylistUrl;
    try {
      final response = await http.get(Uri.parse(url)).timeout(
        const Duration(seconds: 20),
      );

      if (response.statusCode != 200) {
        throw Exception('Playlist yuklanmadi: ${response.statusCode}');
      }

      return parseM3U(response.body);
    } catch (e) {
      throw Exception('Xatolik: $e');
    }
  }

  /// Oddiy M3U parser (EXTINF + URL juftligi)
  List<Channel> parseM3U(String content) {
    final lines = content.split('\n');
    final channels = <Channel>[];
    String? currentName;
    String? currentLogo;
    String? currentGroup;
    int index = 0;

    for (var i = 0; i < lines.length; i++) {
      final line = lines[i].trim();

      if (line.startsWith('#EXTINF:')) {
        // #EXTINF:-1 tvg-id="..." tvg-logo="..." group-title="...",Name
        currentName = null;
        currentLogo = null;
        currentGroup = null;

        // Logo
        final logoMatch = RegExp(r'tvg-logo="([^"]*)"').firstMatch(line);
        if (logoMatch != null) {
          currentLogo = logoMatch.group(1);
        }

        // Group
        final groupMatch = RegExp(r'group-title="([^"]*)"').firstMatch(line);
        if (groupMatch != null) {
          currentGroup = groupMatch.group(1);
        }

        // Name (verguldan keyin)
        final commaIndex = line.lastIndexOf(',');
        if (commaIndex != -1 && commaIndex < line.length - 1) {
          currentName = line.substring(commaIndex + 1).trim();
        }
      } else if (line.isNotEmpty &&
          !line.startsWith('#') &&
          currentName != null &&
          currentName.isNotEmpty) {
        // Stream URL
        final url = line;
        if (url.startsWith('http')) {
          index++;
          channels.add(Channel.fromM3U(
            id: 'ch_$index',
            name: currentName,
            url: url,
            logo: currentLogo,
            groupTitle: currentGroup,
          ));
        }
        currentName = null;
        currentLogo = null;
        currentGroup = null;
      }
    }

    // Bir xil nomli kanallarni birlashtirish (birinchi kelganini saqlash)
    final unique = <String, Channel>{};
    for (final ch in channels) {
      final key = ch.name.toLowerCase();
      if (!unique.containsKey(key)) {
        unique[key] = ch;
      }
    }

    return unique.values.toList()
      ..sort((a, b) => a.name.compareTo(b.name));
  }

  /// Kategoriyaga qarab filtr
  List<Channel> filterByCategory(List<Channel> channels, String category) {
    if (category == 'barcha') return channels;
    return channels.where((c) => c.category == category).toList();
  }

  /// Qidiruv
  List<Channel> search(List<Channel> channels, String query) {
    if (query.trim().isEmpty) return channels;
    final q = query.toLowerCase();
    return channels
        .where((c) =>
            c.name.toLowerCase().contains(q) ||
            c.group.toLowerCase().contains(q))
        .toList();
  }
}
