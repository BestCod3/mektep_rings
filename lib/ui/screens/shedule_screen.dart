import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mektep_rings/theme/app_text_styles.dart';
import 'package:mektep_rings/ui/widgets/app_icons.dart';
import 'package:mektep_rings/utils/check_bell.dart';
import '../../providers/audio_providers.dart';
import '../../utils/edit_cell.dart';
import '../../diologs/audio_selection_diolog.dart';

class ScheduleScreen extends ConsumerWidget {
  const ScheduleScreen({super.key});

  String _getCurrentDate() {
    final now = DateTime.now();
    return '${now.day.toString().padLeft(2, '0')}.${now.month.toString().padLeft(2, '0')}.${now.year}';
  }

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
                _buildHeader(context),
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
                Align(
                  alignment: Alignment.bottomRight,
                  heightFactor: 0,
                  widthFactor: 16,
                  child: Column(
                    spacing: 4,
                    children: [
                      SizedBox(
                        height: 30,
                        child: Image.asset('assets/images/app_itc.png'),
                      ),
                      Text(
                        'Турат Алыбаев',
                        style: GoogleFonts.lora(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      spacing: 10,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset('assets/images/logo.png', height: 50),
        const SizedBox(width: 10),
        Text('АКЫЛДУУ КОҢГУРОО', style: AppTextStyle.size40),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'А. Сулайманов атындагы орто мектеби',
              style: AppTextStyle.size16W600,
            ),
            Text(_getCurrentDate(), style: AppTextStyle.size16W600),
          ],
        ),
      ],
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
                  headingRowHeight: 70,
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
    final providerType =
        provider == morningScheduleProvider ? 'morning' : 'afternoon';
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
                        ? Consumer(
                          builder: (context, ref, _) {
                            final currentPlaying = ref.watch(
                              currentPlayingProvider,
                            );
                            final isCurrentCellPlaying =
                                currentPlaying != null &&
                                currentPlaying['row'] == rowIndex &&
                                currentPlaying['col'] == columnIndex &&
                                currentPlaying['type'] == providerType;

                            return isCurrentCellPlaying
                                ? const AppIcon(
                                  AppIcons.rectangle,
                                  size: 16,
                                  color: Colors.yellow,
                                )
                                : const AppIcon(
                                  AppIcons.notes,
                                  size: 16,
                                  color: Colors.pink,
                                );
                          },
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
