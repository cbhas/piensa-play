// lib/features/onboarding/presentation/widgets/avatar_selector.dart

import 'package:flutter/material.dart';
import '../../../../core/theme/app_animations.dart';
import '../../domain/entities/avatar.dart';

class AvatarSelector extends StatelessWidget {
  final List<Avatar> avatars;
  final String? selectedAvatarId;
  final Function(String) onAvatarSelected;

  const AvatarSelector({
    super.key,
    required this.avatars,
    required this.selectedAvatarId,
    required this.onAvatarSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.1,
      ),
      itemCount: avatars.length,
      itemBuilder: (context, index) {
        final avatar = avatars[index];
        final isSelected = selectedAvatarId == avatar.id;

        return GestureDetector(
          onTap: () => onAvatarSelected(avatar.id),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected
                    ? const Color(0xFFE91E63)
                    : Colors.transparent,
                width: 4,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Círculo con la imagen del avatar
                Container(
                  width: 90,
                  height: 90,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      avatar.assetPath,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.pets,
                          size: 50,
                          color: Colors.grey.shade400,
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 4),
              ],
            ),
          ),
        ).staggeredEntry(
          index: index,
          staggerDelay: const Duration(milliseconds: 80),
        );
      },
    );
  }
}
