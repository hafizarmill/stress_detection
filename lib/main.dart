// Mengimpor pustaka utama Flutter untuk membangun antarmuka pengguna (UI).
import 'package:flutter/material.dart';

// Mengimpor halaman splash screen (halaman awal yang muncul ketika aplikasi dibuka).
import 'package:tes/pages/splash/splash.dart';

// Mengimpor pustaka Google Fonts untuk menggunakan jenis huruf dari Google (misalnya Poppins).
import 'package:google_fonts/google_fonts.dart';

// Mengimpor pustaka Provider untuk manajemen state (pengelolaan data secara global antar widget).
import 'package:provider/provider.dart';

// Mengimpor file lokal yang berisi RiwayatProvider, yaitu class yang mengatur data riwayat deteksi.
import 'package:tes/utils/riwayat_provider.dart';

// Fungsi utama (main) — titik awal eksekusi program Flutter.
// Kata kunci 'async' digunakan agar fungsi ini dapat menjalankan operasi asynchronous (tidak memblokir proses utama).
void main() async {
  // WidgetsFlutterBinding.ensureInitialized() memastikan semua binding Flutter siap digunakan,
  // terutama sebelum melakukan operasi asynchronous seperti pemanggilan file atau inisialisasi plugin.
  WidgetsFlutterBinding.ensureInitialized();

  // 🧠 Membuat instance (objek) dari RiwayatProvider untuk mengelola data riwayat aplikasi.
  final riwayatProvider = RiwayatProvider();

  // Memanggil fungsi untuk memuat riwayat yang tersimpan di file lokal perangkat.
  // 'await' menunggu proses selesai sebelum melanjutkan ke baris berikutnya.
  await riwayatProvider.muatRiwayatDariFile();

  // Menjalankan aplikasi Flutter.
  // ChangeNotifierProvider.value() digunakan untuk membungkus MyApp agar seluruh widget
  // di bawahnya dapat mengakses data dari RiwayatProvider (manajemen state global).
  runApp(
    ChangeNotifierProvider.value(
      value: riwayatProvider, // Menyediakan instance RiwayatProvider ke seluruh widget anak.
      child: const MyApp(), // Menjalankan widget utama aplikasi.
    ),
  );
}

// Kelas MyApp merupakan root (akar) dari seluruh aplikasi Flutter.
// Menggunakan StatelessWidget karena tampilan utama tidak memiliki data yang berubah secara langsung.
// Perubahan data (state) diatur oleh Provider, bukan oleh widget ini sendiri.
class MyApp extends StatelessWidget {
  // Konstruktor MyApp. Kata kunci 'const' membuat widget lebih efisien
  // karena tidak akan dibangun ulang jika tidak ada perubahan pada properti.
  const MyApp({super.key});

  @override
  // Method build digunakan untuk membangun tampilan utama aplikasi (UI hierarchy).
  // Parameter BuildContext menyediakan akses ke data seperti tema, ukuran layar, atau navigator.
  Widget build(BuildContext context) {
    // MaterialApp adalah widget dasar untuk aplikasi Flutter dengan gaya Material Design.
    return MaterialApp(
      // Menonaktifkan banner "debug" di pojok kanan atas tampilan.
      debugShowCheckedModeBanner: false,

      // Menentukan halaman awal aplikasi, yaitu SplashScreen.
      home: const SplashScreen(),

      // Menentukan tema global untuk teks di seluruh aplikasi menggunakan font Google Poppins.
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme, // Mengambil tema teks bawaan, lalu menerapkan font Poppins.
        ),
      ),
    );
  }
}
