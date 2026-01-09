// lib/features/learn/presentation/pages/video_player_page.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/media_item.dart';

class VideoPlayerPage extends StatefulWidget {
  final MediaItem item;

  const VideoPlayerPage({super.key, required this.item});

  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  late YoutubePlayerController _controller;
  bool _isPlayerReady = false;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  void _initializePlayer() {
    _controller = YoutubePlayerController(
      initialVideoId: widget.item.youtubeId ?? '',
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        enableCaption: false,
        forceHD: false,
        loop: false,
      ),
    )..addListener(_listener);
  }

  void _listener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      setState(() {});
    }
  }

  @override
  void deactivate() {
    // Pause video when navigating away
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    // Reset orientation to portrait
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return YoutubePlayerBuilder(
      onExitFullScreen: () {
        // Reset to portrait when exiting fullscreen
        SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
      },
      onEnterFullScreen: () {
        // Allow all orientations in fullscreen for shorts (vertical videos)
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ]);
      },
      player: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        progressIndicatorColor: AppTheme.accentPink,
        progressColors: const ProgressBarColors(
          playedColor: AppTheme.accentPink,
          handleColor: AppTheme.accentPink,
        ),
        onReady: () {
          _isPlayerReady = true;
        },
      ),
      builder: (context, player) {
        return Scaffold(
          backgroundColor: isDark
              ? AppTheme.backgroundDark
              : AppTheme.backgroundLight,
          body: Column(
            children: [
              // Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(
                  top: 50,
                  bottom: 20,
                  left: 20,
                  right: 20,
                ),
                decoration: BoxDecoration(
                  color: isDark ? AppTheme.surfaceDark : AppTheme.tertiaryDark,
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Expanded(
                      child: Text(
                        widget.item.title,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 48), // Balance for back button
                  ],
                ),
              ),

              // Video Player
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // YouTube Player
                      player,

                      // Video Info
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title
                            Text(
                              widget.item.title,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: isDark
                                    ? AppTheme.textPrimaryDark
                                    : AppTheme.primaryDark,
                              ),
                            ),
                            const SizedBox(height: 8),

                            // Duration badge
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.accentPink.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.access_time,
                                    size: 16,
                                    color: AppTheme.accentPink,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    widget.item.formattedDuration,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: AppTheme.accentPink,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Description
                            Text(
                              widget.item.description,
                              style: TextStyle(
                                fontSize: 16,
                                height: 1.5,
                                color: isDark
                                    ? AppTheme.textSecondaryDark
                                    : Colors.grey.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
