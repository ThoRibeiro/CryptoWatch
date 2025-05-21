// Model de donnée dans Hive
class CryptoCurrency {
  final String id;
  final String name;
  final String symbol;
  final String image;
  final double currentPrice;
  final double priceChangePercentage24h;
  final List<double> sparklineIn7d;

  CryptoCurrency({
    required this.id,
    required this.name,
    required this.symbol,
    required this.image,
    required this.currentPrice,
    required this.priceChangePercentage24h,
    required this.sparklineIn7d,
  });

  factory CryptoCurrency.fromJson(Map<String, dynamic> json) {
    return CryptoCurrency(
      id: json['id'],
      name: json['name'],
      symbol: json['symbol'],
      image: json['image'],
      currentPrice: (json['current_price'] as num).toDouble(),
      priceChangePercentage24h:
      (json['price_change_percentage_24h'] as num?)?.toDouble() ?? 0.0,
      sparklineIn7d: List<double>.from(
        (json['sparkline_in_7d']?['price'] ?? []).map((x) => (x as num).toDouble()),
      ),
    );
  }
}
