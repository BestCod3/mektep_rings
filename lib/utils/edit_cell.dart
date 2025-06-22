import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'
    show StateNotifierProvider, StateProvider, WidgetRef;
import 'package:mektep_rings/providers/audio_providers.dart';
import '../diologs/edit_shedule_diolog.dart';
import '../ui/widgets/calculate_exit_time.dart';

// Предполагается, что ты объявил где-то
final lastDayProvider = StateProvider<int?>((ref) => null);

Future<void> editCell(
  int rowIndex,
  int columnIndex,
  List<List<String>> schedule,
  BuildContext context,
  WidgetRef ref,
  StateNotifierProvider<ScheduleNotifier, List<List<String>>> provider,
) async {
  final currentValue = schedule[rowIndex][columnIndex];
  final result = await showDialog<String>(
    context: context,
    builder: (_) => EditScheduleDialog(currentValue: currentValue),
  );

  if (result != null) {
    ref.read(provider.notifier).updateCell(rowIndex, columnIndex, result);
    if (columnIndex == 1 && result.isNotEmpty) {
      final exitTime = calculateExitTime(result);
      ref.read(provider.notifier).updateCell(rowIndex, 3, exitTime);
    }
    await ref.read(provider.notifier).saveSchedule();
    // Вместо обновления playedTimesProvider - обновляем lastDayProvider
    ref.read(lastDayProvider.notifier).state = DateTime.now().day;
  }
}
