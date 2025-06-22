import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mektep_rings/diologs/audio_selection_diolog.dart';
import 'package:mektep_rings/providers/audio_providers.dart';
import 'package:mektep_rings/providers/default_audio_provider.dart';
import 'package:mektep_rings/theme/app_text_styles.dart';
import 'package:mektep_rings/ui/widgets/app_icons.dart';
import 'package:mektep_rings/ui/widgets/app_itc_logo.dart';
import 'package:mektep_rings/ui/widgets/default_audio.dart';
import 'package:mektep_rings/ui/widgets/header_widget.dart';
import 'package:mektep_rings/utils/bell_player.dart';
import 'package:mektep_rings/utils/check_bell.dart';
import 'package:mektep_rings/utils/edit_cell.dart';

// class ScheduleScreen extends ConsumerWidget {
//   const ScheduleScreen({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final morningSchedule = ref.watch(morningScheduleProvider);
//     final afternoonSchedule = ref.watch(afternoonScheduleProvider);
//     final playedTimes = <String, bool>{};

//     SchedulerBinding.instance.addPostFrameCallback((_) {
//       Timer.periodic(const Duration(seconds: 10), (timer) {
//         final now = DateTime.now();
//         final lastDay = ref.read(playedTimesProvider.notifier).state['lastDay'];
//         if (lastDay != null && lastDay != now.day) {
//           playedTimes.clear();
//           ref.read(currentPlayingProvider.notifier).state = null;
//         }

//         checkBell(morningSchedule, ref, playedTimes, 'morning');
//         checkBell(afternoonSchedule, ref, playedTimes, 'afternoon');

//         if (now.second == 0) {
//           ref.read(playedTimesProvider.notifier).state = {'lastDay': now.day};
//         }
//       });
//     });

//     return Scaffold(
//       body: Container(
//         width: double.infinity,
//         height: double.infinity,
//         decoration: const BoxDecoration(
//           image: DecorationImage(
//             image: AssetImage("assets/images/konguroo.png"),
//             fit: BoxFit.cover,
//           ),
//         ),
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 50),
//         child: SingleChildScrollView(
//           child: ConstrainedBox(
//             constraints: BoxConstraints(
//               maxWidth: MediaQuery.of(context).size.width,
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 HeadarWidget(),
//                 const SizedBox(height: 30),
//                 _buildScheduleTable(
//                   context,
//                   ref,
//                   morningSchedule,
//                   morningScheduleProvider,
//                   'Түшкө чейинки сабактар',
//                 ),
//                 const SizedBox(height: 20),
//                 _buildScheduleTable(
//                   context,
//                   ref,
//                   afternoonSchedule,
//                   afternoonScheduleProvider,
//                   'Түштөн кийинки сабактар',
//                 ),
//                 AppItcLogo(),
//                 const Gap(10),
//                 // 🔔 Кнопки Кирүү/Чыгуу
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     ElevatedButton.icon(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.green,
//                       ),
//                       icon: const Icon(Icons.login),
//                       label: const Text('Кирүү'),
//                       onPressed: () {
//                         BellPlayer.playBell(
//                           'audio/default_lesson.mp3',
//                           'manual_entry',
//                           0,
//                           2,
//                           () => print('▶️ Кирүү башталды: manual_entry'),
//                           () => print('⏹ Кирүү аяктады: manual_entry'),
//                           (col, err) => print('❌ Кирүү ката [$col]: $err'),
//                         );
//                       },
//                     ),
//                     ElevatedButton.icon(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.red,
//                       ),
//                       icon: const Icon(Icons.logout),
//                       label: const Text('Чыгуу'),
//                       onPressed: () {
//                         BellPlayer.playBell(
//                           'audio/exit_lesson.mp3',
//                           'manual_exit',
//                           0,
//                           4,
//                           () => print('▶️ Чыгуу башталды: manual_exit'),
//                           () => print('⏹ Чыгуу аяктады: manual_exit'),
//                           (col, err) => print('❌ Чыгуу ката [$col]: $err'),
//                         );
//                       },
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 10),
//                 DefaultAudio(),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildScheduleTable(
//     BuildContext context,
//     WidgetRef ref,
//     List<List<String>> schedule,
//     StateNotifierProvider<ScheduleNotifier, List<List<String>>> provider,
//     String title,
//   ) {
//     return Column(
//       children: [
//         Text(title, style: AppTextStyle.size20bold),
//         const SizedBox(height: 10),
//         LayoutBuilder(
//           builder: (context, constraints) {
//             final screenWidth = constraints.maxWidth;
//             final double columnSpacing = screenWidth > 600 ? 20 : 10;
//             return SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               child: Container(
//                 color: Colors.white,
//                 padding: const EdgeInsets.all(8.0),
//                 child: DataTable(
//                   border: TableBorder.all(color: Colors.green, width: 1),
//                   columnSpacing: columnSpacing,
//                   headingRowHeight: 60,
//                   dataRowHeight: 40,
// columns: _buildColumns(screenWidth),
//                   rows: _buildRows(context, ref, schedule, provider),
//                 ),
//               ),
//             );
//           },
//         ),
//       ],
//     );
//   }

//   List<DataColumn> _buildColumns(double screenWidth) {
//     return [
//       DataColumn(
//         label: SizedBox(
//           width: screenWidth * 0.150,
//           child: Text(
//             'Сабактардын ирети',
//             style: AppTextStyle.size16bold,
//             textAlign: TextAlign.center,
//           ),
//         ),
//       ),
//       DataColumn(
//         label: SizedBox(
//           width: screenWidth * 0.100,
//           child: Text(
//             'Кирүү',
//             style: AppTextStyle.size16bold,
//             textAlign: TextAlign.center,
//           ),
//         ),
//       ),
//       DataColumn(
//         label: SizedBox(
//           width: screenWidth * 0.100,
//           child: const AppIcon(
//             AppIcons.rectangle,
//             size: 20,
//             color: Colors.yellow,
//           ),
//         ),
//       ),
//       DataColumn(
//         label: SizedBox(
//           width: screenWidth * 0.100,
//           child: Text(
//             'Чыгуу',
//             style: AppTextStyle.size16bold,
//             textAlign: TextAlign.center,
//           ),
//         ),
//       ),
//       DataColumn(
//         label: SizedBox(
//           width: screenWidth * 0.100,
//           child: const Center(
//             child: AppIcon(AppIcons.rectangle, size: 20, color: Colors.yellow),
//           ),
//         ),
//       ),
//     ];
//   }

//   List<DataRow> _buildRows(
//     BuildContext context,
//     WidgetRef ref,
//     List<List<String>> schedule,
//     StateNotifierProvider<ScheduleNotifier, List<List<String>>> provider,
//   ) {
//     return List.generate(schedule.length, (rowIndex) {
//       return DataRow(
//         cells: List.generate(schedule[rowIndex].length, (columnIndex) {
//           return DataCell(
//             GestureDetector(
//               onTap: () async {
//                 if (columnIndex == 0) return;

//                 if (columnIndex == 2 || columnIndex == 4) {
//                   // Выбор аудио
//                   final newAudio = await showDialog<String>(
//                     context: context,
//                     builder:
//                         (_) => AudioSelectionDialog(
//                           currentAudio: schedule[rowIndex][columnIndex],
//                           onAudioSelected:
//                               (_) async {}, // больше ничего не делаем тут
//                         ),
//                   );

//                   if (newAudio != null) {
//                     ref
//                         .read(provider.notifier)
//                         .updateCell(rowIndex, columnIndex, newAudio);
//                     await ref.read(provider.notifier).saveSchedule();

//                     // ✅ Запускаем аудио только один раз
//                     BellPlayer.playBell(
//                       newAudio,
//                       'manual_selected',
//                       rowIndex,
//                       columnIndex,
//                       () => print('▶️ Аудио башталды'),
//                       () => print('⏹ Аудио аяктады'),
//                       (col, err) => print('❌ Аудио ката [$col]: $err'),
//                     );
//                   }

//                   if (newAudio != null) {
//                     ref
//                         .read(provider.notifier)
//                         .updateCell(rowIndex, columnIndex, newAudio);
//                   }
//                 } else if (columnIndex == 1 || columnIndex == 3) {
//                   // Выбор времени
//                   final initialTime = TimeOfDay(
//                     hour: int.parse(
//                       schedule[rowIndex][columnIndex].split(":")[0],
//                     ),
//                     minute: int.parse(
//                       schedule[rowIndex][columnIndex].split(":")[1],
//                     ),
//                   );

//                   final picked = await showTimePicker(
//                     context: context,
//                     initialTime: initialTime,
//                   );

//                   if (picked != null) {
//                     final formattedTime =
//                         '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
//                     ref
//                         .read(provider.notifier)
//                         .updateCell(rowIndex, columnIndex, formattedTime);
//                   }
//                 }
//               },
//               child: Center(
//                 child:
//                     columnIndex == 2 || columnIndex == 4
//                         ? const AppIcon(
//                           AppIcons.notes,
//                           size: 16,
//                           color: Colors.pink,
//                         )
//                         : Text(
//                           schedule[rowIndex][columnIndex].isEmpty
//                               ? '—'
//                               : schedule[rowIndex][columnIndex],
//                           style: const TextStyle(),
//                         ),
//               ),
//             ),
//           );
//         }),
//       );
//     });
//   }
// }

// Новый ScheduleScreen с интеграцией индивидуального выбора времени и аудио для каждой ячейки
// и с работающим таймером воспроизведения.
// Дизайн и стили сохранены.

// Подключаем нужные пакеты

class ScheduleScreen extends ConsumerStatefulWidget {
  const ScheduleScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends ConsumerState<ScheduleScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 10), (_) async {
      await checkBell(
        ref.read(morningScheduleProvider),
        ref,
        ref.read(playedTimesProvider),
        'morning',
      );
      await checkBell(
        ref.read(afternoonScheduleProvider),
        ref,
        ref.read(playedTimesProvider),
        'afternoon',
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final morningSchedule = ref.watch(morningScheduleProvider);
    final afternoonSchedule = ref.watch(afternoonScheduleProvider);
    final player = ref.read(audioPlayerProvider);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/konguroo.png"),
            fit: BoxFit.cover,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 50),
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width,
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                HeadarWidget(),
                const SizedBox(height: 30),
                _buildScheduleTable(
                  context,
                  morningSchedule,
                  morningScheduleProvider,
                  'Таңкы смена',
                ),
                const Divider(height: 32),
                _buildScheduleTable(
                  context,
                  afternoonSchedule,
                  afternoonScheduleProvider,
                  'Түшкү смена',
                ),
                AppItcLogo(),
                Gap(10),
                DefaultAudio(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildScheduleTable(
    BuildContext context,
    List<List<String>> schedule,
    StateNotifierProvider<ScheduleNotifier, List<List<String>>> provider,
    String title,
  ) {
    return Consumer(
      builder: (context, ref, _) {
        return Column(
          children: [
            Text(title, style: AppTextStyle.size20bold),
            const SizedBox(height: 10),
            LayoutBuilder(
              builder: (context, constraints) {
                final screenWidth = constraints.maxWidth;
                final double columnSpacing = screenWidth > 600 ? 20 : 10;
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(8.0),
                    child: DataTable(
                      border: TableBorder.all(color: Colors.green, width: 1),
                      columnSpacing: columnSpacing,
                      headingRowHeight: 60,
                      dataRowHeight: 40,
                      columns: [
                        DataColumn(
                          label: SizedBox(
                            width: screenWidth * 0.150,
                            child: Text(
                              'Сабак',
                              style: AppTextStyle.size16bold,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        DataColumn(
                          label: SizedBox(
                            width: screenWidth * 0.100,
                            child: Text(
                              'Кирүү уб.',
                              style: AppTextStyle.size16bold,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        DataColumn(
                          label: SizedBox(
                            width: screenWidth * 0.100,
                            child: const AppIcon(
                              AppIcons.rectangle,
                              size: 20,
                              color: Colors.yellow,
                            ),
                          ),
                        ),
                        DataColumn(
                          label: SizedBox(
                            width: screenWidth * 0.100,
                            child: Text(
                              'Чыгуу уб.',
                              style: AppTextStyle.size16bold,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        DataColumn(
                          label: SizedBox(
                            width: screenWidth * 0.100,
                            child: const Center(
                              child: AppIcon(
                                AppIcons.rectangle,
                                size: 20,
                                color: Colors.yellow,
                              ),
                            ),
                          ),
                        ),
                      ],
                      rows: List.generate(schedule.length, (row) {
                        return DataRow(
                          cells: List.generate(schedule[row].length, (col) {
                            return DataCell(
                              GestureDetector(
                                onTap: () async {
                                  if (col == 1 || col == 3) {
                                    final parts = schedule[row][col].split(':');
                                    final picked = await showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay(
                                        hour: int.parse(parts[0]),
                                        minute: int.parse(parts[1]),
                                      ),
                                    );
                                    if (picked != null) {
                                      final formatted =
                                          '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
                                      ref
                                          .read(provider.notifier)
                                          .updateCell(row, col, formatted);
                                    }
                                  } else if (col == 2 || col == 4) {
                                    final result = await showDialog(
                                      context: context,
                                      builder:
                                          (_) => AudioSelectionDialog(
                                            currentAudio: schedule[row][col],
                                            onAudioSelected: (selectedPath) {
                                              ref
                                                  .read(provider.notifier)
                                                  .updateCell(
                                                    row,
                                                    col,
                                                    selectedPath,
                                                  );
                                            },
                                          ),
                                    );
                                    if (result != null &&
                                        result['path'] != null) {
                                      ref
                                          .read(provider.notifier)
                                          .updateCell(
                                            row,
                                            col,
                                            result['path']!,
                                          );
                                    }
                                  }
                                },
                                child: Center(
                                  child:
                                      (col == 2 || col == 4)
                                          ? const AppIcon(
                                            AppIcons.notes,
                                            size: 16,
                                            color: Colors.pink,
                                          )
                                          : Text(
                                            schedule[row][col].isEmpty
                                                ? '—'
                                                : schedule[row][col],
                                            style: const TextStyle(),
                                          ),
                                ),
                              ),
                            );
                          }),
                        );
                      }),
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}

// class ScheduleScreen extends ConsumerStatefulWidget {
//   const ScheduleScreen({Key? key}) : super(key: key);

//   @override
//   ConsumerState<ScheduleScreen> createState() => _ScheduleScreenState();
// }

// class _ScheduleScreenState extends ConsumerState<ScheduleScreen> {
//   TimeOfDay? scheduledTime;
//   Map<String, String>?
//   selectedAudio; // {'type': 'asset' or 'file', 'path': '...'}

//   Timer? _timer;

//   @override
//   void dispose() {
//     _timer?.cancel();
//     super.dispose();
//   }

//   void startTimer() {
//     _timer?.cancel();
//     _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       if (scheduledTime == null || selectedAudio == null) return;

//       final now = TimeOfDay.now();
//       if (now.hour == scheduledTime!.hour &&
//           now.minute == scheduledTime!.minute) {
//         _playAudio();
//         // После проигрывания останавливаем таймер, чтобы не зацикливать
//         timer.cancel();
//       }
//     });
//   }

//   Future<void> _playAudio() async {
//     final player = ref.read(audioPlayerProvider);

//     String path = selectedAudio!['path']!;

//     if (selectedAudio!['type'] == 'asset') {
//       await player.play(AssetSource(path.replaceFirst('assets/', '')));
//     } else {
//       await player.play(DeviceFileSource(path));
//     }
//   }

//   Future<void> _selectAudio() async {
//     final result = await showDialog<Map<String, String>>(
//       context: context,
//       builder: (_) => AudioSelectionDialog(),
//     );

//     if (result != null && mounted) {
//       setState(() {
//         selectedAudio = result;
//       });
//     }
//   }

//   Future<void> _pickTime() async {
//     final time = await showTimePicker(
//       context: context,
//       initialTime: scheduledTime ?? TimeOfDay.now(),
//     );
//     if (time != null && mounted) {
//       setState(() {
//         scheduledTime = time;
//       });
//       startTimer();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final player = ref.watch(audioPlayerProvider);

//     return Scaffold(
//       appBar: AppBar(title: const Text('Расписание')),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             ElevatedButton(
//               onPressed: _pickTime,
//               child: Text(
//                 scheduledTime == null
//                     ? 'Выбрать время'
//                     : 'Время: ${scheduledTime!.format(context)}',
//               ),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _selectAudio,
//               child: Text(
//                 selectedAudio == null
//                     ? 'Выбрать аудио'
//                     : 'Аудио: ${selectedAudio!['path']!.split('/').last}',
//               ),
//             ),
//             const SizedBox(height: 40),
//             ElevatedButton(
//               onPressed: () async {
//                 await _playAudio();
//               },
//               child: const Text('Воспроизвести сейчас'),
//             ),
//             ElevatedButton(
//               onPressed: () async {
//                 await player.stop();
//               },
//               child: const Text('Остановить'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
