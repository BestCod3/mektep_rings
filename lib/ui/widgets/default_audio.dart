import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:mektep_rings/ui/widgets/app_icons.dart';

import '../../providers/default_audio_provider.dart';
import '../../theme/app_text_styles.dart';

class DefaultAudio extends ConsumerWidget {
  const DefaultAudio({super.key});

  Future<void> playAudio(WidgetRef ref, String path) async {
    try {
      final audioPlayer = ref.read(audioPlayerProvider);
      await audioPlayer.stop();
      await audioPlayer.setAsset(path);
      await audioPlayer.play();
    } catch (e) {
      print("Ката: $e");
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () {
            playAudio(ref, 'assets/audio/default_lesson.mp3');
          },
          icon: const AppIcon(AppIcons.play_circle),
          alignment: Alignment.bottomLeft,
        ),
        Text('Кирүү', style: AppTextStyle.size16bold),
        const Gap(10),
        IconButton(
          onPressed: () {
            playAudio(ref, 'assets/audio/exit_lesson.mp3');
          },
          icon: const AppIcon(AppIcons.play_circle),
        ),
        Text('Чыгуу', style: AppTextStyle.size16bold),
      ],
    );
  }
}
