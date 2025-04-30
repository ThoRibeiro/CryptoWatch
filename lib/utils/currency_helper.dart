String getCurrencySymbol(String code) {
  switch (code.toLowerCase()) {
    case 'usd':
      return '\$';
    case 'eur':
      return '€';
    case 'gbp':
      return '£';
    default:
      return code.toUpperCase();
  }
}