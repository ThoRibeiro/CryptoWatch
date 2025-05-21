import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/crypto_currency.dart';
import '../models/crypto_detail.dart';

// Call HTTP pour l'api "coingecko"
class ApiService {
  static const String _baseUrl = 'https://api.coingecko.com/api/v3';

  static Future<List<CryptoCurrency>> fetchTopCryptos(String vsCurrency) async {
    final response = await http.get(Uri.parse(
      '$_baseUrl/coins/markets?vs_currency=$vsCurrency&order=market_cap_desc&per_page=20&page=1&sparkline=true',
    ));

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((e) => CryptoCurrency.fromJson(e)).toList();
    } else {
      throw Exception('Erreur de chargement des cryptos');
    }
  }

  static Future<CryptoDetail> fetchCryptoDetail(String id, String vsCurrency) async {
    final response = await http.get(Uri.parse(
      '$_baseUrl/coins/$id?localization=false&tickers=false&market_data=true&sparkline=false&vs_currency=$vsCurrency',
    ));
    if (response.statusCode == 200) {
      return CryptoDetail.fromJson(json.decode(response.body));
    } else {
      throw Exception('Erreur de chargement du détail');
    }
  }

}
