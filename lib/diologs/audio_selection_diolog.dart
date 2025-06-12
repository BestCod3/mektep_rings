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
// import 'package:flutter/material.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:mektep_rings/theme/app_text_styles.dart';

// import '../providers/audiofiles.dart';

// class AudioSelectionDialog extends ConsumerStatefulWidget {
//   final String currentAudio;
//   final Function(String) onAudioSelected;

//   const AudioSelectionDialog({
//     super.key,
//     required this.currentAudio,
//     required this.onAudioSelected,
//   });

//   @override
//   ConsumerState<AudioSelectionDialog> createState() =>
//       _AudioSelectionDialogState();
// }

// class _AudioSelectionDialogState extends ConsumerState<AudioSelectionDialog> {
//   String? selectedAudio;

//   @override
//   void initState() {
//     super.initState();
//     selectedAudio =
//         audioFiles.contains(widget.currentAudio) ? widget.currentAudio : null;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: Text('Аудио тандоо', style: AppTextStyle.size20boldgreen),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
//       content: SizedBox(
//         width: 300,
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             DropdownButton<String>(
//               value: selectedAudio,
//               hint: const Text('Аудио тандоо'),
//               isExpanded: true,
//               items:
//                   audioFiles
//                       .map(
//                         (audio) => DropdownMenuItem<String>(
//                           value: audio,
//                           child: Text(audio.split('/').last),
//                         ),
//                       )
//                       .toList(),
//               onChanged: (value) {
//                 if (value != null) {
//                   widget.onAudioSelected(value);
//                   Navigator.pop(context);
//                 }
//               },
//             ),
//           ],
//         ),
//       ),
//       actions: [
//         TextButton(
//           onPressed: () async {
//             FilePickerResult? result = await FilePicker.platform.pickFiles(
//               type: FileType.custom,
//               allowedExtensions: ['mp3', 'wav', 'ogg'],
//               allowMultiple: false,
//               withData: false,
//             );

//             if (result != null && result.files.single.path != null) {
//               final path = result.files.single.path!;
//               widget.onAudioSelected(path); // передаём путь дальше
//               Navigator.pop(context);
//             }
//           },
//           child: Text('Обзор', style: AppTextStyle.size16bold),
//         ),
//         TextButton(
//           onPressed: () => Navigator.pop(context),
//           child: Text('Баш тартуу', style: AppTextStyle.size16bold),
//         ),
//       ],
//     );
//   }
// }
