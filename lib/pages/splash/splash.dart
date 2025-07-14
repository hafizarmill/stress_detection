import 'package:flutter/material.dart';
import 'package:tes/pages/beranda/beranda.dart'; // ganti sesuai lokasi beranda kamu

class SplashScreen
    extends StatefulWidget {
  const SplashScreen(
      {super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() =>
      _SplashScreenState();
}

class _SplashScreenState
    extends State<SplashScreen> {
  @override
  void
      initState() {
    super.initState();

    // Timer splash 3 detik, lalu navigasi ke beranda
    Future.delayed(const Duration(seconds: 3),
        () {
      Navigator.pushReplacement(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(builder: (context) => Beranda()),
      );
    });
  }

  @override
  Widget
      build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1D9B6C), // Hijau sama dengan beranda
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo di tengah
            Image.asset(
              'assets/gambar/logo-1.png', // Ganti sesuai path logo kamu
              height: 200,
            ),
            const SizedBox(height: 20),
            // Teks di bawah logo
            const Text(
              'S-Check',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
