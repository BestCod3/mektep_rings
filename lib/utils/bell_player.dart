import 'package:just_audio/just_audio.dart';
import '../providers/audiofiles.dart';

class BellPlayer {
  static final Map<String, AudioPlayer> _players = {};

  static Future<void> playBell(
    String audioPath,
    String bellId,
    int rowIndex,
    int columnIndex,
    Function onStart,
    Function onComplete,
    Function(int, dynamic) updateIcon,
  ) async {
    if (audioPath.isEmpty ||
        audioPath == '🔔' ||
        !audioFiles.contains(audioPath)) {
      onComplete();
      return;
    }

    if (_players.containsKey(bellId)) {
      await _players[bellId]!.stop();
      await _players[bellId]!.dispose();
      _players.remove(bellId);
    }

    final player = AudioPlayer();
    _players[bellId] = player;

    try {
      await player.setAsset(audioPath);

      player.playerStateStream.listen((playerState) {
        if (playerState.playing) {
          onStart();
        } else if (playerState.processingState == ProcessingState.completed) {
          onComplete();
          _disposePlayer(bellId);
        }
      });

      await player.play();
    } catch (e) {
      onComplete();
      _disposePlayer(bellId);
    }
  }

  static void _disposePlayer(String bellId) {
    if (_players.containsKey(bellId)) {
      _players[bellId]!.stop();
      _players[bellId]!.dispose();
      _players.remove(bellId);
    }
  }
}
