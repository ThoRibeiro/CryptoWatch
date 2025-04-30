import 'package:hive/hive.dart';

class HiveService {
  static const String favoritesBox = 'favoritesBox';
  static const String settingsBox = 'settingsBox';

  // === Favoris ===

  static Future<void> addFavorite(String cryptoId) async {
    final box = await Hive.openBox(favoritesBox);
    await box.put(cryptoId, true);
  }

  static Future<void> removeFavorite(String cryptoId) async {
    final box = await Hive.openBox(favoritesBox);
    await box.delete(cryptoId);
  }

  static Future<bool> isFavorite(String cryptoId) async {
    final box = await Hive.openBox(favoritesBox);
    return box.get(cryptoId, defaultValue: false);
  }

  static Future<List<String>> getAllFavorites() async {
    final box = await Hive.openBox(favoritesBox);
    return box.keys.cast<String>().toList();
  }

  static Future<void> saveCurrency(String currency) async {
    final box = await Hive.openBox(settingsBox);
    await box.put('currency', currency);
  }

  static Future<String> getCurrency() async {
    final box = await Hive.openBox(settingsBox);
    return box.get('currency', defaultValue: 'usd');
  }

  static String getSymbolFromCurrency(String currency) {
    switch (currency) {
      case 'eur':
        return '€';
      case 'gbp':
        return '£';
      case 'usd':
      default:
        return '\$';
    }
  }
}
