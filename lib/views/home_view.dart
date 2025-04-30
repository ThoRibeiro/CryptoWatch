import 'package:flutter/material.dart';
import 'package:project/routes.dart';
import 'package:provider/provider.dart';
import '../viewmodels/crypto_list_viewmodel.dart';
import '../widgets/crypto_card.dart';
import '../widgets/custom_app_bar.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<CryptoListViewModel>(context);

    return Scaffold(
      backgroundColor: const Color(0xFF0E0E0E),
      appBar: CustomAppBar(
        title: 'CryptoWatch',
        onSettingsTap: () {
          Navigator.pushNamed(context, AppRoutes.settings);
        },
      ),
      body: viewModel.isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: viewModel.refreshCryptos,
        child: ListView.builder(
          itemCount: viewModel.cryptos.length,
          itemBuilder: (context, index) {
            final crypto = viewModel.cryptos[index];
            final isFav = viewModel.favorites.contains(crypto.id);

            return CryptoCard(
              crypto: crypto,
              isFavorite: isFav,
              currencyCode: viewModel.selectedCurrency,
              onTap: () {
                Navigator.pushNamed(
                  context,
                  AppRoutes.detail,
                  arguments: crypto.id,
                );
              },
              onFavoriteToggle: () {
                viewModel.toggleFavorite(crypto.id);
              },
            );
          },
        ),
      ),
    );
  }
}
