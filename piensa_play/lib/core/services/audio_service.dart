import 'package:audioplayers/audioplayers.dart';

/// Service to manage mascot audio playback across the app
/// Ensures only one audio plays at a time
class AudioService {
  // Singleton pattern
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  final AudioPlayer _player = AudioPlayer();
  bool _isPlaying = false;
  String? _currentAudio;

  /// Check if audio is currently playing
  bool get isPlaying => _isPlaying;

  /// Get the current audio path
  String? get currentAudio => _currentAudio;

  /// Play mascot audio from assets
  /// Automatically stops any currently playing audio
  Future<void> playMascotAudio(String audioFileName) async {
    try {
      // Stop current audio if playing
      if (_isPlaying) {
        await stop();
      }

      // Build the asset path
      final assetPath = 'audio/mascot/$audioFileName';
      _currentAudio = assetPath;

      // Play the audio
      await _player.play(AssetSource(assetPath));
      _isPlaying = true;

      // Listen for completion
      _player.onPlayerComplete.listen((_) {
        _isPlaying = false;
        _currentAudio = null;
      });
    } catch (e) {
      print('Error playing audio: $e');
      _isPlaying = false;
      _currentAudio = null;
    }
  }

  /// Stop currently playing audio
  Future<void> stop() async {
    try {
      await _player.stop();
      _isPlaying = false;
      _currentAudio = null;
    } catch (e) {
      print('Error stopping audio: $e');
    }
  }

  /// Pause currently playing audio
  Future<void> pause() async {
    try {
      await _player.pause();
      _isPlaying = false;
    } catch (e) {
      print('Error pausing audio: $e');
    }
  }

  /// Resume paused audio
  Future<void> resume() async {
    try {
      await _player.resume();
      _isPlaying = true;
    } catch (e) {
      print('Error resuming audio: $e');
    }
  }

  /// Dispose the audio player
  void dispose() {
    _player.dispose();
  }
}
