import 'package:flutter/material.dart';
import 'package:tes/pages/splash/splash.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tes/utils/riwayat_provider.dart';

void
    main() async {
  WidgetsFlutterBinding
      .ensureInitialized();

  // 🧠 Buat instance provider dan muat riwayat dari file
  final riwayatProvider =
      RiwayatProvider();
  await riwayatProvider
      .muatRiwayatDariFile();

  runApp(
    ChangeNotifierProvider.value(
      value: riwayatProvider,
      child: const MyApp(),
    ),
  );
}

class MyApp
    extends StatelessWidget {
  const MyApp(
      {super.key});

  @override
  Widget
      build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
    );
  }
}
