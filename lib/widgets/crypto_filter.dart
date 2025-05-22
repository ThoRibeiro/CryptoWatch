import 'package:flutter/material.dart';
import 'package:project/theme/app_colors.dart';
import '../utils/enums/sort_dropdown_enum.dart';
import './sort_dropdown.dart';

/// Widget de filtre pour rechercher, trier et filtrer les cryptomonnaies
class CryptoFilterWidget extends StatefulWidget {
  final String initialSearch;
  final RangeValues initialRange;
  final double minPrice;
  final double maxPrice;
  final SortOption initialSort;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<RangeValues> onRangeChanged;
  final ValueChanged<SortOption> onSortChanged;

  const CryptoFilterWidget({
    Key? key,
    this.initialSearch = '',
    required this.initialRange,
    required this.minPrice,
    required this.maxPrice,
    this.initialSort = SortOption.name,
    required this.onSearchChanged,
    required this.onRangeChanged,
    required this.onSortChanged,
  }) : super(key: key);

  @override
  State<CryptoFilterWidget> createState() => _CryptoFilterWidgetState();
}

class _CryptoFilterWidgetState extends State<CryptoFilterWidget> {
  late TextEditingController _searchController;
  late RangeValues _currentRange;
  late SortOption _currentSort;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.initialSearch);
    _currentRange = widget.initialRange;
    _currentSort = widget.initialSort;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tri
        SortDropdown(
          selectedOption: _currentSort,
          onChanged: (opt) {
            setState(() => _currentSort = opt);
            widget.onSortChanged(opt);
          },
        ),
        const SizedBox(height: 16),
        // Champ de recherche
        TextField(
          controller: _searchController,
          style: const TextStyle(color: AppColors.textWhite),
          decoration: InputDecoration(
            hintText: 'Rechercher une crypto...',
            hintStyle: TextStyle(color: AppColors.textSecondary),
            filled: true,
            fillColor: AppColors.card,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
          ),
          onChanged: widget.onSearchChanged,
        ),
        const SizedBox(height: 16),
        const Text(
          'Filtrer par prix',
          style: TextStyle(fontSize: 16, color: AppColors.textWhite),
        ),
        const SizedBox(height: 8),
        // RangeSlider pour la plage de prix
        RangeSlider(
          values: _currentRange,
          min: widget.minPrice,
          max: widget.maxPrice,
          divisions: 20,
          labels: RangeLabels(
            _currentRange.start.toStringAsFixed(2),
            _currentRange.end.toStringAsFixed(2),
          ),
          activeColor: AppColors.primary,
          inactiveColor: AppColors.textSecondary,
          onChanged: (RangeValues newRange) {
            setState(() => _currentRange = newRange);
            widget.onRangeChanged(newRange);
          },
        ),
        // Affichage des valeurs sélectionnées
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${_currentRange.start.toStringAsFixed(2)}',
              style: const TextStyle(color: AppColors.textSecondary),
            ),
            Text(
              '${_currentRange.end.toStringAsFixed(2)}',
              style: const TextStyle(color: AppColors.textSecondary),
            ),
          ],
        ),
      ],
    );
  }
}