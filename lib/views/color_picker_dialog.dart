import 'package:flutter/material.dart';

class ColorPickerDialog extends StatelessWidget {
  final Color currentColor;
  final ValueChanged<Color> onColorSelected;

  const ColorPickerDialog({
    super.key,
    required this.currentColor,
    required this.onColorSelected,
  });

  static const List<Map<String, dynamic>> availableColors = [
    {'name': 'Xanh dương', 'color': Color(0xFF1976D2)},
    {'name': 'Xanh lá', 'color': Color(0xFF388E3C)},
    {'name': 'Tím', 'color': Color(0xFF7B1FA2)},
    {'name': 'Xám đậm', 'color': Color(0xFF374151)},
    {'name': 'Đỏ', 'color': Color(0xFFD32F2F)},
    {'name': 'Cam', 'color': Color(0xFFE65100)},
    {'name': 'Xanh ngọc', 'color': Color(0xFF00796B)},
    {'name': 'Chàm', 'color': Color(0xFF303F9F)},
  ];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
      title: const Text(
        'Chọn màu thanh ứng dụng',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color(0xFF111827),
        ),
      ),
      content: SizedBox(
        width: 280,
        child: Wrap(
          spacing: 16,
          runSpacing: 16,
          alignment: WrapAlignment.center,
          children: availableColors.map((colorItem) {
            final color = colorItem['color'] as Color;
            final isSelected = currentColor.toARGB32() == color.toARGB32();

            return GestureDetector(
              onTap: () {
                onColorSelected(color);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? Colors.white : Colors.transparent,
                    width: 2.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: color.withValues(alpha: isSelected ? 0.45 : 0.25),
                      blurRadius: isSelected ? 8 : 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: isSelected
                    ? const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 26,
                      )
                    : null,
              ),
            );
          }).toList(),
        ),
      ),
      actionsPadding: const EdgeInsets.only(right: 16, bottom: 12),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          style: TextButton.styleFrom(
            foregroundColor: const Color(0xFF374151),
            textStyle: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          child: const Text('Đóng'),
        ),
      ],
    );
  }
}
