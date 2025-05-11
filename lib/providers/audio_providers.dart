import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScheduleNotifier extends StateNotifier<List<List<String>>> {
  final String scheduleType;

  ScheduleNotifier(this.scheduleType) : super([]) {
    _initializeSchedule();
  }

  static const initialMorningSchedule = [
    [
      '1-сабак',
      '08:00',
      'audio/first_lesson.mp3',
      '08:45',
      'audio/exit_lesson.mp3',
    ],
    [
      '2-сабак',
      '08:50',
      'audio/second_lesson.mp3',
      '09:35',
      'audio/exit_lesson.mp3',
    ],
    [
      '3-сабак',
      '09:45',
      'audio/third_lesson.mp3',
      '10:30',
      'audio/exit_lesson.mp3',
    ],
    [
      '4-сабак',
      '10:35',
      'audio/fourth_lesson.mp3',
      '11:20',
      'audio/exit_lesson.mp3',
    ],
    [
      '5-сабак',
      '11:25',
      'audio/fifth_lesson.mp3',
      '12:10',
      'audio/exit_lesson.mp3',
    ],
    [
      '6-сабак',
      '12:15',
      'audio/sixth_lesson.mp3',
      '12:58',
      'audio/exit_last_lesson.mp3',
    ],
  ];

  static const initialAfternoonSchedule = [
    [
      '1-сабак',
      '13:00',
      'audio/first_lesson.mp3',
      '13:45',
      'audio/exit_lesson.mp3',
    ],
    [
      '2-сабак',
      '13:50',
      'audio/second_lesson.mp3',
      '14:35',
      'audio/exit_lesson.mp3',
    ],
    [
      '3-сабак',
      '14:40',
      'audio/third_lesson.mp3',
      '15:25',
      'audio/exit_lesson.mp3',
    ],
    [
      '4-сабак',
      '15:35',
      'audio/fourth_lesson.mp3',
      '16:20',
      'audio/exit_lesson.mp3',
    ],
    [
      '5-сабак',
      '16:25',
      'audio/fifth_lesson.mp3',
      '17:10',
      'audio/exit_lesson.mp3',
    ],
    [
      '6-сабак',
      '17:15',
      'audio/sixth_lesson.mp3',
      '18:00',
      'audio/exit_last_lesson.mp3',
    ],
  ];

  Future<void> _initializeSchedule() async {
    final prefs = await SharedPreferences.getInstance();
    final scheduleKey = 'scheduleData_$scheduleType';
    final scheduleJson = prefs.getStringList(scheduleKey) ?? [];
    if (scheduleJson.isNotEmpty) {
      state = scheduleJson.map((row) => row.split('|')).toList();
      for (int i = 0; i < state.length; i++) {
        if (!state[i][2].startsWith('audio/')) {
          state[i][2] = 'audio/default_lesson.mp3';
        }
        if (!state[i][4].startsWith('audio/')) {
          state[i][4] = 'audio/exit_lesson.mp3';
        }
      }
    } else {
      state =
          scheduleType == 'morning'
              ? initialMorningSchedule
              : initialAfternoonSchedule;
      await saveSchedule();
    }
  }

  Future<void> saveSchedule() async {
    final prefs = await SharedPreferences.getInstance();
    final scheduleKey = 'scheduleData_$scheduleType';
    final scheduleJson = state.map((row) => row.join('|')).toList();
    await prefs.setStringList(scheduleKey, scheduleJson);
  }

  void updateCell(int rowIndex, int columnIndex, String value) {
    state = [
      for (int i = 0; i < state.length; i++)
        i == rowIndex
            ? [
              for (int j = 0; j < state[i].length; j++)
                j == columnIndex ? value : state[i][j],
            ]
            : state[i],
    ];
    saveSchedule();
  }
}

final morningScheduleProvider =
    StateNotifierProvider<ScheduleNotifier, List<List<String>>>((ref) {
      return ScheduleNotifier('morning');
    });

final afternoonScheduleProvider =
    StateNotifierProvider<ScheduleNotifier, List<List<String>>>((ref) {
      return ScheduleNotifier('afternoon');
    });

final playedTimesProvider = StateProvider<Map<String, dynamic>>((ref) => {});
final currentPlayingProvider = StateProvider<Map<String, dynamic>?>(
  (ref) => null,
);
