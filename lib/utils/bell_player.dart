// import 'package:just_audio/just_audio.dart';
// import '../providers/audiofiles.dart';

// class BellPlayer {
//   static final Map<String, AudioPlayer> _players = {};

//   static Future<void> playBell(
//     String audioPath,
//     String bellId,
//     int rowIndex,
//     int columnIndex,
//     Function onStart,
//     Function onComplete,
//     Function(int, dynamic) updateIcon,
//   ) async {
//     if (audioPath.isEmpty ||
//         audioPath == '🔔' ||
//         !audioFiles.contains(audioPath)) {
//       onComplete();
//       return;
//     }

//     if (_players.containsKey(bellId)) {
//       await _players[bellId]!.stop();
//       await _players[bellId]!.dispose();
//       _players.remove(bellId);
//     }

//     final player = AudioPlayer();
//     _players[bellId] = player;

//     try {
//       await player.setAsset(audioPath);

//       player.playerStateStream.listen((playerState) {
//         if (playerState.playing) {
//           onStart();
//         } else if (playerState.processingState == ProcessingState.completed) {
//           onComplete();
//           _disposePlayer(bellId);
//         }
//       });

//       await player.play();
//     } catch (e) {
//       onComplete();
//       _disposePlayer(bellId);
//     }
//   }

//   static void _disposePlayer(String bellId) {
//     if (_players.containsKey(bellId)) {
//       _players[bellId]!.stop();
//       _players[bellId]!.dispose();
//       _players.remove(bellId);
//     }
//   }
// }

// import 'package:audioplayers/audioplayers.dart';
// import '../providers/audiofiles.dart';

// class BellPlayer {
//   static final Map<String, AudioPlayer> _players = {};

//   static Future<void> playBell(
//     String audioPath,
//     String bellId,
//     int rowIndex,
//     int columnIndex,
//     Function onStart,
//     Function onComplete,
//     Function(int, dynamic) updateIcon,
//   ) async {
//     if (audioPath.isEmpty ||
//         audioPath == '🔔' ||
//         !audioFiles.contains(audioPath)) {
//       onComplete();
//       return;
//     }

//     // Остановим и удалим старый плеер, если он есть
//     if (_players.containsKey(bellId)) {
//       await _players[bellId]!.stop();
//       await _players[bellId]!.dispose();
//       _players.remove(bellId);
//     }

//     final player = AudioPlayer();
//     _players[bellId] = player;

//     player.onPlayerStateChanged.listen((state) {
//       if (state == PlayerState.playing) {
//         onStart();
//       }
//     });

//     player.onPlayerComplete.listen((event) {
//       onComplete();
//       _disposePlayer(bellId);
//     });

//     try {
//       await player.play(AssetSource(audioPath));
//     } catch (e) {
//       onComplete();
//       _disposePlayer(bellId);
//     }
//   }

//   static void _disposePlayer(String bellId) {
//     if (_players.containsKey(bellId)) {
//       _players[bellId]!.stop();
//       _players[bellId]!.dispose();
//       _players.remove(bellId);
//     }
//   }
// }
import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/widgets.dart';

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

    // Остановим и удалим старый плеер, если он есть
    if (_players.containsKey(bellId)) {
      await _players[bellId]!.stop();
      await _players[bellId]!.dispose();
      _players.remove(bellId);
    }

    final player = AudioPlayer();
    _players[bellId] = player;

    player.onPlayerStateChanged.listen((state) {
      if (state == PlayerState.playing) {
        onStart();
      }
    });

    player.onPlayerComplete.listen((event) {
      onComplete();
      _disposePlayer(bellId);
    });

    try {
      // Чтобы избежать ошибки "Platform channel messages must be sent on the platform thread"
      await Future.microtask(() async {
        if (_isAsset(audioPath)) {
          // Воспроизводим из assets
          await player.play(AssetSource(audioPath));
        } else if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
          // Воспроизводим локальный файл по абсолютному пути
          final uri = Uri.file(audioPath);
          await player.play(UrlSource(uri.toString()));
        } else {
          // Для Android/iOS - локальный файл
          await player.play(DeviceFileSource(audioPath));
        }
      });
    } catch (e) {
      onComplete();
      _disposePlayer(bellId);
      print('Ошибка при воспроизведении аудио: $e');
    }
  }

  static void _disposePlayer(String bellId) {
    if (_players.containsKey(bellId)) {
      _players[bellId]!.stop();
      _players[bellId]!.dispose();
      _players.remove(bellId);
    }
  }

  static bool _isAsset(String path) {
    // В твоем проекте assets скорее всего начинаются с "audio/" или другого префикса
    // Проверь под себя и поправь
    return path.startsWith('audio/');
  }
}
