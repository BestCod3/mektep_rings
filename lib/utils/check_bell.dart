import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mektep_rings/utils/bell_player.dart';
import '../providers/audio_providers.dart';

Future<void> checkBell(
  List<List<String>> schedule,
  WidgetRef ref,
  Map<String, bool> playedTimes,
  StateNotifierProvider<ScheduleNotifier, List<List<String>>> provider,
  String providerType,
) async {
  final now = DateTime.now();
  final currentTime =
      '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

  final lastDay = ref.read(playedTimesProvider.notifier).state['lastDay'];
  if (lastDay != null && lastDay != now.day) {
    print('Күн өзгөрдү: $lastDay -> ${now.day}, playedTimes тазаланууда');
    ref.read(playedTimesProvider.notifier).state = {'lastDay': now.day};
    playedTimes.clear();
  } else if (lastDay == null) {
    print('lastDay орнотулууда: ${now.day}');
    ref.read(playedTimesProvider.notifier).state['lastDay'] = now.day;
  }

  for (
    int rowIndex = 0;
    rowIndex < schedule.length && rowIndex < 7;
    rowIndex++
  ) {
    final entryTime = schedule[rowIndex][1];
    final exitTime = schedule[rowIndex][3];
    final lessonNumber = rowIndex + 1;
    String entryAudio = schedule[rowIndex][2];
    String exitAudio = schedule[rowIndex][4];

    if (!entryAudio.startsWith('audio/')) {
      print(
        'Эскертүү: Кирүү аудиосу туура эмес: $entryAudio (Сабак $lessonNumber)',
      );
    }
    if (!exitAudio.startsWith('audio/')) {
      print(
        'Эскертүү: Чыгуу аудиосу туура эмес: $exitAudio (Сабак $lessonNumber)',
      );
    }

    final entryKey =
        '${providerType}_entry_${lessonNumber}_${entryTime}_${now.day}';
    final exitKey =
        '${providerType}_exit_${lessonNumber}_${exitTime}_${now.day}';

    if (entryTime == currentTime && !(playedTimes[entryKey] ?? false)) {
      playedTimes[entryKey] = true;
      print(
        'Аудио башталды: $entryAudio, убакыт: $entryTime, ачкыч: $entryKey',
      );
      await BellPlayer.playBell(
        entryAudio,
        entryKey,
        rowIndex,
        2,
        () {
          final startTime = DateTime.now();
          print(
            'Кирүү аудиосу башталды: row $rowIndex, col 2, type $providerType, убакыт: $startTime',
          );
        },
        () {
          final endTime = DateTime.now();
          print(
            'Кирүү аудиосу аяктады: row $rowIndex, col 2, type $providerType, убакыт: $endTime',
          );
        },
        (int columnIndex, dynamic value) {},
      );
    }

    if (exitTime == currentTime && !(playedTimes[exitKey] ?? false)) {
      playedTimes[exitKey] = true;
      print('Аудио башталды: $exitAudio, убакыт: $exitTime, ачкыч: $exitKey');
      await BellPlayer.playBell(
        exitAudio,
        exitKey,
        rowIndex,
        4,
        () {
          final startTime = DateTime.now();
          print(
            'Чыгуу аудиосу башталды: row $rowIndex, col 4, type $providerType, убакыт: $startTime',
          );
        },
        () {
          final endTime = DateTime.now();
          print(
            'Чыгуу аудиосу аяктады: row $rowIndex, col 4, type $providerType, убакыт: $endTime',
          );
        },
        (int columnIndex, dynamic value) {},
      );
    }
  }
}
