import 'package:flutter/material.dart';
import '../../../../core/localization/app_locale.dart';
import '../../../../core/theme/app_theme.dart';

class ProgressCircle extends StatelessWidget {
  final double progress;
  final Map<String, double> monthlyProgress;

  const ProgressCircle({
    super.key,
    required this.progress,
    required this.monthlyProgress,
  });

  @override
  Widget build(BuildContext context) {
    final english = Localizations.localeOf(context).languageCode == 'en';
    final dark = Theme.of(context).brightness == Brightness.dark;
    final trackColor = dark ? Colors.white12 : Colors.grey.shade200;
    final labelColor = Theme.of(context).textTheme.bodyMedium?.color;
    return Container(
      margin: const EdgeInsets.all(20),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Text(
                context.strings.t('overallProgress'),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 24),
              // Círculo de progreso usando CircularProgressIndicator
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 160,
                    height: 160,
                    child: CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 12,
                      backgroundColor: trackColor,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppTheme.blueText(dark),
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${(progress * 100).toInt()}%',
                        style: Theme.of(context).textTheme.displaySmall
                            ?.copyWith(fontSize: 36),
                      ),
                      Text(
                        english ? 'Completed' : 'Completado',
                        style: TextStyle(fontSize: 14, color: labelColor),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Progreso mensual
              ...monthlyProgress.entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 40,
                        child: Text(
                          entry.key,
                          style: TextStyle(fontSize: 14, color: labelColor),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: entry.value,
                            backgroundColor: trackColor,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              entry.value >= 0.7
                                  ? AppTheme.greenText(dark)
                                  : AppTheme.goldText(dark),
                            ),
                            minHeight: 8,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      SizedBox(
                        width: 40,
                        child: Text(
                          '${(entry.value * 100).toInt()}%',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: labelColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
