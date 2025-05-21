import 'package:flutter/material.dart';
import '../models/crypto_currency.dart';
import '../utils/currency_helper.dart';
import '../theme/app_colors.dart';

class CryptoCard extends StatelessWidget {
  final CryptoCurrency crypto;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onFavoriteToggle;
  final String currencyCode;

  const CryptoCard({
    Key? key,
    required this.crypto,
    required this.isFavorite,
    required this.onTap,
    required this.onFavoriteToggle,
    required this.currencyCode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final priceColor = crypto.priceChangePercentage24h >= 0
        ? AppColors.accentGreen
        : AppColors.accentRed;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(crypto.image),
                  backgroundColor: Colors.transparent,
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${crypto.symbol.toUpperCase()}/EUR',
                      style: const TextStyle(
                        color: AppColors.textWhite,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      crypto.name,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${getCurrencySymbol(currencyCode)} ${crypto.currentPrice.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: priceColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    isFavorite ? Icons.star : Icons.star_border,
                    color: isFavorite ? Colors.amber : Colors.grey,
                  ),
                  onPressed: onFavoriteToggle,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
