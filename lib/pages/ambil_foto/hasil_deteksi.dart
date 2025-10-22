// Import pustaka dan file yang diperlukan
import 'dart:io'; // Untuk membaca file gambar dari penyimpanan lokal
import 'package:flutter/material.dart';
import 'package:tes/pages/beranda/beranda.dart'; // Mengimpor halaman beranda untuk navigasi setelah hasil deteksi

// Kelas HasilDeteksi merupakan StatelessWidget karena datanya hanya ditampilkan tanpa perubahan
class HasilDeteksi extends StatelessWidget {
  // Variabel untuk menyimpan path gambar hasil deteksi dan status hasil (Normal/Stres)
  final String imagePath;
  final String status;

  // Konstruktor wajib menerima nilai imagePath dan status
  const HasilDeteksi({
    super.key,
    required this.imagePath,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1D9B6C), // Warna latar belakang utama (hijau khas aplikasi)
      appBar: AppBar(
        backgroundColor: const Color(0xFF1D9B6C), // AppBar berwarna hijau senada
        elevation: 0, // Menghilangkan bayangan AppBar agar tampak datar
        leading: const BackButton(color: Colors.white), // Tombol kembali berwarna putih
        title: const Text(
          "Hasil Deteksi",
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Poppins', // Menggunakan font Poppins untuk konsistensi desain
          ),
        ),
      ),

      // Bagian utama konten halaman
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Color(0xFFF1F7F5), // Warna latar belakang isi (putih kehijauan)
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30), // Sudut atas melengkung agar tampak modern
          ),
        ),

        // Kolom utama untuk menampilkan isi halaman
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20), // Spasi atas
            ClipRRect(
              borderRadius: BorderRadius.circular(16), // Membulatkan sudut gambar
              child: Image.file(
                File(imagePath), // Menampilkan gambar berdasarkan path yang diterima
                height: 250,
                width: double.infinity,
                fit: BoxFit.cover, // Mengatur gambar agar memenuhi lebar area
              ),
            ),
            const SizedBox(height: 30), // Spasi antara gambar dan teks
            const Text(
              "Status Deteksi", // Judul bagian hasil
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              status, // Menampilkan hasil deteksi ('Normal' atau 'Stres')
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
                fontFamily: 'Poppins',
              ),
            ),
            const Spacer(), // Mendorong tombol ke bagian bawah layar
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Navigasi ke halaman Beranda dan menghapus semua halaman sebelumnya dari stack
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const Beranda()),
                    (route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1D9B6C), // Warna tombol hijau
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // Sudut tombol membulat
                  ),
                ),
                child: const Text(
                  "Selesai", // Teks tombol konfirmasi akhir
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    color: Colors.white, // Warna teks tombol putih agar kontras
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
