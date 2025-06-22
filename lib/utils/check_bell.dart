import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mektep_rings/utils/bell_player.dart';
import '../providers/audio_providers.dart';

Future<void> checkBell(
  List<List<String>> schedule,
  WidgetRef ref,
  Map<String, dynamic> playedTimes,
  String providerType,
) async {
  final now = DateTime.now();
  final currentTime =
      '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

  final playedTimesNotifier = ref.read(playedTimesProvider.notifier);

  final lastDay = playedTimesNotifier.state['lastDay'];
  if (lastDay != null && lastDay != now.day) {
    print('Күн өзгөрдү: $lastDay -> ${now.day}, playedTimes тазаланууда');
    playedTimesNotifier.state = {'lastDay': now.day};
    playedTimes.clear();
  } else if (lastDay == null) {
    print('lastDay орнотулууда: ${now.day}');
    playedTimesNotifier.state['lastDay'] = now.day;
  }

  for (
    int rowIndex = 0;
    rowIndex < schedule.length && rowIndex < 7;
    rowIndex++
  ) {
    final entryTime = schedule[rowIndex][1];
    final exitTime = schedule[rowIndex][3];
    final entryAudio = schedule[rowIndex][2];
    final exitAudio = schedule[rowIndex][4];
    final lessonNumber = rowIndex + 1;

    final entryKey =
        '${providerType}_entry_${lessonNumber}_${entryTime}_${now.day}';
    final exitKey =
        '${providerType}_exit_${lessonNumber}_${exitTime}_${now.day}';

    if (entryTime == currentTime && !(playedTimes[entryKey] ?? false)) {
      playedTimes[entryKey] = true;
      print(
        '🔔 Кирүү: сабак $lessonNumber, убакыт: $entryTime, аудио: $entryAudio',
      );

      await BellPlayer.playBell(
        entryAudio,
        entryKey,
        rowIndex,
        2,
        () => print('▶️ Кирүү башталды: $entryKey'),
        () => print('⏹ Кирүү аяктады: $entryKey'),
        (col, err) => print('❌ Кирүү ката [$col]: $err'),
      );
    }

    if (exitTime == currentTime && !(playedTimes[exitKey] ?? false)) {
      playedTimes[exitKey] = true;
      print(
        '🔔 Чыгуу: сабак $lessonNumber, убакыт: $exitTime, аудио: $exitAudio',
      );

      await BellPlayer.playBell(
        exitAudio,
        exitKey,
        rowIndex,
        4,
        () => print('▶️ Чыгуу башталды: $exitKey'),
        () => print('⏹ Чыгуу аяктады: $exitKey'),
        (col, err) => print('❌ Чыгуу ката [$col]: $err'),
      );
    }
  }
}
