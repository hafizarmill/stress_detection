// 📦 Import pustaka yang dibutuhkan
import 'dart:io'; // Digunakan untuk mengakses file lokal (gambar hasil deteksi)
import 'package:flutter/material.dart'; // Paket utama Flutter untuk membangun UI
import 'package:provider/provider.dart'; // Paket state management menggunakan Provider
import 'package:tes/utils/riwayat_provider.dart'; // Provider custom untuk mengelola data riwayat

// 📄 Halaman DetailRiwayatPage — menampilkan detail satu riwayat hasil deteksi stres
class DetailRiwayatPage extends StatelessWidget {
  // 🔹 Deklarasi variabel yang diterima melalui constructor
  final String jam; // Menyimpan waktu hasil deteksi (misal: "14:32")
  final String tanggal; // Menyimpan tanggal hasil deteksi (misal: "12 Oktober 2025")
  final String hasil; // Menyimpan status hasil deteksi (misal: "Stres" atau "Normal")
  final File gambarFile; // Menyimpan file gambar hasil deteksi wajah

  // 🏗️ Constructor untuk menerima data dari halaman sebelumnya (Riwayat)
  const DetailRiwayatPage({
    super.key,
    required this.jam,
    required this.tanggal,
    required this.hasil,
    required this.gambarFile,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 🎨 Warna utama halaman (hijau khas aplikasi S-Check)
      backgroundColor: const Color(0xFF1D9B6C),

      // 🔹 AppBar (bagian atas halaman)
      appBar: AppBar(
        backgroundColor: const Color(0xFF1D9B6C), // Warna sama dengan latar belakang
        elevation: 0, // Hilangkan bayangan di bawah AppBar
        leading: const BackButton(color: Colors.white), // Tombol kembali
        title: const Text(
          "Detail Riwayat",
          style: TextStyle(color: Colors.white), // Teks putih
        ),
        actions: [
          // 🗑️ Tombol hapus satu riwayat
          IconButton(
            icon: const Icon(Icons.delete_forever, color: Colors.white),
            onPressed: () async {
              // 🔸 Tampilkan dialog konfirmasi sebelum menghapus
              final konfirmasi = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text("Hapus Riwayat?"),
                  content: const Text("Apakah kamu yakin ingin menghapus riwayat ini?"),
                  actions: [
                    // Tombol batal
                    TextButton(
                      child: const Text("Batal"),
                      onPressed: () => Navigator.pop(ctx, false),
                    ),
                    // Tombol hapus
                    TextButton(
                      child: const Text(
                        "Hapus",
                        style: TextStyle(color: Colors.red),
                      ),
                      onPressed: () => Navigator.pop(ctx, true),
                    ),
                  ],
                ),
              );

              // 🧠 Jika pengguna menekan “Hapus”
              if (konfirmasi == true) {
                // Akses provider untuk menghapus data dari daftar riwayat
                final provider = Provider.of<RiwayatProvider>(context, listen: false);
                provider.hapusRiwayatByFile(gambarFile);

                // 🧾 Jika file gambar masih ada di penyimpanan, hapus juga
                if (await gambarFile.exists()) {
                  await gambarFile.delete();
                }

                // Kembali ke halaman sebelumnya setelah penghapusan selesai
                Navigator.pop(context);
              }
            },
          )
        ],
      ),

      // 🔹 Bagian utama tampilan halaman (Body)
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white, // Warna latar belakang isi halaman
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)), // Sudut melengkung di bagian atas
        ),
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // 🖼️ Tampilan gambar hasil deteksi
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.file(
                gambarFile,
                fit: BoxFit.cover, // Agar gambar menyesuaikan tanpa terpotong
                width: double.infinity,
              ),
            ),
            const SizedBox(height: 20),

            // ⏰ Menampilkan jam hasil deteksi
            Text(
              "Jam: $jam",
              style: const TextStyle(fontSize: 18),
            ),

            // 📅 Menampilkan tanggal hasil deteksi
            Text(
              "Tanggal: $tanggal",
              style: const TextStyle(fontSize: 18),
            ),

            // 💡 Menampilkan hasil klasifikasi stres
            Text(
              "Hasil: $hasil",
              style: const TextStyle(
                fontSize: 18,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
