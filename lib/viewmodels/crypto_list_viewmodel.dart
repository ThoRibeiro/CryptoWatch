import 'package:flutter/material.dart';
import '../models/crypto_currency.dart';
import '../services/api_service.dart';
import '../services/hive_service.dart';

class CryptoListViewModel extends ChangeNotifier {
  List<CryptoCurrency> cryptos = [];
  List<String> favorites = [];
  bool isLoading = false;
  String selectedCurrency = 'eur';

  // Charge la liste des cryptomonaies et des favoris depuis les services Hive et API
  Future<void> loadCryptos() async {
    isLoading = true;
    notifyListeners();

    selectedCurrency = await HiveService.getCurrency();
    favorites = await HiveService.getAllFavorites();

    try {
      final allCryptos = await ApiService.fetchTopCryptos(selectedCurrency);

      // Trie des Favoris
      cryptos = [
        ...allCryptos.where((c) => favorites.contains(c.id)),
        ...allCryptos.where((c) => !favorites.contains(c.id)),
      ];
    } catch (e) {
      debugPrint('Erreur chargement crypto : $e');
    }

    isLoading = false;
    notifyListeners();
  }


  // Rafraîchit la liste complète des cryptos en appelant loadCryptos()
  Future<void> refreshCryptos() async {
    await loadCryptos();
  }

  // Ajoute ou supprime une crypto des favoris, puis notifie les widgets
  Future<void> toggleFavorite(String cryptoId) async {
    if (favorites.contains(cryptoId)) {
      await HiveService.removeFavorite(cryptoId);
      favorites.remove(cryptoId);
    } else {
      await HiveService.addFavorite(cryptoId);
      favorites.add(cryptoId);
    }

    // Re-trier la liste cryptos : favoris d'abord
    cryptos = [
      ...cryptos.where((c) => favorites.contains(c.id)),
      ...cryptos.where((c) => !favorites.contains(c.id)),
    ];

    notifyListeners();
  }


}
