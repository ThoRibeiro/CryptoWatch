import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/crypto_detail.dart';
import '../services/api_service.dart';
import '../widgets/crypto_chart_selector.dart';
import '../services/chart_service.dart';
import '../services/hive_service.dart';

class CryptoDetailView extends StatefulWidget {
  final String cryptoId;

  const CryptoDetailView({Key? key, required this.cryptoId}) : super(key: key);

  @override
  State<CryptoDetailView> createState() => _CryptoDetailViewState();
}

class _CryptoDetailViewState extends State<CryptoDetailView> {
  Future<CryptoDetail>? _cryptoDetailFuture;
  double? price24hAgo;
  double? currentPrice;
  String selectedCurrency = 'usd';

  @override
  void initState() {
    super.initState();
    initData();
  }

  Future<void> initData() async {
    final currency = await HiveService.getCurrency();

    setState(() {
      selectedCurrency = currency;
      _cryptoDetailFuture = ApiService.fetchCryptoDetail(widget.cryptoId, selectedCurrency);
    });

    await fetchPriceData();
  }

  Future<void> fetchPriceData() async {
    try {
      final spots = await ChartService.fetchChartData(widget.cryptoId, selectedCurrency, '1');
      if (spots.length >= 2) {
        setState(() {
          price24hAgo = spots.first.y;
          currentPrice = spots.last.y;
        });
      } else {
        debugPrint('Pas assez de données pour le calcul de la variation.');
      }
    } catch (e) {
      debugPrint('Erreur prix 24h : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final symbol = HiveService.getSymbolFromCurrency(selectedCurrency);

    if (_cryptoDetailFuture == null) {
      return const Scaffold(
        backgroundColor: Color(0xFF0E0E0E),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0E0E0E),
      appBar: AppBar(
        title: const Text('Détail crypto'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: FutureBuilder<CryptoDetail>(
        future: _cryptoDetailFuture!,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.hasError) {
            return const Center(
              child: Text(
                'Erreur lors du chargement',
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          final crypto = snapshot.data!;
          final variation = (currentPrice != null && price24hAgo != null)
              ? ((currentPrice! - price24hAgo!) / price24hAgo! * 100)
              : null;

          final variationColor = (variation != null && variation >= 0)
              ? Colors.greenAccent
              : Colors.redAccent;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    crypto.name,
                    style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 16),

                if (price24hAgo != null && currentPrice != null)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A1A),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Prix actuel : \$ $symbol${currentPrice!.toStringAsFixed(2)}',
                            style: const TextStyle(color: Colors.white, fontSize: 16)),
                        const SizedBox(height: 8),
                        Text('Prix il y a 24h : \$ $symbol${price24hAgo!.toStringAsFixed(2)}',
                            style: const TextStyle(color: Colors.white54, fontSize: 14)),
                        const SizedBox(height: 8),
                        if (variation != null)
                          Text(
                            'Variation 24h : ${variation.toStringAsFixed(2)}%',
                            style: TextStyle(color: variationColor, fontSize: 16),
                          ),
                      ],
                    ),
                  ),

                CryptoChartSelector(
                  cryptoId: widget.cryptoId,
                  currency: selectedCurrency,
                ),

                const SizedBox(height: 30),

                Text(
                  crypto.description.isNotEmpty
                      ? crypto.description
                      : 'Aucune description disponible.',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 30),

                ElevatedButton.icon(
                  onPressed: () async {
                    final Uri url = Uri.parse(crypto.homepageUrl);
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url, mode: LaunchMode.externalApplication);
                    }
                  },
                  icon: const Icon(Icons.open_in_browser),
                  label: const Text('Voir le site officiel'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}