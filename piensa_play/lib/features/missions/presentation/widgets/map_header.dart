import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/mascot_audio_button.dart';

class MapHeader extends StatelessWidget {
  final String categoryTitle;
  final String? audioFileName; // Optional audio file for this map

  const MapHeader({super.key, required this.categoryTitle, this.audioFileName});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(color: AppTheme.tertiaryDark),
      padding: const EdgeInsets.only(top: 50, bottom: 20, left: 16, right: 16),
      child: Row(
        children: [
          // Botón de retroceso
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppTheme.secondaryDark,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Título
          Expanded(
            child: Text(
              categoryTitle,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // Mascot audio button (if audioFileName provided)
          if (audioFileName != null)
            MascotAudioButton(audioFileName: audioFileName!, size: 48),
        ],
      ),
    );
  }
}
