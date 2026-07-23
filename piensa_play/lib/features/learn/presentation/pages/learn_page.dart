// lib/features/learn/presentation/pages/learn_page.dart

import 'package:flutter/material.dart';
import 'package:piensa_play/core/services/logger_service.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_animations.dart';
import '../../../../core/widgets/mascot_audio_button.dart';
import '../../data/repositories/learn_repository.dart';
import '../../domain/entities/media_item.dart';
import '../widgets/media_item_card.dart';
import 'video_player_page.dart';

class LearnPage extends StatefulWidget {
  const LearnPage({super.key});

  @override
  State<LearnPage> createState() => _LearnPageState();
}

class _LearnPageState extends State<LearnPage> {
  final LearnRepository _repository = LearnRepository();
  final TextEditingController _searchController = TextEditingController();

  List<MediaItem> _allItems = [];
  List<MediaItem> _filteredItems = [];
  List<String> _categories = ['Todos'];
  String _selectedCategory = 'Todos';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final items = await _repository.getAllItems();
      final categories = _repository.getCategories();

      setState(() {
        _allItems = items;
        _filteredItems = items;
        _categories = categories;
        _isLoading = false;
      });
      AppLogger.log('LEARN PAGE: Loaded ${items.length} media items');
    } catch (e) {
      setState(() => _isLoading = false);
      AppLogger.error('LEARN PAGE: Error loading: $e');
    }
  }

  void _onSearchChanged() {
    _applyFilters();
  }

  void _onCategoryChanged(String category) {
    setState(() {
      _selectedCategory = category;
      _applyFilters();
    });
  }

  void _applyFilters() {
    setState(() {
      var filtered = _allItems;

      // Apply category filter
      filtered = _repository.filterByCategory(filtered, _selectedCategory);

      // Apply search filter
      filtered = _repository.search(filtered, _searchController.text);

      _filteredItems = filtered;
    });
  }

  void _openMediaItem(MediaItem item) {
    if (item.type == MediaType.video && item.youtubeId != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => VideoPlayerPage(item: item)),
      );
    } else if (item.type == MediaType.audio) {
      // TODO: Implement audio player
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _english
                ? 'Audio player coming soon'
                : 'Reproductor de audio próximamente',
          ),
        ),
      );
    }
  }

  bool get _english => Localizations.localeOf(context).languageCode == 'en';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppTheme.backgroundDark
          : AppTheme.backgroundLight,
      body: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(
              top: 50,
              bottom: 20,
              left: 20,
              right: 20,
            ),
            decoration: BoxDecoration(
              color: isDark ? AppTheme.surfaceDark : AppTheme.tertiaryDark,
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                Expanded(
                  child: Text(
                    _english ? 'Learn' : 'Aprende',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // Mascot audio button (optional)
                const MascotAudioButton(audioFileName: 'aprende.mp3', size: 48),
              ],
            ),
          ).slideFromTop(),

          // Search bar
          Padding(
            padding: const EdgeInsets.all(20),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: _english
                    ? 'Search content...'
                    : 'Buscar contenido...',
                hintStyle: TextStyle(
                  color: isDark
                      ? AppTheme.textSecondaryDark
                      : Colors.grey.shade600,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: isDark ? AppTheme.accentBlue : AppTheme.primaryDark,
                ),
                filled: true,
                fillColor: isDark ? AppTheme.cardDark : Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: AppTheme.accentBlue.withValues(alpha: 0.3),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: AppTheme.accentBlue.withValues(alpha: 0.3),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                    color: AppTheme.accentBlue,
                    width: 2,
                  ),
                ),
              ),
            ).fadeInSlide(delay: const Duration(milliseconds: 100)),
          ),

          // Category filters
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = category == _selectedCategory;

                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child:
                      FilterChip(
                        label: Text(category),
                        selected: isSelected,
                        onSelected: (_) => _onCategoryChanged(category),
                        backgroundColor: isDark
                            ? AppTheme.cardDark
                            : Colors.white,
                        selectedColor: isDark
                            ? AppTheme.accentBlue.withValues(alpha: 0.5)
                            : const Color(0xFF90CAF9),
                        labelStyle: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : (isDark
                                    ? AppTheme.textPrimaryDark
                                    : AppTheme.primaryDark),
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                        side: BorderSide(
                          color: isSelected
                              ? AppTheme.accentBlue
                              : (isDark
                                    ? Colors.grey.shade700
                                    : Colors.grey.shade300),
                          width: 2,
                        ),
                      ).staggeredEntry(
                        index: index,
                        staggerDelay: const Duration(milliseconds: 40),
                      ),
                );
              },
            ),
          ),

          const SizedBox(height: 16),

          // Media items grid
          Expanded(
            child: RefreshIndicator(
              onRefresh: _loadData,
              color: AppTheme.primaryDark,
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _filteredItems.isEmpty
                  ? ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.4,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.video_library_outlined,
                                  size: 64,
                                  color: Colors.grey.shade400,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No se encontró contenido',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  : GridView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 0.75,
                          ),
                      itemCount: _filteredItems.length,
                      itemBuilder: (context, index) {
                        final item = _filteredItems[index];

                        return MediaItemCard(
                          item: item,
                          index: index,
                          onTap: () => _openMediaItem(item),
                        ).staggeredEntry(
                          index: index,
                          staggerDelay: const Duration(milliseconds: 60),
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
