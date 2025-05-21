import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fl_chart/fl_chart.dart';

// Call HTTP Pour le service Chart de l'api "coingecko"
class ChartService {
  static const String _baseUrl = 'https://api.coingecko.com/api/v3';
  static Future<List<FlSpot>> fetchChartData(String cryptoId, String vsCurrency, String days) async {
    final url = Uri.parse(
      '$_baseUrl/coins/$cryptoId/market_chart?vs_currency=$vsCurrency&days=$days&interval=${days == '1' ? 'hourly' : 'daily'}',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> prices = data['prices'];

      return prices.map((point) {
        final timestamp = (point[0] / 1000).toDouble();
        final price = (point[1] as num).toDouble();
        return FlSpot(timestamp, price);
      }).toList();
    } else {
      throw Exception('Erreur lors du chargement des données du graphique');
    }
  }
}