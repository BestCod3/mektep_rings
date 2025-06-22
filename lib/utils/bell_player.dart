import 'dart:async';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

class BellPlayer {
  static final AudioPlayer _player = AudioPlayer();
  static StreamSubscription? _completionSubscription;

  static Future<void> playBell(
    String path,
    String key,
    int rowIndex,
    int columnIndex,
    VoidCallback onStart,
    VoidCallback onComplete,
    Function(int columnIndex, dynamic value) onError,
  ) async {
    try {
      // Остановить и сбросить до воспроизведения
      await _player.stop();
      await _completionSubscription?.cancel();
      _completionSubscription = null;

      onStart();

      Source source;
      if (path.startsWith('audio/')) {
        source = AssetSource(path);
      } else if (path.contains(':') || File(path).existsSync()) {
        source = DeviceFileSource(path);
      } else {
        throw Exception('Invalid audio path: $path');
      }

      await _player.play(source);

      _completionSubscription = _player.onPlayerComplete.listen((event) {
        onComplete();
      });
    } catch (e) {
      print('Error playing audio: $e');
      onError(columnIndex, e);
    }
  }
}
