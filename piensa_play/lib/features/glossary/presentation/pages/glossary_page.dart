// lib/features/glossary/presentation/pages/glossary_page.dart

import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_animations.dart';
import '../../../../core/services/user_id_provider.dart';
import '../../../../core/widgets/mascot_audio_button.dart';
import '../../domain/entities/glossary_term.dart';
import '../../domain/usecases/get_glossary_terms.dart';
import '../widgets/glossary_term_card.dart';
import '../widgets/glossary_term_dialog.dart';
import '../../../home/presentation/widgets/custom_bottom_nav_bar.dart';

class GlossaryPage extends StatefulWidget {
  const GlossaryPage({super.key});

  @override
  State<GlossaryPage> createState() => _GlossaryPageState();
}

class _GlossaryPageState extends State<GlossaryPage> {
  final GetGlossaryTerms _getGlossaryTerms = GetGlossaryTerms();
  final TextEditingController _searchController = TextEditingController();

  // Use Firebase Anonymous Auth UID instead of hardcoded ID
  String get userId => UserIdProvider.currentUserId;

  List<GlossaryTerm> _allTerms = [];
  List<GlossaryTerm> _filteredTerms = [];
  List<String> _categories = ['Todos'];
  String _selectedCategory = 'Todos';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTerms();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadTerms() async {
    setState(() => _isLoading = true);

    try {
      print('🔵 GLOSSARY PAGE: Loading terms...');

      final terms = await _getGlossaryTerms.execute(userId);
      final categories = _getGlossaryTerms.getCategories(terms);

      setState(() {
        _allTerms = terms;
        _filteredTerms = terms;
        _categories = categories;
        _isLoading = false;
      });

      print('🟢 GLOSSARY PAGE: Loaded ${terms.length} terms');
    } catch (e) {
      setState(() => _isLoading = false);
      print('❌ GLOSSARY PAGE: Error loading terms: $e');
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
      var filtered = _allTerms;

      // Apply category filter
      filtered = _getGlossaryTerms.filterByCategory(
        filtered,
        _selectedCategory,
      );

      // Apply search filter
      filtered = _getGlossaryTerms.search(filtered, _searchController.text);

      _filteredTerms = filtered;
    });
  }

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
                const Expanded(
                  child: Text(
                    'Glosario',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // Mascot audio button
                const MascotAudioButton(
                  audioFileName: 'glosario.mp3',
                  size: 48,
                ),
              ],
            ),
          ).slideFromTop(),

          // Search bar
          Padding(
            padding: const EdgeInsets.all(20),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar término...',
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
                    color: AppTheme.accentBlue.withOpacity(0.3),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: AppTheme.accentBlue.withOpacity(0.3),
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
                            ? AppTheme.accentBlue.withOpacity(0.5)
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

          // Terms grid
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredTerms.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No se encontraron términos',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.85,
                        ),
                    itemCount: _filteredTerms.length,
                    itemBuilder: (context, index) {
                      final term = _filteredTerms[index];

                      return GlossaryTermCard(
                        term: term.term,
                        icon: term.icon,
                        index: index,
                        onTap: () => GlossaryTermDialog.show(context, term),
                      ).staggeredEntry(
                        index: index,
                        staggerDelay: const Duration(milliseconds: 60),
                      );
                    },
                  ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 1,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacementNamed(context, '/home');
          } else if (index == 2) {
            Navigator.pushReplacementNamed(context, '/settings');
          }
          // index == 1 is already on glossary
        },
      ),
    );
  }
}
