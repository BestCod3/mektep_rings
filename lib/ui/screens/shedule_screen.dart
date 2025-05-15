import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/scheduler.dart';
import 'package:gap/gap.dart';
import 'package:mektep_rings/theme/app_text_styles.dart';
import 'package:mektep_rings/ui/widgets/app_icons.dart';
import 'package:mektep_rings/utils/check_bell.dart';
import '../../providers/audio_providers.dart';
import '../../utils/edit_cell.dart';
import '../../diologs/audio_selection_diolog.dart';
import '../widgets/app_itc_logo.dart';
import '../widgets/default_audio.dart';
import '../widgets/header_widget.dart';

class ScheduleScreen extends ConsumerWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final morningSchedule = ref.watch(morningScheduleProvider);
    final afternoonSchedule = ref.watch(afternoonScheduleProvider);
    final playedTimes = <String, bool>{};

    SchedulerBinding.instance.addPostFrameCallback((_) {
      Timer.periodic(const Duration(seconds: 10), (timer) {
        final now = DateTime.now();
        final lastDay = ref.read(playedTimesProvider.notifier).state['lastDay'];
        if (lastDay != null && lastDay != now.day) {
          playedTimes.clear();
          ref.read(currentPlayingProvider.notifier).state = null;
        }

        checkBell(
          morningSchedule,
          ref,
          playedTimes,
          morningScheduleProvider,
          'morning',
        );
        checkBell(
          afternoonSchedule,
          ref,
          playedTimes,
          afternoonScheduleProvider,
          'afternoon',
        );

        if (now.second == 0) {
          ref.read(playedTimesProvider.notifier).state = {'lastDay': now.day};
        }
      });
    });

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
                  ref,
                  morningSchedule,
                  morningScheduleProvider,
                  'Түшкө чейинки сабактар',
                ),
                const SizedBox(height: 20),
                _buildScheduleTable(
                  context,
                  ref,
                  afternoonSchedule,
                  afternoonScheduleProvider,
                  'Түштөн кийинки сабактар',
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
    WidgetRef ref,
    List<List<String>> schedule,
    StateNotifierProvider<ScheduleNotifier, List<List<String>>> provider,
    String title,
  ) {
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
                  columns: _buildColumnsAfter(screenWidth),
                  rows: _buildRows(context, ref, schedule, provider),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  List<DataColumn> _buildColumnsAfter(double screenWidth) {
    return [
      DataColumn(
        label: SizedBox(
          width: screenWidth * 0.150,
          child: Text(
            'Сабактардын ирети',
            style: AppTextStyle.size16bold,
            textAlign: TextAlign.center,
          ),
        ),
      ),
      DataColumn(
        label: SizedBox(
          width: screenWidth * 0.100,
          child: Text(
            'Кирүү',
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
            'Чыгуу',
            style: AppTextStyle.size16bold,
            textAlign: TextAlign.center,
          ),
        ),
      ),
      DataColumn(
        label: SizedBox(
          width: screenWidth * 0.100,
          child: const Center(
            child: AppIcon(AppIcons.rectangle, size: 20, color: Colors.yellow),
          ),
        ),
      ),
    ];
  }

  List<DataRow> _buildRows(
    BuildContext context,
    WidgetRef ref,
    List<List<String>> schedule,
    StateNotifierProvider<ScheduleNotifier, List<List<String>>> provider,
  ) {
    return List.generate(schedule.length, (rowIndex) {
      return DataRow(
        cells: List.generate(schedule[rowIndex].length, (columnIndex) {
          return DataCell(
            GestureDetector(
              onTap: () {
                if (columnIndex == 0) return;
                if (columnIndex == 2 || columnIndex == 4) {
                  showDialog(
                    context: context,
                    builder:
                        (_) => AudioSelectionDialog(
                          currentAudio: schedule[rowIndex][columnIndex],
                          onAudioSelected: (audio) {
                            ref
                                .read(provider.notifier)
                                .updateCell(rowIndex, columnIndex, audio);
                            ref.read(provider.notifier).saveSchedule();
                          },
                        ),
                  );
                } else {
                  editCell(
                    rowIndex,
                    columnIndex,
                    schedule,
                    context,
                    ref,
                    provider,
                  );
                }
              },
              child: Center(
                child:
                    columnIndex == 2 || columnIndex == 4
                        ? const AppIcon(
                          AppIcons.notes,
                          size: 16,
                          color: Colors.pink,
                        )
                        : Text(
                          schedule[rowIndex][columnIndex].isEmpty
                              ? '—'
                              : schedule[rowIndex][columnIndex],
                          style: const TextStyle(),
                        ),
              ),
            ),
          );
        }),
      );
    });
  }
}
