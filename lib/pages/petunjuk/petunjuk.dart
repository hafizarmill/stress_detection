// Mengimpor pustaka Flutter utama untuk membangun UI
import 'package:flutter/material.dart';

// Halaman PetunjukPage menampilkan panduan cara pengambilan gambar yang benar
class PetunjukPage extends StatelessWidget {
  const PetunjukPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F7F5), // Warna latar belakang lembut kehijauan
      body: SafeArea(
        // SafeArea memastikan tampilan tidak tertutup notch atau area status bar
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40), // Memberi jarak dari atas layar
            const Text(
              "Petunjuk Pengambilan Gambar", // Judul utama halaman
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),

            // 👉 Bagian gambar ilustrasi petunjuk pengambilan foto
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              child: AspectRatio(
                aspectRatio: 1, // Menetapkan rasio tampilan gambar menjadi 1:1 (persegi)
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16), // Membulatkan sudut kontainer gambar
                    image: const DecorationImage(
                      image: AssetImage('assets/gambar/petunjuk.png'), // Lokasi file gambar petunjuk
                      fit: BoxFit.cover, // Mengatur gambar agar memenuhi area tanpa terpotong
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 👉 Kotak berisi daftar instruksi pengambilan gambar
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white, // Warna latar belakang putih
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12, // Bayangan halus agar kontainer tampak timbul
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  )
                ],
              ),

              // Kolom teks berisi poin-poin panduan pengambilan gambar
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      "Instruksi Pengambilan Gambar", // Subjudul kontainer
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Color(0xFF1D9B6C),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 10),

                  // Daftar poin petunjuk foto
                  Text(
                    "1. Objek dalam foto harus terlihat jelas.",
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    "2. Foto dengan latar belakang polos.",
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    "3. Foto memiliki pencahayaan yang bagus.",
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    "4. Foto tidak blur dan fokus.",
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    "5. Gunakan foto beresolusi baik.",
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // 👉 Tombol konfirmasi untuk menutup halaman petunjuk dan kembali ke halaman sebelumnya
            ElevatedButton(
              onPressed: () => Navigator.pop(context), // Menutup halaman dan kembali ke kamera
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1D9B6C), // Warna tombol hijau utama
                padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12), // Sudut tombol melengkung
                ),
              ),
              child: const Text(
                "Saya mengerti", // Teks tombol
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
