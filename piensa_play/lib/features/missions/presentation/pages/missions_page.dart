import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/services/user_id_provider.dart';
import '../../domain/entities/mission_category.dart';
import '../../domain/usecases/get_mission_categories.dart';
import '../widgets/missions_header.dart';
import '../widgets/mission_category_card.dart';

class MissionsPage extends StatefulWidget {
  const MissionsPage({super.key});

  @override
  State<MissionsPage> createState() => _MissionsPageState();
}

class _MissionsPageState extends State<MissionsPage> {
  final GetMissionCategories _getMissionCategories = GetMissionCategories();
  // Use Firebase Anonymous Auth UID instead of hardcoded ID
  String get userId => UserIdProvider.currentUserId;

  List<MissionCategory> _categories = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      print('🔵 MISSIONS: Iniciando carga de datos...');

      final categories = await _getMissionCategories.execute(userId);

      setState(() {
        _categories = categories;
        _isLoading = false;
      });

      // Guarda en Firestore después de renderizar
      await _getMissionCategories.save(userId, categories);

      print('🟢 MISSIONS: Datos cargados y guardados');
    } catch (e) {
      setState(() => _isLoading = false);
      print('❌ MISSIONS: Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppTheme.backgroundDark
          : AppTheme.backgroundLight,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                const MissionsHeader(),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        ..._categories.map((category) {
                          return MissionCategoryCard(category: category);
                        }),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
