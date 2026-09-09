import 'package:flutter/material.dart';
import '../models/channel.dart';
import '../services/playlist_service.dart';
import '../services/favorites_service.dart';
import '../widgets/channel_tile.dart';
import 'player_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final PlaylistService _playlistService = PlaylistService();
  final FavoritesService _favoritesService = FavoritesService();

  List<Channel> _allChannels = [];
  List<Channel> _filteredChannels = [];
  Set<String> _favoriteIds = {};
  bool _isLoading = true;
  String? _error;
  String _selectedCategory = 'barcha';
  String _searchQuery = '';
  late TabController _tabController;

  final List<Map<String, String>> _categories = [
    {'key': 'barcha', 'label': 'Barcha'},
    {'key': 'davlat', 'label': 'Davlat (MTRK)'},
    {'key': 'xususiy', 'label': 'Xususiy'},
    {'key': 'hududiy', 'label': 'Hududiy'},
    {'key': 'favorites', 'label': 'Sevimlilar'},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);
    _tabController.addListener(_onTabChanged);
    _loadData();
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging) return;
    setState(() {
      _selectedCategory = _categories[_tabController.index]['key']!;
      _applyFilters();
    });
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final channels = await _playlistService.fetchChannels();
      final favIds = await _favoritesService.getFavoriteIds();

      if (mounted) {
        setState(() {
          _allChannels = channels;
          _favoriteIds = favIds.toSet();
          _isLoading = false;
          _applyFilters();
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _error = e.toString();
        });
      }
    }
  }

  void _applyFilters() {
    List<Channel> result;

    if (_selectedCategory == 'favorites') {
      result = _allChannels
          .where((c) => _favoriteIds.contains(c.id))
          .toList();
    } else {
      result = _playlistService.filterByCategory(_allChannels, _selectedCategory);
    }

    if (_searchQuery.isNotEmpty) {
      result = _playlistService.search(result, _searchQuery);
    }

    setState(() {
      _filteredChannels = result;
    });
  }

  Future<void> _toggleFavorite(Channel channel) async {
    await _favoritesService.toggleFavorite(channel.id);
    final favIds = await _favoritesService.getFavoriteIds();
    setState(() {
      _favoriteIds = favIds.toSet();
      if (_selectedCategory == 'favorites') {
        _applyFilters();
      }
    });
  }

  void _openPlayer(Channel channel) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PlayerScreen(channel: channel),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "O'zbek TV",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: Colors.blueAccent,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          tabs: _categories
              .map((c) => Tab(text: c['label']))
              .toList(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
            tooltip: 'Yangilash',
          ),
        ],
      ),
      body: Column(
        children: [
          // Qidiruv maydoni
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Kanal qidirish...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey.shade900,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
              onChanged: (value) {
                _searchQuery = value;
                _applyFilters();
              },
            ),
          ),
          // Kontent
          Expanded(
            child: _isLoading
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(color: Colors.blueAccent),
                        SizedBox(height: 16),
                        Text('Kanallar yuklanmoqda...'),
                      ],
                    ),
                  )
                : _error != null
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.cloud_off,
                                  size: 64, color: Colors.grey),
                              const SizedBox(height: 16),
                              const Text(
                                'Internetga ulanishda muammo',
                                style: TextStyle(fontSize: 18),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _error!,
                                style: const TextStyle(
                                    color: Colors.grey, fontSize: 12),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 24),
                              ElevatedButton.icon(
                                onPressed: _loadData,
                                icon: const Icon(Icons.refresh),
                                label: const Text('Qayta yuklash'),
                              ),
                            ],
                          ),
                        ),
                      )
                    : _filteredChannels.isEmpty
                        ? Center(
                            child: Text(
                              _selectedCategory == 'favorites'
                                  ? 'Sevimli kanallar yo\'q'
                                  : 'Kanallar topilmadi',
                              style: const TextStyle(color: Colors.grey),
                            ),
                          )
                        : RefreshIndicator(
                            onRefresh: _loadData,
                            child: ListView.builder(
                              padding: const EdgeInsets.only(bottom: 16),
                              itemCount: _filteredChannels.length,
                              itemBuilder: (context, index) {
                                final channel = _filteredChannels[index];
                                return ChannelTile(
                                  channel: channel,
                                  isFavorite:
                                      _favoriteIds.contains(channel.id),
                                  onTap: () => _openPlayer(channel),
                                  onFavoriteToggle: () =>
                                      _toggleFavorite(channel),
                                );
                              },
                            ),
                          ),
          ),
        ],
      ),
    );
  }
}
