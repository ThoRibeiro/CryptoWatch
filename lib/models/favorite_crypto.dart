class FavoriteCrypto {
  final String id;
  final String name;
  final String symbol;

  FavoriteCrypto({
    required this.id,
    required this.name,
    required this.symbol,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'symbol': symbol,
  };

  factory FavoriteCrypto.fromJson(Map<String, dynamic> json) => FavoriteCrypto(
    id: json['id'],
    name: json['name'],
    symbol: json['symbol'],
  );
}
