import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppItcLogo extends StatelessWidget {
  const AppItcLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      heightFactor: 0,
      widthFactor: 14.8,
      child: Column(
        spacing: 4,
        children: [
          SizedBox(height: 30, child: Image.asset('assets/images/app_itc.png')),
          Text(
            'Турат Алыбаев',
            style: GoogleFonts.lora(fontSize: 10, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
