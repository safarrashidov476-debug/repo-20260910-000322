import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/channel.dart';

class FavoritesService {
  static const String _key = 'favorite_channels';

  Future<List<String>> getFavoriteIds() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_key) ?? [];
  }

  Future<void> addFavorite(String channelId) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_key) ?? [];
    if (!list.contains(channelId)) {
      list.add(channelId);
      await prefs.setStringList(_key, list);
    }
  }

  Future<void> removeFavorite(String channelId) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_key) ?? [];
    list.remove(channelId);
    await prefs.setStringList(_key, list);
  }

  Future<bool> isFavorite(String channelId) async {
    final list = await getFavoriteIds();
    return list.contains(channelId);
  }

  Future<void> toggleFavorite(String channelId) async {
    if (await isFavorite(channelId)) {
      await removeFavorite(channelId);
    } else {
      await addFavorite(channelId);
    }
  }
}
