import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../data/datasources/veracidadville/veracidadville_quiz_data.dart';
import '../../../domain/entities/veracidadville/quiz_question.dart';
import 'quiz_feedback_page.dart';

class QuizQuestionPage extends StatefulWidget {
  final int questionIndex;

  const QuizQuestionPage({super.key, required this.questionIndex});

  @override
  State<QuizQuestionPage> createState() => _QuizQuestionPageState();
}

class _QuizQuestionPageState extends State<QuizQuestionPage> {
  late QuizQuestion question;
  final Set<String> selectedElements = {};
  final List<QuizQuestion> allQuestions = VeracidadvilleQuizData.getQuestions();

  @override
  void initState() {
    super.initState();
    question = allQuestions[widget.questionIndex];
  }

  void _toggleElement(String elementId) {
    setState(() {
      if (selectedElements.contains(elementId)) {
        selectedElements.remove(elementId);
      } else {
        selectedElements.add(elementId);
      }
    });
  }

  void _continue() {
    final correctElements = question.elements
        .where((e) => e.isCorrect)
        .map((e) => e.id)
        .toSet();
    final correctlySelected = selectedElements.intersection(correctElements);
    final incorrectlySelected = selectedElements.difference(correctElements);
    final missed = correctElements.difference(selectedElements);

    final isCorrect = incorrectlySelected.isEmpty && missed.isEmpty;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuizFeedbackPage(
          questionIndex: widget.questionIndex,
          selectedElements: selectedElements,
          isCorrect: isCorrect,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final progress = (widget.questionIndex + 1) / allQuestions.length;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.primaryDark,
              AppTheme.primaryDark.withOpacity(0.9),
              Colors.white,
            ],
            stops: const [0.0, 0.3, 0.3],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(progress),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      _buildNewsCard(),
                      const SizedBox(height: 24),
                      _buildElementsGrid(),
                      const SizedBox(height: 30),
                      _buildContinueButton(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(double progress) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Veracidadville',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Pregunta ${widget.questionIndex + 1} de ${allQuestions.length}',
                    style: const TextStyle(fontSize: 14, color: Colors.white70),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFDD835),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFDD835).withOpacity(0.5),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Text('🔍', style: TextStyle(fontSize: 24)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: Colors.white.withOpacity(0.3),
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFFFDD835),
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms);
  }

  Widget _buildNewsCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.accentPink,
                  AppTheme.accentPink.withOpacity(0.8),
                ],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: Row(
              children: [
                const Text('📰', style: TextStyle(fontSize: 32)),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'ANALIZA ESTA NOTICIA',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        question.newsSource,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      question.newsDate,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  question.newsTitle,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  question.newsContent,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700],
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Icon(
                      Icons.person_outline,
                      size: 16,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      question.newsAuthor,
                      style: const TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.share_outlined,
                      size: 16,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      question.newsShares,
                      style: const TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().scale(delay: 200.ms, duration: 400.ms, curve: Curves.easeOut);
  }

  Widget _buildElementsGrid() {
    final elementData = [
      {
        'id': 'author',
        'emoji': '👤',
        'title': 'Autor',
        'subtitle': '¿Es confiable?',
        'color': const Color(0xFF6EC6FF),
      },
      {
        'id': 'source',
        'emoji': '🔗',
        'title': 'Fuente',
        'subtitle': '¿Es verificada?',
        'color': const Color(0xFFA4D65E),
      },
      {
        'id': 'image',
        'emoji': '🖼️',
        'title': 'Imagen',
        'subtitle': '¿Es manipulada?',
        'color': const Color(0xFFFFB74D),
      },
      {
        'id': 'data',
        'emoji': '📊',
        'title': 'Datos',
        'subtitle': '¿Son exagerados?',
        'color': const Color(0xFFE91E63),
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppTheme.accentYellow,
                AppTheme.accentYellow.withOpacity(0.8),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              const Text('🎯', style: TextStyle(fontSize: 28)),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  '¿Qué elementos son sospechosos?',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 0.85,
          children: elementData.asMap().entries.map((entry) {
            final index = entry.key;
            final data = entry.value;
            final element = question.elements.firstWhere(
              (e) => e.id == data['id'],
            );
            return _buildElementCard(
              element: element,
              emoji: data['emoji'] as String,
              title: data['title'] as String,
              subtitle: data['subtitle'] as String,
              color: data['color'] as Color,
              index: index,
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildElementCard({
    required dynamic element,
    required String emoji,
    required String title,
    required String subtitle,
    required Color color,
    required int index,
  }) {
    final isSelected = selectedElements.contains(element.id);

    return GestureDetector(
          onTap: () => _toggleElement(element.id),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutBack,
            decoration: BoxDecoration(
              gradient: isSelected
                  ? LinearGradient(
                      colors: [color, color.withOpacity(0.7)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
              color: isSelected ? null : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected ? color : Colors.grey[300]!,
                width: isSelected ? 3 : 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: isSelected
                      ? color.withOpacity(0.4)
                      : Colors.black.withOpacity(0.05),
                  blurRadius: isSelected ? 16 : 8,
                  offset: Offset(0, isSelected ? 8 : 4),
                ),
              ],
            ),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.white.withOpacity(0.3)
                              : color.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            emoji,
                            style: const TextStyle(fontSize: 32),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.white : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 13,
                          color: isSelected
                              ? Colors.white.withOpacity(0.9)
                              : Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                if (isSelected)
                  Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.check, color: color, size: 20),
                        ),
                      )
                      .animate(onPlay: (controller) => controller.forward())
                      .scale(duration: 200.ms, curve: Curves.easeOutBack),
              ],
            ),
          ),
        )
        .animate(delay: (300 + index * 100).ms)
        .scale(
          begin: const Offset(0.8, 0.8),
          duration: 400.ms,
          curve: Curves.easeOutBack,
        );
  }

  Widget _buildContinueButton() {
    final canContinue = selectedElements.isNotEmpty;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        gradient: canContinue
            ? const LinearGradient(
                colors: [AppTheme.accentPink, Color(0xFFD81B60)],
              )
            : null,
        color: canContinue ? null : Colors.grey[300],
        borderRadius: BorderRadius.circular(30),
        boxShadow: canContinue
            ? [
                BoxShadow(
                  color: AppTheme.accentPink.withOpacity(0.5),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ]
            : [],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: canContinue ? _continue : null,
          borderRadius: BorderRadius.circular(30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Verificar Respuesta',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: canContinue ? Colors.white : Colors.grey[500],
                ),
              ),
              const SizedBox(width: 12),
              Icon(
                Icons.arrow_forward,
                color: canContinue ? Colors.white : Colors.grey[500],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
