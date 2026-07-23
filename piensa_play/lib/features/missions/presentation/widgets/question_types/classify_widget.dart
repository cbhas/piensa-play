import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../domain/entities/unified_question.dart';

/// Widget para preguntas tipo "Clasificar"
/// El usuario arrastra items a las categorías correctas
class ClassifyWidget extends StatefulWidget {
  final UnifiedQuestion question;
  final bool isAnswered;
  final Map<String, String> userClassification;
  final Function(String itemId, String category) onItemClassified;
  final VoidCallback onVerify;

  const ClassifyWidget({
    super.key,
    required this.question,
    required this.isAnswered,
    required this.userClassification,
    required this.onItemClassified,
    required this.onVerify,
  });

  @override
  State<ClassifyWidget> createState() => _ClassifyWidgetState();
}

class _ClassifyWidgetState extends State<ClassifyWidget> {
  // Items que aún no han sido clasificados
  List<ClassifyItem> get unclassifiedItems {
    if (widget.question.classifyItems == null) return [];
    return widget.question.classifyItems!
        .where((item) => !widget.userClassification.containsKey(item.id))
        .toList();
  }

  // Items en una categoría específica
  List<ClassifyItem> itemsInCategory(String category) {
    if (widget.question.classifyItems == null) return [];
    return widget.question.classifyItems!
        .where((item) => widget.userClassification[item.id] == category)
        .toList();
  }

  // Verificar si todos los items han sido clasificados
  bool get allItemsClassified {
    if (widget.question.classifyItems == null) return false;
    return widget.question.classifyItems!.length ==
        widget.userClassification.length;
  }

  @override
  Widget build(BuildContext context) {
    final categories = widget.question.categories ?? [];

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
                    child: Icon(
                      Icons.shuffle_rounded,
                      size: 48,
                      color: AppTheme.primaryDark,
                    ).animate().scale(duration: 300.ms, curve: Curves.elasticOut),
                  ),
                  const SizedBox(height: 16),

                  // Título de la pregunta
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
                  const SizedBox(height: 24),

                  // Zonas de categorías (destino del drag)
                  Row(
                    children: categories.asMap().entries.map((entry) {
                      final index = entry.key;
                      final category = entry.value;
                      return Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: index == 0 ? 0 : 6,
                            right: index == categories.length - 1 ? 0 : 6,
                          ),
                          child: _buildCategoryZone(category),
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 24),

                  // Items sin clasificar (origen del drag)
                  if (unclassifiedItems.isNotEmpty) ...[
                    Text(
                      'Arrastra cada item a su categoría:',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: unclassifiedItems.asMap().entries.map((entry) {
                        final index = entry.key;
                        final item = entry.value;
                        return _buildDraggableItem(item, index);
                      }).toList(),
                    ),
                  ],

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),

          // Botón verificar (fuera del scroll, fijo abajo)
          if (!widget.isAnswered)
            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: allItemsClassified ? widget.onVerify : null,
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
                    allItemsClassified
                        ? 'Verificar'
                        : 'Clasifica todos los items',
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

  Widget _buildCategoryZone(String category) {
    final items = itemsInCategory(category);
    final isCorrectCategory = widget.isAnswered;

    return DragTarget<ClassifyItem>(
      onAcceptWithDetails: (details) {
        widget.onItemClassified(details.data.id, category);
      },
      builder: (context, candidateData, rejectedData) {
        final isHovering = candidateData.isNotEmpty;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isHovering
                ? AppTheme.accentBlue.withValues(alpha: 0.1)
                : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isHovering ? AppTheme.accentBlue : Colors.grey.shade300,
              width: isHovering ? 2 : 1,
            ),
          ),
          child: Column(
            children: [
              // Nombre de la categoría
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: _getCategoryColor(category),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  category,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Items clasificados aquí
              if (items.isEmpty)
                Container(
                  height: 60,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey.shade300,
                      style: BorderStyle.solid,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      'Suelta aquí',
                      style: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 12,
                      ),
                    ),
                  ),
                )
              else
                Column(
                  children: items.map((item) {
                    return _buildClassifiedItem(
                      item,
                      category,
                      isCorrectCategory,
                    );
                  }).toList(),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDraggableItem(ClassifyItem item, int index) {
    return Draggable<ClassifyItem>(
      data: item,
      feedback: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppTheme.accentBlue,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            item.text,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
      ),
      childWhenDragging: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Text(
          item.text,
          style: TextStyle(
            color: Colors.grey.shade400,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.accentBlue),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.drag_indicator, size: 18, color: Colors.grey.shade400),
            const SizedBox(width: 6),
            Text(
              item.text,
              style: TextStyle(
                color: AppTheme.primaryDark,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ).animate().fadeIn(delay: (index * 100).ms).slideX(begin: 0.1),
    );
  }

  Widget _buildClassifiedItem(
    ClassifyItem item,
    String category,
    bool showResult,
  ) {
    final isCorrect = item.correctCategory == category;

    Color bgColor = Colors.white;
    Color borderColor = AppTheme.accentBlue;

    if (showResult) {
      if (isCorrect) {
        bgColor = Colors.green.shade50;
        borderColor = Colors.green;
      } else {
        bgColor = Colors.red.shade50;
        borderColor = Colors.red;
      }
    }

    return GestureDetector(
      onTap: widget.isAnswered
          ? null
          : () {
              // Permitir quitar el item de la categoría
              widget.onItemClassified(item.id, '');
            },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: borderColor, width: 1.5),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                item.text,
                style: TextStyle(
                  color: AppTheme.primaryDark,
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                ),
              ),
            ),
            if (showResult)
              Icon(
                isCorrect ? Icons.check_circle : Icons.cancel,
                color: isCorrect ? Colors.green : Colors.red,
                size: 20,
              )
            else
              Icon(Icons.close, color: Colors.grey.shade400, size: 18),
          ],
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    // Colores predefinidos para categorías
    final colors = [
      AppTheme.accentBlue,
      AppTheme.accentGreen,
      const Color(0xFFFF6B6B),
      const Color(0xFFFFAE00),
    ];

    final index = widget.question.categories?.indexOf(category) ?? 0;
    return colors[index % colors.length];
  }
}
