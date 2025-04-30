import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/chart_service.dart';
import '../theme/app_colors.dart'; // Fichier à créer si pas encore fait

class CryptoChartSelector extends StatefulWidget {
  final String cryptoId;
  final String currency;

  const CryptoChartSelector({
    Key? key,
    required this.cryptoId,
    required this.currency,
  }) : super(key: key);

  @override
  State<CryptoChartSelector> createState() => _CryptoChartSelectorState();
}

class _CryptoChartSelectorState extends State<CryptoChartSelector> {
  String selectedPeriod = '1';
  List<FlSpot> spots = [];
  bool isLoading = true;

  final Map<String, String> periodLabels = {
    '1': '24h',
    '7': '7j',
    '30': '30j',
  };

  @override
  void initState() {
    super.initState();
    fetchChart();
  }

  Future<void> fetchChart() async {
    setState(() => isLoading = true);
    try {
      final data = await ChartService.fetchChartData(
        widget.cryptoId,
        widget.currency,
        selectedPeriod,
      );
      setState(() {
        spots = data.asMap().entries.map((entry) {
          final index = entry.key.toDouble();
          final price = entry.value.y;
          return FlSpot(index, price);
        }).toList();
        isLoading = false;
      });
    } catch (_) {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final interval = (spots.length / 6).floorToDouble();

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: periodLabels.entries.map((entry) {
            final isSelected = selectedPeriod == entry.key;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: ChoiceChip(
                label: Text(entry.value),
                selected: isSelected,
                onSelected: (_) {
                  setState(() => selectedPeriod = entry.key);
                  fetchChart();
                },
                selectedColor: AppColors.primary,
                backgroundColor: AppColors.card,
                labelStyle: TextStyle(
                  color: isSelected ? AppColors.textWhite : Colors.grey,
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        isLoading
            ? const CircularProgressIndicator()
            : SizedBox(
          height: 220,
          child: LineChart(
            LineChartData(
              gridData: FlGridData(show: false),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 42,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        value.toStringAsFixed(0),
                        style: const TextStyle(color: AppColors.textSecondary, fontSize: 10),
                      );
                    },
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: interval == 0 ? 1 : interval,
                    getTitlesWidget: (value, meta) {
                      return const Text('', style: TextStyle(color: AppColors.textSecondary));
                    },
                  ),
                ),
                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              borderData: FlBorderData(show: false),
              lineTouchData: LineTouchData(
                enabled: true,
                touchTooltipData: LineTouchTooltipData(
                  tooltipRoundedRadius: 12,
                  fitInsideHorizontally: true,
                  fitInsideVertically: true,
                  getTooltipItems: (touchedSpots) {
                    return touchedSpots.map((spot) {
                      final price = spot.y.toStringAsFixed(2);
                      return LineTooltipItem(
                        '$price ${widget.currency.toUpperCase()}',
                        const TextStyle(
                          color: AppColors.textWhite,
                          fontWeight: FontWeight.bold,
                          backgroundColor: AppColors.primary,
                        ),
                      );
                    }).toList();
                  },
                ),
                handleBuiltInTouches: true,
              ),
              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  isCurved: true,
                  color: AppColors.accentBlue,
                  barWidth: 2,
                  dotData: FlDotData(show: false),
                  belowBarData: BarAreaData(show: false),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
