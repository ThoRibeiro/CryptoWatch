import 'package:flutter/material.dart';
import '../models/crypto_currency.dart';
import '../services/api_service.dart';
import '../services/hive_service.dart';
import '../utils/enums/sort_dropdown_enum.dart';

class CryptoListViewModel extends ChangeNotifier {
  // Tous les cryptos bruts
  List<CryptoCurrency> _allCryptos = [];
  // Liste affichée après filtres et tri
  List<CryptoCurrency> cryptos = [];
  // Favoris (IDs)
  List<String> favorites = [];
  bool isLoading = false;
  String selectedCurrency = 'usd';

  // États pour recherche, filtre et tri
  String searchQuery = '';
  double minPrice = 0;
  double maxPrice = double.infinity;
  SortOption currentSort = SortOption.name;

  /// Charge les cryptos, initialise la plage de prix et applique filtres/tri
  Future<void> loadCryptos() async {
    isLoading = true;
    notifyListeners();

    selectedCurrency = await HiveService.getCurrency();
    favorites = await HiveService.getAllFavorites();

    try {
      _allCryptos = await ApiService.fetchTopCryptos(selectedCurrency);
      if (_allCryptos.isNotEmpty) {
        final prices = _allCryptos.map((c) => c.currentPrice);
        minPrice = prices.reduce((a, b) => a < b ? a : b);
        maxPrice = prices.reduce((a, b) => a > b ? a : b);
      }
      _applyFiltersAndSort();
    } catch (e) {
      debugPrint('Erreur chargement crypto : $e');
    }

    isLoading = false;
    notifyListeners();
  }

  /// Rafraîchit la liste des cryptos
  Future<void> refreshCryptos() async {
    await loadCryptos();
  }

  /// Ajoute ou retire une crypto des favoris, puis réapplique le tri
  Future<void> toggleFavorite(String cryptoId) async {
    if (favorites.contains(cryptoId)) {
      await HiveService.removeFavorite(cryptoId);
      favorites.remove(cryptoId);
    } else {
      await HiveService.addFavorite(cryptoId);
      favorites.add(cryptoId);
    }
    _applyFiltersAndSort();
    notifyListeners();
  }

  /// Met à jour la requête de recherche et réapplique filtres/tri
  void updateSearchQuery(String query) {
    searchQuery = query;
    _applyFiltersAndSort();
    notifyListeners();
  }

  /// Met à jour la plage de prix et réapplique filtres/tri
  void updatePriceRange(double min, double max) {
    minPrice = min;
    maxPrice = max;
    _applyFiltersAndSort();
    notifyListeners();
  }

  /// Met à jour l'option de tri et réapplique filtres/tri
  void updateSortOption(SortOption option) {
    currentSort = option;
    _applyFiltersAndSort();
    notifyListeners();
  }

  // Applique les filtres et le tri aux données brutes
  void _applyFiltersAndSort() {
    var list = _allCryptos;
    // Recherche par nom
    if (searchQuery.isNotEmpty) {
      list = list.where((c) => c.name.toLowerCase().contains(searchQuery.toLowerCase())).toList();
    }
    // Filtre par prix
    list = list.where((c) => c.currentPrice >= minPrice && c.currentPrice <= maxPrice).toList();
    // Tri selon l'option
    switch (currentSort) {
      case SortOption.name:
        list.sort((a, b) => a.name.compareTo(b.name));
        break;
      case SortOption.price:
        list.sort((a, b) => b.currentPrice.compareTo(a.currentPrice));
        break;
      case SortOption.variation:
        list.sort((a, b) => b.priceChangePercentage24h.compareTo(a.priceChangePercentage24h));
        break;
    }
    // Favoris en tête
    cryptos = [
      ...list.where((c) => favorites.contains(c.id)),
      ...list.where((c) => !favorites.contains(c.id)),
    ];
  }
}
