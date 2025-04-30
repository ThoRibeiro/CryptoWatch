import 'package:flutter/material.dart';
import 'package:project/theme/app_colors.dart';
import '../utils/enums/sort_dropdown_enum.dart';

class SortDropdown extends StatelessWidget {
  final SortOption selectedOption;
  final ValueChanged<SortOption> onChanged;

  const SortDropdown({
    Key? key,
    required this.selectedOption,
    required this.onChanged,
  }) : super(key: key);

  String _getLabel(SortOption option) {
    switch (option) {
      case SortOption.name:
        return 'Nom';
      case SortOption.price:
        return 'Prix';
      case SortOption.variation:
        return 'Variation';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white30),
      ),
      child: DropdownButton<SortOption>(
        value: selectedOption,
        dropdownColor: AppColors.card,
        iconEnabledColor: Colors.white,
        underline: const SizedBox(),
        onChanged: (value) {
          if (value != null) onChanged(value);
        },
        items: SortOption.values.map((option) {
          return DropdownMenuItem(
            value: option,
            child: Text(_getLabel(option), style: const TextStyle(color: Colors.white)),
          );
        }).toList(),
      ),
    );
  }
}
