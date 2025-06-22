import 'dart:io';
import 'package:file_picker/file_picker.dart';
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
    final allAudio = [...audioFiles];

    if (!currentAudio.startsWith('audio/') && currentAudio.contains(':')) {
      allAudio.add(currentAudio); // Добавляем кастомный, если он есть
    }

    return AlertDialog(
      title: Text('Аудио тандоо', style: AppTextStyle.size20boldgreen),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      content: SizedBox(
        width: 300,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButton<String>(
              value: allAudio.contains(currentAudio) ? currentAudio : null,
              hint: const Text('Аудио тандоо'),
              isExpanded: true,
              items:
                  allAudio.map((audio) {
                    final fileName = audio.split(Platform.pathSeparator).last;
                    return DropdownMenuItem<String>(
                      value: audio,
                      child: Text(fileName),
                    );
                  }).toList(),
              onChanged: (value) {
                if (value != null) {
                  onAudioSelected(value);
                  Navigator.pop(context);
                }
              },
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () async {
                final result = await FilePicker.platform.pickFiles(
                  type: FileType.audio,
                );
                if (result != null && result.files.single.path != null) {
                  final filePath = result.files.single.path!;
                  onAudioSelected(filePath);
                  Navigator.pop(context);
                }
              },
              child: const Text(
                'Обзор...',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.pink,
                ),
              ),
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
