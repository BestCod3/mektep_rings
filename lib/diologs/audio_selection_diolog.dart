import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mektep_rings/theme/app_text_styles.dart';

import '../providers/audiofiles.dart';

class AudioSelectionDialog extends ConsumerWidget {
  final String currentAudio;
  final Function(String) onAudioSelected;

  const AudioSelectionDialog({
    super.key,
    required this.currentAudio,
    required this.onAudioSelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: Text('Аудио тандоо', style: AppTextStyle.size20boldgreen),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      content: SizedBox(
        width: 300,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButton<String>(
              value: audioFiles.contains(currentAudio) ? currentAudio : null,
              hint: const Text('Аудио тандоо'),
              isExpanded: true,
              items:
                  audioFiles
                      .map(
                        (audio) => DropdownMenuItem<String>(
                          value: audio,
                          child: Text(audio.split('/').last),
                        ),
                      )
                      .toList(),
              onChanged: (value) {
                if (value != null) {
                  onAudioSelected(value);
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Баш тартуу', style: AppTextStyle.size16bold),
        ),
      ],
    );
  }
}
