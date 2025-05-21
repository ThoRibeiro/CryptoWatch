import 'package:flutter/material.dart';
import '../services/hive_service.dart';
import 'package:provider/provider.dart';
import '../viewmodels/crypto_list_viewmodel.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  String _selectedCurrency = 'eur';

  @override
  void initState() {
    super.initState();
    HiveService.getCurrency().then((value) {
      setState(() {
        _selectedCurrency = value;
      });
    });
  }

  void _updateCurrency(String? newCurrency) async {
    if (newCurrency != null) {
      await HiveService.saveCurrency(newCurrency);
      setState(() {
        _selectedCurrency = newCurrency;
      });

      if (context.mounted) {
        context.read<CryptoListViewModel>().loadCryptos();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E0E0E),
      appBar: AppBar(
        title: const Text('Paramètres'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Choisir la devise',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedCurrency,
              dropdownColor: const Color(0xFF1A1A1A),
              items: const [
                DropdownMenuItem(value: 'eur', child: Text('EUR (€)', style: TextStyle(color: Colors.white))),
                DropdownMenuItem(value: 'usd', child: Text('USD (\$)', style: TextStyle(color: Colors.white))),
                DropdownMenuItem(value: 'gbp', child: Text('GBP (£)', style: TextStyle(color: Colors.white))),
              ],
              onChanged: _updateCurrency,
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFF1A1A1A),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
