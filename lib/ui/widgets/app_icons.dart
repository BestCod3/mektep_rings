import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum AppIcons { logo, notes, rectangle }

class AppIcon extends StatelessWidget {
  final AppIcons icon;
  final double? size;
  final Color? color;

  const AppIcon(this.icon, {super.key, this.size = 24, this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      width: size,
      child: SvgPicture.asset(
        'assets/svg/${icon.name}.svg',
        color: color,
        height: size,
        width: size,
      ),
    );
  }
}
