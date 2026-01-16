import 'package:audioplayers/audioplayers.dart';
import 'package:piensa_play/core/services/logger_service.dart';

/// Service to manage audio playback across the app
/// Includes preloaded sound effects for instant playback
class AudioService {
  // Singleton pattern
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal() {
    _initSoundEffects();
  }

  final AudioPlayer _player = AudioPlayer();
  bool _isPlaying = false;
  String? _currentAudio;

  // Pre-loaded sound effect players for instant playback
  late AudioPlayer _correctPlayer;
  late AudioPlayer _incorrectPlayer;
  late AudioPlayer _tapPlayer;
  bool _effectsInitialized = false;

  /// Initialize sound effect players (preload for instant playback)
  Future<void> _initSoundEffects() async {
    try {
      _correctPlayer = AudioPlayer();
      _incorrectPlayer = AudioPlayer();
      _tapPlayer = AudioPlayer();

      // Set audio sources (preload)
      await _correctPlayer.setSource(AssetSource('audio/correct.wav'));
      await _incorrectPlayer.setSource(AssetSource('audio/incorrect.mp3'));

      // Set release mode to stop (so we can replay)
      await _correctPlayer.setReleaseMode(ReleaseMode.stop);
      await _incorrectPlayer.setReleaseMode(ReleaseMode.stop);
      await _tapPlayer.setReleaseMode(ReleaseMode.stop);

      _effectsInitialized = true;
      AppLogger.debug('Sound effects preloaded successfully');
    } catch (e) {
      AppLogger.error('Error preloading sound effects: $e');
    }
  }

  /// Check if audio is currently playing
  bool get isPlaying => _isPlaying;

  /// Get the current audio path
  String? get currentAudio => _currentAudio;

  /// Play mascot audio from assets
  Future<void> playMascotAudio(String audioFileName) async {
    try {
      if (_isPlaying) {
        await stop();
      }
      final assetPath = 'audio/mascot/$audioFileName';
      _currentAudio = assetPath;
      await _player.play(AssetSource(assetPath));
      _isPlaying = true;
      _player.onPlayerComplete.listen((_) {
        _isPlaying = false;
        _currentAudio = null;
      });
    } catch (e) {
      AppLogger.error('Error playing audio: $e');
      _isPlaying = false;
      _currentAudio = null;
    }
  }

  /// Play correct answer sound (INSTANT - preloaded)
  Future<void> playCorrect() async {
    if (!_effectsInitialized) return;
    try {
      await _correctPlayer.stop(); // Reset position
      await _correctPlayer.resume(); // Play instantly
    } catch (e) {
      AppLogger.error('Error playing correct sound: $e');
    }
  }

  /// Play incorrect answer sound (INSTANT - preloaded)
  Future<void> playIncorrect() async {
    if (!_effectsInitialized) return;
    try {
      await _incorrectPlayer.stop(); // Reset position
      await _incorrectPlayer.resume(); // Play instantly
    } catch (e) {
      AppLogger.error('Error playing incorrect sound: $e');
    }
  }

  /// Play tap sound (using system feedback)
  /// This is handled by HapticFeedback in the widgets

  /// Stop currently playing audio
  Future<void> stop() async {
    try {
      await _player.stop();
      _isPlaying = false;
      _currentAudio = null;
    } catch (e) {
      AppLogger.error('Error stopping audio: $e');
    }
  }

  /// Pause currently playing audio
  Future<void> pause() async {
    try {
      await _player.pause();
      _isPlaying = false;
    } catch (e) {
      AppLogger.error('Error pausing audio: $e');
    }
  }

  /// Resume paused audio
  Future<void> resume() async {
    try {
      await _player.resume();
      _isPlaying = true;
    } catch (e) {
      AppLogger.error('Error resuming audio: $e');
    }
  }

  /// Dispose all audio players
  void dispose() {
    _player.dispose();
    _correctPlayer.dispose();
    _incorrectPlayer.dispose();
    _tapPlayer.dispose();
  }
}
