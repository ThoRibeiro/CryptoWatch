enum CurrencyType {
  usd,
  eur,
  gbp,
}

extension CurrencyTypeExtension on CurrencyType {
  String get symbol {
    switch (this) {
      case CurrencyType.usd:
        return '\$';
      case CurrencyType.eur:
        return '€';
      case CurrencyType.gbp:
        return '£';
    }
  }

  String get code => name; // "usd", "eur", ...
}
