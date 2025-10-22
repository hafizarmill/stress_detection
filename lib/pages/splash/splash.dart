// Mengimpor pustaka utama Flutter untuk membangun tampilan antarmuka pengguna (UI).
import 'package:flutter/material.dart';

// Mengimpor halaman Beranda yang akan dituju setelah splash selesai ditampilkan.
// Pastikan path-nya sudah sesuai dengan struktur proyek kamu.
import 'package:tes/pages/beranda/beranda.dart';

// Kelas SplashScreen menggunakan StatefulWidget.
// StatefulWidget berarti widget ini memiliki "state" (keadaan) yang bisa berubah,
// misalnya ketika timer selesai dan halaman berpindah.
class SplashScreen extends StatefulWidget {
  // Konstruktor const membuat widget lebih efisien,
  // karena tidak akan dibangun ulang jika tidak ada perubahan.
  const SplashScreen({super.key});

  @override
  // Method createState digunakan untuk membuat objek state (_SplashScreenState),
  // yang menyimpan logika dan data dari widget ini.
  // ignore: library_private_types_in_public_api digunakan agar tidak muncul peringatan lint terkait penamaan kelas privat.
  _SplashScreenState createState() => _SplashScreenState();
}

// Kelas _SplashScreenState menyimpan logika tampilan dan perilaku dari SplashScreen.
// Tanda garis bawah (_) menunjukkan bahwa kelas ini bersifat privat (hanya digunakan di file ini).
class _SplashScreenState extends State<SplashScreen> {
  @override
  // Method initState dijalankan pertama kali saat widget dibuat.
  // Biasanya digunakan untuk inisialisasi data, timer, atau navigasi otomatis seperti pada splash screen.
  void initState() {
    super.initState();

    // Membuat delay selama 3 detik menggunakan Future.delayed.
    // Setelah 3 detik, pengguna akan diarahkan ke halaman Beranda.
    Future.delayed(const Duration(seconds: 3), () {
      // Navigator.pushReplacement digunakan untuk berpindah halaman dan
      // menggantikan halaman saat ini (SplashScreen) dengan halaman baru (Beranda),
      // sehingga pengguna tidak bisa kembali ke splash dengan tombol back.
      Navigator.pushReplacement(
        // ignore: use_build_context_synchronously digunakan untuk mengabaikan peringatan lint
        // karena context digunakan setelah delay (setelah frame build selesai).
        context,
        MaterialPageRoute(builder: (context) => Beranda()),
      );
    });
  }

  @override
  // Method build digunakan untuk membangun tampilan antarmuka dari splash screen.
  Widget build(BuildContext context) {
    // Scaffold memberikan struktur dasar halaman (background, body, dsb).
    return Scaffold(
      // Warna latar belakang splash screen menggunakan warna hijau yang sama seperti halaman beranda.
      backgroundColor: const Color(0xFF1D9B6C),

      // Body berisi konten utama halaman, diatur di tengah layar menggunakan Center.
      body: Center(
        // Column digunakan untuk menampilkan elemen secara vertikal (atas ke bawah).
        child: Column(
          // mainAxisAlignment.center untuk menempatkan semua elemen di tengah secara vertikal.
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Menampilkan logo aplikasi di tengah layar.
            Image.asset(
              'assets/gambar/logo-1.png', // Ganti sesuai path logo yang digunakan dalam proyek.
              height: 200, // Ukuran tinggi logo.
            ),

            // Memberikan jarak vertikal 20 piksel antara logo dan teks.
            const SizedBox(height: 20),

            // Menampilkan teks "S-Check" di bawah logo.
            const Text(
              'S-Check',
              style: TextStyle(
                fontFamily: 'Poppins', // Menggunakan font Poppins.
                fontSize: 32, // Ukuran teks besar agar terlihat jelas.
                fontWeight: FontWeight.bold, // Membuat teks tebal.
                color: Colors.white, // Warna teks putih agar kontras dengan latar hijau.
              ),
            ),
          ],
        ),
      ),
    );
  }
}
