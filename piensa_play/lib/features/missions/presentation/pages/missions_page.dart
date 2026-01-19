import 'package:flutter/material.dart';
import 'package:piensa_play/core/services/logger_service.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/services/app_data_service.dart';
import '../../domain/entities/mission_category.dart';
import '../widgets/missions_header.dart';
import '../widgets/mission_category_card.dart';

/// RouteObserver global para detectar navegación
final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();

class MissionsPage extends StatefulWidget {
  const MissionsPage({super.key});

  @override
  State<MissionsPage> createState() => _MissionsPageState();
}

class _MissionsPageState extends State<MissionsPage> with RouteAware {
  bool _isLoading = false;

  // Leer directamente del caché para reflejar cambios inmediatamente
  List<MissionCategory> get _categories =>
      AppDataService.instance.missionCategories;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Suscribirse al RouteObserver
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    // Llamado cuando se vuelve a esta página desde otra
    // Forzar rebuild para leer el caché actualizado
    AppLogger.log('MISSIONS: Returned to page, refreshing from cache');
    setState(() {});
  }

  Future<void> _refreshData() async {
    setState(() => _isLoading = true);
    try {
      AppLogger.refresh('MISSIONS: Refreshing data...');
      await AppDataService.instance.refreshMissions();
      setState(() => _isLoading = false);
      AppLogger.success('MISSIONS: Data refreshed');
    } catch (e) {
      setState(() => _isLoading = false);
      AppLogger.error('MISSIONS: Error refreshing: $e');
    }
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
          const MissionsHeader(),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshData,
              color: AppTheme.primaryDark,
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            for (final category in _categories)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: MissionCategoryCard(category: category),
                              ),
                          ],
                        ),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
