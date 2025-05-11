import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mektep_rings/ui/widgets/app_icons.dart';
import '../providers/audio_providers.dart';
import 'bell_player.dart';

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
    ref.read(playedTimesProvider.notifier).state = {'lastDay': now.day};
    ref.read(currentPlayingProvider.notifier).state = null;
    playedTimes.clear();
  } else if (lastDay == null) {
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

    if (!entryAudio.startsWith('audio/')) {}
    if (!exitAudio.startsWith('audio/')) {}

    void updateIcon(int columnIndex, dynamic value) {
      if (ref.read(provider).isNotEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final currentPlaying = ref.read(currentPlayingProvider);
          if (value == AppIcons.notes) {
            ref.read(currentPlayingProvider.notifier).state = {
              'row': rowIndex,
              'col': columnIndex,
              'type': providerType,
            };
          } else if (value == AppIcons.rectangle) {
            if (currentPlaying == null ||
                (currentPlaying['row'] != rowIndex ||
                    currentPlaying['col'] != columnIndex ||
                    currentPlaying['type'] != providerType)) {
              ref.read(currentPlayingProvider.notifier).state = null;
            }
          }
        });
      }
    }

    final entryKey =
        '${providerType}_entry_${lessonNumber}_${entryTime}_${now.day}';
    final exitKey =
        '${providerType}_exit_${lessonNumber}_${exitTime}_${now.day}';

    if (entryTime == currentTime && !(playedTimes[entryKey] ?? false)) {
      playedTimes[entryKey] = true;

      await BellPlayer.playBell(
        entryAudio,
        entryKey,
        () {
          updateIcon(2, AppIcons.notes);
        },
        () {
          updateIcon(2, AppIcons.rectangle);
        },
        updateIcon,
      );
    } else if (entryTime == currentTime) {
      final currentPlaying = ref.read(currentPlayingProvider);
      if (currentPlaying != null &&
          currentPlaying['row'] == rowIndex &&
          currentPlaying['col'] == 2 &&
          currentPlaying['type'] == providerType) {
        updateIcon(2, AppIcons.notes);
      } else {
        updateIcon(2, AppIcons.rectangle);
      }
    }

    if (exitTime == currentTime && !(playedTimes[exitKey] ?? false)) {
      playedTimes[exitKey] = true;
      await BellPlayer.playBell(
        exitAudio,
        exitKey,
        () {
          updateIcon(4, AppIcons.notes);
        },
        () {
          updateIcon(4, AppIcons.rectangle);
        },
        updateIcon,
      );
    } else if (exitTime == currentTime) {
      final currentPlaying = ref.read(currentPlayingProvider);
      if (currentPlaying != null &&
          currentPlaying['row'] == rowIndex &&
          currentPlaying['col'] == 4 &&
          currentPlaying['type'] == providerType) {
        updateIcon(4, AppIcons.notes);
      } else {
        updateIcon(4, AppIcons.rectangle);
      }
    }
  }
}
