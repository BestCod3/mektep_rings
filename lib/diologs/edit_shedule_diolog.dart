import 'package:flutter/material.dart';
import 'package:mektep_rings/theme/app_text_styles.dart';

class EditScheduleDialog extends StatelessWidget {
  final String currentValue;
  final TextEditingController _controller;

  EditScheduleDialog({super.key, required this.currentValue})
    : _controller = TextEditingController(text: currentValue);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Убакытты өзгөртүү', style: AppTextStyle.size20boldgreen),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      elevation: 8,
      contentPadding: const EdgeInsets.all(16.0),
      content: SizedBox(
        width: 300,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Убакытты киргизиңиз (мисалы, 08:00)',
                hintText: 'XX:XX форматында жазыңыз',
                labelStyle: const TextStyle(fontSize: 16, color: Colors.red),
                hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.green, width: 2),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 12.0,
                  horizontal: 16.0,
                ),
              ),
              keyboardType: TextInputType.text,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, ''),
          style: TextButton.styleFrom(
            foregroundColor: Colors.red,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
          child: Text('Өчүрүү', style: AppTextStyle.size16W600red),
        ),
        ElevatedButton(
          onPressed: () {
            final newValue = _controller.text.trim();
            if (RegExp(r'^\d{2}:\d{2}$').hasMatch(newValue) ||
                newValue.isEmpty) {
              Navigator.pop(context, newValue);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Убакыт форматы туура эмес (мисалы, 08:00)'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          child: Text('Сактоо', style: AppTextStyle.size16W600white),
        ),
      ],
    );
  }
}
