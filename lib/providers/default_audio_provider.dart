// import 'dart:io';

// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:just_audio/just_audio.dart';

// final audioPlayerProvider = Provider<AudioPlayer>((ref) {
//   final player = AudioPlayer();

//   ref.onDispose(() {
//     if (!Platform.isWindows) {
//       player.dispose();
//     }
//   });

//   return player;
// });
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:audioplayers/audioplayers.dart'; //  вместо just_audio

final audioPlayerProvider = Provider<AudioPlayer>((ref) {
  final player = AudioPlayer();

  ref.onDispose(() {
    player.dispose();
  });

  return player;
});
