import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../domain/entities/unified_question.dart';

/// Widget para preguntas tipo "Conectar Parejas"
/// El usuario conecta elementos de la izquierda con la derecha
class MatchPairsWidget extends StatefulWidget {
  final UnifiedQuestion question;
  final bool isAnswered;
  final Map<String, String> userMatches; // left -> right
  final Function(String left, String right) onMatch;
  final VoidCallback onVerify;

  const MatchPairsWidget({
    super.key,
    required this.question,
    required this.isAnswered,
    required this.userMatches,
    required this.onMatch,
    required this.onVerify,
  });

  @override
  State<MatchPairsWidget> createState() => _MatchPairsWidgetState();
}

class _MatchPairsWidgetState extends State<MatchPairsWidget> {
  String? _selectedLeft;
  final Map<String, GlobalKey> _leftKeys = {};
  final Map<String, GlobalKey> _rightKeys = {};

  List<String> get leftItems {
    return widget.question.matchPairs?.map((p) => p.left).toList() ?? [];
  }

  List<String> get rightItems {
    final items =
        widget.question.matchPairs?.map((p) => p.right).toList() ?? [];
    // Mezclar para que no estén en orden
    items.shuffle();
    return items;
  }

  // Cache para evitar shuffle en cada rebuild
  late List<String> _shuffledRightItems;

  @override
  void initState() {
    super.initState();
    _shuffledRightItems = rightItems;
    // Inicializar keys
    for (final item in leftItems) {
      _leftKeys[item] = GlobalKey();
    }
    for (final item in _shuffledRightItems) {
      _rightKeys[item] = GlobalKey();
    }
  }

  bool get allPairsMatched {
    final pairCount = widget.question.matchPairs?.length ?? 0;
    return widget.userMatches.length == pairCount;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Ícono
                  Center(
                    child:
                        Icon(
                          Icons.link_rounded,
                          size: 48,
                          color: AppTheme.primaryDark,
                        ).animate().scale(
                          duration: 300.ms,
                          curve: Curves.elasticOut,
                        ),
                  ),
                  const SizedBox(height: 16),

                  // Título
                  Center(
                    child: Text(
                      widget.question.title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryDark,
                        height: 1.3,
                      ),
                    ),
                  ),

                  if (widget.question.subtitle != null) ...[
                    const SizedBox(height: 8),
                    Center(
                      child: Text(
                        widget.question.subtitle!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                  ],

                  const SizedBox(height: 32),

                  // Área de conexiones
                  _buildMatchingArea(),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),

          // Botón verificar
          if (!widget.isAnswered)
            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: allPairsMatched ? widget.onVerify : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.accentGreen,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.grey.shade300,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    allPairsMatched ? 'Verificar' : 'Conecta todas las parejas',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ).animate().fadeIn(delay: 200.ms),
            ),
        ],
      ),
    );
  }

  Widget _buildMatchingArea() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Columna izquierda
        Expanded(
          child: Column(
            children: leftItems.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              return _buildLeftItem(item, index);
            }).toList(),
          ),
        ),

        // Espacio para las líneas
        const SizedBox(width: 40),

        // Columna derecha
        Expanded(
          child: Column(
            children: _shuffledRightItems.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              return _buildRightItem(item, index);
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildLeftItem(String item, int index) {
    final isSelected = _selectedLeft == item;
    final isMatched = widget.userMatches.containsKey(item);
    final matchedRight = widget.userMatches[item];

    // Verificar si es correcto
    bool? isCorrect;
    if (widget.isAnswered && isMatched) {
      final correctPair = widget.question.matchPairs?.firstWhere(
        (p) => p.left == item,
        orElse: () => const MatchPair(id: '', left: '', right: ''),
      );
      isCorrect = correctPair?.right == matchedRight;
    }

    Color bgColor = Colors.white;
    Color borderColor = AppTheme.accentBlue;

    if (isSelected) {
      bgColor = AppTheme.accentBlue.withValues(alpha: 0.15);
      borderColor = AppTheme.accentBlue;
    } else if (isMatched) {
      bgColor = AppTheme.accentGreen.withValues(alpha: 0.1);
      borderColor = AppTheme.accentGreen;
    }

    if (widget.isAnswered && isCorrect != null) {
      if (isCorrect) {
        bgColor = Colors.green.shade50;
        borderColor = Colors.green;
      } else {
        bgColor = Colors.red.shade50;
        borderColor = Colors.red;
      }
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: widget.isAnswered
            ? null
            : () {
                setState(() {
                  if (isMatched) {
                    // Deshacer match
                    widget.onMatch(item, '');
                    _selectedLeft = null;
                  } else if (isSelected) {
                    _selectedLeft = null;
                  } else {
                    _selectedLeft = item;
                  }
                });
              },
        child: Container(
          key: _leftKeys[item],
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor, width: isSelected ? 2 : 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  item,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryDark,
                  ),
                ),
              ),
              if (isMatched) ...[
                const SizedBox(width: 8),
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: widget.isAnswered
                        ? (isCorrect == true ? Colors.green : Colors.red)
                        : AppTheme.accentGreen,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    widget.isAnswered
                        ? (isCorrect == true ? Icons.check : Icons.close)
                        : Icons.link,
                    size: 14,
                    color: Colors.white,
                  ),
                ),
              ] else if (isSelected) ...[
                const SizedBox(width: 8),
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: AppTheme.accentBlue,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_forward,
                    size: 14,
                    color: Colors.white,
                  ),
                ),
              ],
            ],
          ),
        ).animate().fadeIn(delay: (index * 80).ms).slideX(begin: -0.1),
      ),
    );
  }

  Widget _buildRightItem(String item, int index) {
    final matchedLeft = widget.userMatches.entries
        .where((e) => e.value == item)
        .map((e) => e.key)
        .firstOrNull;
    final isMatched = matchedLeft != null;
    final canSelect = _selectedLeft != null && !isMatched;

    // Verificar si es correcto
    bool? isCorrect;
    if (widget.isAnswered && isMatched) {
      final correctPair = widget.question.matchPairs?.firstWhere(
        (p) => p.right == item,
        orElse: () => const MatchPair(id: '', left: '', right: ''),
      );
      isCorrect = correctPair?.left == matchedLeft;
    }

    Color bgColor = Colors.white;
    Color borderColor = Colors.grey.shade400;

    if (isMatched) {
      bgColor = AppTheme.accentGreen.withValues(alpha: 0.1);
      borderColor = AppTheme.accentGreen;
    } else if (canSelect) {
      bgColor = AppTheme.accentBlue.withValues(alpha: 0.05);
      borderColor = AppTheme.accentBlue;
    }

    if (widget.isAnswered && isCorrect != null) {
      if (isCorrect) {
        bgColor = Colors.green.shade50;
        borderColor = Colors.green;
      } else {
        bgColor = Colors.red.shade50;
        borderColor = Colors.red;
      }
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: (widget.isAnswered || !canSelect)
            ? null
            : () {
                if (_selectedLeft != null) {
                  widget.onMatch(_selectedLeft!, item);
                  setState(() {
                    _selectedLeft = null;
                  });
                }
              },
        child: Container(
          key: _rightKeys[item],
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor, width: canSelect ? 2 : 1.5),
            boxShadow: canSelect
                ? [
                    BoxShadow(
                      color: AppTheme.accentBlue.withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
          ),
          child: Row(
            children: [
              if (isMatched) ...[
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: widget.isAnswered
                        ? (isCorrect == true ? Colors.green : Colors.red)
                        : AppTheme.accentGreen,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    widget.isAnswered
                        ? (isCorrect == true ? Icons.check : Icons.close)
                        : Icons.link,
                    size: 14,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 8),
              ],
              Expanded(
                child: Text(
                  item,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryDark,
                  ),
                ),
              ),
            ],
          ),
        ).animate().fadeIn(delay: (index * 80).ms).slideX(begin: 0.1),
      ),
    );
  }
}
