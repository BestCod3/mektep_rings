import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'ui/screens/shedule_screen.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mektep Rings',
      theme: ThemeData(primarySwatch: Colors.green),
      home: const ScheduleScreen(),
    );
  }
}
// import 'package:flutter/material.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:audioplayers/audioplayers.dart';
// import 'dart:io'; // для Platform и Uri.file

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(home: AudioPlayerScreen());
//   }
// }

// class AudioPlayerScreen extends StatefulWidget {
//   const AudioPlayerScreen({super.key});
//   @override
//   State<AudioPlayerScreen> createState() => _AudioPlayerScreenState();
// }

// class _AudioPlayerScreenState extends State<AudioPlayerScreen> {
//   final AudioPlayer _player = AudioPlayer();
//   String? selectedPath;

//   Future<void> pickAndPlayFile() async {
//     final result = await FilePicker.platform.pickFiles(
//       type: FileType.custom,
//       allowedExtensions: ['mp3', 'wav', 'ogg'],
//     );

//     if (result != null && result.files.single.path != null) {
//       final path = result.files.single.path!;
//       setState(() => selectedPath = path);

//       // Преобразуем путь в Uri для Windows
//       if (Platform.isWindows) {
//         final uri = Uri.file(path);
//         await _player.stop();
//         await _player.play(UrlSource(uri.toString()));
//       } else {
//         // Android / iOS
//         await _player.stop();
//         await _player.play(DeviceFileSource(path));
//       }
//     } else {
//       print("Файл не выбран");
//     }
//   }

//   @override
//   void dispose() {
//     _player.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Windows Audio Player')),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(
//               onPressed: pickAndPlayFile,
//               child: const Text('Выбрать и проиграть аудио'),
//             ),
//             if (selectedPath != null) ...[
//               const SizedBox(height: 20),
//               Text('Файл: ${selectedPath!.split('\\').last}'),
//             ],
//           ],
//         ),
//       ),
//     );
//   }
// }
