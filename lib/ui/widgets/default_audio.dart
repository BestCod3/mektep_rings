import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:mektep_rings/providers/default_audio_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

//до
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:mektep_rings/ui/widgets/app_icons.dart';
import 'package:audioplayers/audioplayers.dart';

import '../../providers/default_audio_provider.dart';
import '../../theme/app_text_styles.dart';

class DefaultAudio extends ConsumerWidget {
  const DefaultAudio({super.key});

  Future<void> playAudio(WidgetRef ref, String path) async {
    try {
      final audioPlayer = ref.read(audioPlayerProvider);
      await audioPlayer.stop();
      await audioPlayer.play(AssetSource(path)); // путь без "assets/"
    } catch (e) {
      print("Ката: $e");
    }
  }

  Future<void> pauseAudio(WidgetRef ref) async {
    try {
      final audioPlayer = ref.read(audioPlayerProvider);
      await audioPlayer.pause();
    } catch (e) {
      print("Пауза ката: $e");
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () {
            playAudio(ref, 'audio/default_lesson.mp3'); // ✅ путь правильный
          },
          icon: const AppIcon(AppIcons.play_circle),
          alignment: Alignment.bottomLeft,
        ),
        Text('Кирүү', style: AppTextStyle.size16bold),
        const Gap(10),
        IconButton(
          onPressed: () {
            playAudio(ref, 'audio/exit_lesson.mp3'); // ✅ путь правильный
          },
          icon: const AppIcon(AppIcons.play_circle),
        ),
        Text('Чыгуу', style: AppTextStyle.size16bold),
        const Gap(10),
        IconButton(
          onPressed: () {
            pauseAudio(ref);
          },
          icon: const Icon(Icons.pause_circle_sharp, size: 29),
        ),
        Text('Токтотуу', style: AppTextStyle.size16bold),
      ],
    );
  }
}
