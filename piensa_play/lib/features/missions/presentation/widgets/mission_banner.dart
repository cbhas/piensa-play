import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class MissionBanner extends StatelessWidget {
  final String missionTitle;
  final String missionDescription;
  final Color backgroundColor;
  final Color? textColor; // Color for text and button

  const MissionBanner({
    super.key,
    required this.missionTitle,
    required this.missionDescription,
    required this.backgroundColor,
    this.textColor, // Optional, defaults to white
  });

  @override
  Widget build(BuildContext context) {
    return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          decoration: BoxDecoration(
            color: backgroundColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.25),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2.5),
                    ),
                    child: const Icon(
                      Icons.article_outlined,
                      color: Colors.white,
                      size: 26,
                    ),
                  )
                  .animate()
                  .scale(
                    delay: 100.ms,
                    duration: 400.ms,
                    curve: Curves.easeOutBack,
                  )
                  .fadeIn(duration: 300.ms),
              const SizedBox(width: 14),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  switchInCurve: Curves.easeOut,
                  switchOutCurve: Curves.easeIn,
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                        return FadeTransition(
                          opacity: animation,
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0.05, 0), // Very subtle slide
                              end: Offset.zero,
                            ).animate(animation),
                            child: child,
                          ),
                        );
                      },
                  child: Column(
                    key: ValueKey<String>(missionTitle), // Key triggers switch
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        missionTitle,
                        style: TextStyle(
                          color: textColor ?? Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        missionDescription,
                        style: TextStyle(
                          color: (textColor ?? Colors.white).withOpacity(0.92),
                          fontSize: 13,
                          height: 1.2,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        )
        .animate() // Initial entry animation for the box
        .fadeIn(duration: 250.ms)
        .slideY(
          begin: -0.3,
          end: 0,
          duration: 400.ms,
          curve: Curves.easeOutCubic,
        )
        // Subtle pulse on update
        .animate(key: ValueKey(missionTitle), target: 1)
        .shimmer(
          duration: 500.ms,
          color: Colors.white.withOpacity(0.15),
          curve: Curves.easeInOut,
        );
  }
}
