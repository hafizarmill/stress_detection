// Mengimpor pustaka Flutter untuk membangun antarmuka aplikasi
import 'package:flutter/material.dart';
// Mengimpor Provider untuk state management data riwayat
import 'package:provider/provider.dart';
// Mengimpor RiwayatProvider sebagai pengelola data riwayat hasil deteksi
import 'package:tes/utils/riwayat_provider.dart';
// Mengimpor halaman detail riwayat untuk menampilkan detail tiap hasil
import 'package:tes/pages/riwayat/detail%20riwayat/detail_riwayat.dart';

// Halaman utama Riwayat — menampilkan daftar hasil deteksi stres yang telah disimpan
class Riwayat extends StatelessWidget {
  const Riwayat({super.key});

  @override
  Widget build(BuildContext context) {
    // Mengambil instance RiwayatProvider agar dapat mengakses data riwayat
    final riwayatProvider = Provider.of<RiwayatProvider>(context);
    // Daftar item riwayat yang tersimpan
    final riwayatList = riwayatProvider.riwayatList;

    // Jika daftar kosong, coba muat data dari file lokal (fungsi di provider)
    if (riwayatList.isEmpty) {
      riwayatProvider.muatRiwayatDariFile();
    }

    // Struktur tampilan utama halaman riwayat
    return Scaffold(
      backgroundColor: const Color(0xFF1D9B6C), // Latar belakang hijau utama
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.white), // Tombol kembali
        title: const Text('Riwayat', style: TextStyle(color: Colors.white)),
        actions: [
          // Tombol hapus semua riwayat (ikon tempat sampah)
          IconButton(
            icon: const Icon(Icons.delete_forever, color: Colors.white),
            tooltip: 'Hapus Semua Riwayat',
            onPressed: riwayatList.isEmpty
                ? null // Nonaktif jika tidak ada riwayat
                : () {
                    // Menampilkan dialog konfirmasi hapus semua
                    showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Hapus Semua Riwayat'),
                        content: const Text('Yakin ingin menghapus semua riwayat?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx, false),
                            child: const Text('Batal'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(ctx, true),
                            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      ),
                    ).then((confirmed) {
                      // Jika pengguna mengonfirmasi, hapus seluruh data
                      if (confirmed == true) {
                        riwayatProvider.hapusSemuaRiwayat();
                        // Tampilkan notifikasi snackbar
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Semua riwayat telah dihapus')),
                        );
                      }
                    });
                  },
          ),
        ],
      ),

      // Bagian isi utama halaman (body)
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFF1F7F5), // Latar belakang konten putih kehijauan
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),

        // Kondisi jika belum ada riwayat tersimpan
        child: riwayatList.isEmpty
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.history, size: 120, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        "Tidak Ada Riwayat",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              )

            // Kondisi jika terdapat data riwayat — tampilkan dalam ListView
            : ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: riwayatList.length, // jumlah item sesuai data riwayat
                itemBuilder: (context, index) {
                  final item = riwayatList[index]; // Ambil item ke-index tertentu

                  // Widget tiap item riwayat (bisa ditekan untuk membuka detail)
                  return GestureDetector(
                      onTap: () {
                        // Navigasi ke halaman detail dengan data hasil deteksi
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailRiwayatPage(
                              jam: item.jam,
                              tanggal: item.tanggal,
                              hasil: item.status,
                              gambarFile: item.gambar,
                            ),
                          ),
                        );
                      },

                      // Tampilan kotak tiap riwayat (warna tergantung hasil)
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: item.warna.withOpacity(0.85), // warna sesuai status (merah/hijau)
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),

                        // Isi kotak: gambar + teks jam/tanggal/hasil
                        child: Row(
                          children: [
                            // Gambar hasil deteksi wajah
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.file(
                                item.gambar,
                                width: 72,
                                height: 72,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 12),

                            // Bagian teks jam, tanggal, dan hasil deteksi
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      // Menampilkan jam dan tanggal deteksi
                                      Text(
                                        "${item.jam} • ${item.tanggal}",
                                        style: const TextStyle(color: Colors.white, fontSize: 18),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),

                                  // Menampilkan hasil deteksi (Stres/Normal)
                                  Text(
                                    "Hasil: ${item.status}",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ));
                },
              ),
      ),
    );
  }
}
