import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'routes.dart';
import 'viewmodels/crypto_list_viewmodel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter(); // Initialise Hive pour Flutter
  runApp(const CryptoWatchApp());
}

class CryptoWatchApp extends StatelessWidget {
  const CryptoWatchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => CryptoListViewModel()..loadCryptos(),
        ),
      ],
      child: MaterialApp(
        title: 'CryptoWatch',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: const Color(0xFF0E0E0E),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
        ),
        initialRoute: AppRoutes.welcome,
        onGenerateRoute: AppRoutes.generateRoute,
      ),
    );
  }
}
