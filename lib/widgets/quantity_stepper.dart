import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Compact minus / value / plus stepper used in the cart and product page.
class QuantityStepper extends StatelessWidget {
  const QuantityStepper({
    super.key,
    required this.value,
    required this.onChanged,
    this.compact = false,
  });

  final int value;
  final ValueChanged<int> onChanged;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final size = compact ? 30.0 : 34.0;
    final iconSize = compact ? 16.0 : 18.0;
    Widget button(IconData icon, VoidCallback onTap) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          width: size,
          height: size,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.accent,
            borderRadius: BorderRadius.circular(size / 2),
          ),
          child: Icon(icon, size: iconSize, color: Colors.white),
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        button(Icons.remove_rounded, () => onChanged(value - 1)),
        SizedBox(
          width: compact ? 34 : 40,
          child: Center(
            child: Text(
              '$value',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.ink,
              ),
            ),
          ),
        ),
        button(Icons.add_rounded, () => onChanged(value + 1)),
      ],
    );
  }
}