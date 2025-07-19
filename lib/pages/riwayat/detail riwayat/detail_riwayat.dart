import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tes/utils/riwayat_provider.dart';

class DetailRiwayatPage
    extends StatelessWidget {
  final String
      jam;
  final String
      tanggal;
  final String
      hasil;
  final File
      gambarFile;
  final String?
      catatan;

  const DetailRiwayatPage({
    super.key,
    required this.jam,
    required this.tanggal,
    required this.hasil,
    required this.gambarFile,
    this.catatan,
  });

  void _konfirmasiHapus(
      BuildContext context) async {
    final konfirmasi =
        await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Hapus Riwayat"),
        content: const Text("Apakah Anda yakin ingin menghapus riwayat ini?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Batal"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Hapus", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (konfirmasi ==
        true) {
      Provider.of<RiwayatProvider>(context, listen: false).hapusRiwayatByFile(gambarFile);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Riwayat berhasil dihapus")),
      );
    }
  }

  @override
  Widget
      build(BuildContext context) {
    // 🟡 Tentukan warna berdasarkan hasil
    Color
        warna;
    if (hasil ==
        "Stres") {
      warna = Colors.red;
    } else if (hasil ==
        "Terindikasi Stres") {
      warna = const Color(0xFFFFC107); // kuning
    } else {
      warna = const Color(0xFF1D9B6C); // hijau untuk Normal
    }

    return Scaffold(
      backgroundColor: warna,
      appBar: AppBar(
        backgroundColor: warna, // ✅ hanya background yang berubah
        elevation: 0,
        leading: const BackButton(color: Colors.white), // ⬅ tetap putih
        title: const Text("Detail Riwayat", style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever, color: Colors.white),
            tooltip: "Hapus Riwayat Ini",
            onPressed: () => _konfirmasiHapus(context),
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 250,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.grey[300],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.file(gambarFile, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 20),
            Text("Jam: $jam", style: const TextStyle(fontSize: 18)),
            Text("Tanggal: $tanggal", style: const TextStyle(fontSize: 18)),
            Text("Hasil: $hasil", style: TextStyle(fontSize: 18, color: warna, fontWeight: FontWeight.bold)),
            if (catatan != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  "Catatan: $catatan",
                  style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
