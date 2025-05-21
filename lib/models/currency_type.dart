import 'package:project/utils/enums/currency.dart';

// Extension pour les types de monnaies
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

  String get code => name;
}
