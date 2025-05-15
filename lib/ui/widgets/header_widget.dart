import 'package:flutter/material.dart';

import '../../theme/app_text_styles.dart';

class HeadarWidget extends StatelessWidget {
  const HeadarWidget({super.key});

  String _getCurrentDate() {
    final now = DateTime.now();
    return '${now.day.toString().padLeft(2, '0')}.${now.month.toString().padLeft(2, '0')}.${now.year}';
  }

  @override
  Widget build(BuildContext context) {
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
}
