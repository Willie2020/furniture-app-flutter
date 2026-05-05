import 'package:flutter/material.dart';

class CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: InputChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) => onTap(),
        selectedColor: cs.primaryContainer,
        backgroundColor: cs.surfaceContainerHighest,
        labelStyle: TextStyle(
          color: isSelected ? cs.onPrimaryContainer : cs.onSurfaceVariant,
          fontWeight: FontWeight.w600,
        ),
        side: BorderSide(
          color: isSelected ? cs.primary : Colors.transparent,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
