// lib/features/glossary/presentation/widgets/glossary_term_dialog.dart

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/mascot_audio_button.dart';
import '../../domain/entities/glossary_term.dart';
import 'glossary_mascots.dart';

class GlossaryTermDialog extends StatefulWidget {
  final GlossaryTerm term;

  const GlossaryTermDialog({super.key, required this.term});

  @override
  State<GlossaryTermDialog> createState() => _GlossaryTermDialogState();

  static void show(BuildContext context, GlossaryTerm term) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.7),
      builder: (context) => GlossaryTermDialog(term: term),
    );
  }
}

class _GlossaryTermDialogState extends State<GlossaryTermDialog> {
  // Track which mascots have been clicked (fallen)
  final Set<int> _fallenMascots = {};

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Mascots around the dialog
        ..._buildFloatingMascots(),

        // Main dialog
        Center(
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 400),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header with navy background
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      color: AppTheme.tertiaryDark,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                    ),
                    child: Row(
                      children: [
                        // Icon circle
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: AppTheme.accentGreen.withOpacity(0.3),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              widget.term.icon,
                              style: const TextStyle(fontSize: 28),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Term title
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.term.term,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Definición',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.7),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Mascot audio button for this term
                        MascotAudioButton(
                          audioFileName:
                              '${_sanitizeTermName(widget.term.term)}.mp3',
                          size: 40,
                        ),
                        const SizedBox(width: 8),
                        // Close button
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.white),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                  ),

                  // Content
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Green accent bar
                        Container(
                          width: 60,
                          height: 4,
                          decoration: BoxDecoration(
                            color: AppTheme.accentGreen,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Question section
                        if (widget.term.question.isNotEmpty) ...[
                          Text(
                            widget.term.question,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.primaryDark,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],

                        // Definition section
                        Text(
                          widget.term.definition,
                          style: TextStyle(
                            fontSize: 15,
                            color: AppTheme.primaryDark.withOpacity(0.8),
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ).animate().scale(duration: 300.ms, curve: Curves.easeOutBack),
        ),
      ],
    );
  }

  List<Widget> _buildFloatingMascots() {
    final mascots = GlossaryMascots.mascots;
    final screenSize = MediaQuery.of(context).size;

    // 5 mascots scattered at the top with varied heights and wide spacing
    final positions = [
      {'left': 30.0, 'top': 30.0},
      {'left': 80.0, 'top': 150.0},
      {'left': 230.0, 'top': 190.0},
      {'right': 180.0, 'top': 85.0},
      {'right': 60.0, 'top': 80.0},
    ];

    return List.generate(positions.length, (index) {
      final mascotIndex = index % mascots.length;
      final position = positions[index];
      final hasFallen = _fallenMascots.contains(index);

      return AnimatedPositioned(
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeIn,
        left: position['left'],
        right: position['right'],
        top: hasFallen ? screenSize.height + 100 : position['top'],
        bottom: position['bottom'],
        child: GestureDetector(
          onTap: () {
            setState(() {
              _fallenMascots.add(index);
            });
          },
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 800),
            opacity: hasFallen ? 0.0 : 1.0,
            child:
                AnimatedRotation(
                      duration: const Duration(milliseconds: 800),
                      turns: hasFallen ? 2.0 : 0.0, // 2 full rotations
                      curve: Curves.easeIn,
                      child: Image.asset(
                        mascots[mascotIndex],
                        width: 60,
                        height: 60,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return const SizedBox.shrink();
                        },
                      ),
                    )
                    .animate(
                      onPlay: (controller) => controller.repeat(reverse: true),
                    )
                    .moveY(
                      begin: -5,
                      end: 5,
                      duration: (1500 + (index * 200)).ms,
                    )
                    .then()
                    .rotate(
                      begin: -0.05,
                      end: 0.05,
                      duration: (1000 + (index * 150)).ms,
                    ),
          ),
        ),
      );
    });
  }

  /// Sanitize term name to match audio file naming
  /// Converts to lowercase and removes special characters
  static String _sanitizeTermName(String termName) {
    return termName
        .toLowerCase()
        .replaceAll(' ', '_')
        .replaceAll(RegExp(r'[^\w_]'), '');
  }

  static void show(BuildContext context, GlossaryTerm term) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.7),
      builder: (context) => GlossaryTermDialog(term: term),
    );
  }
}
