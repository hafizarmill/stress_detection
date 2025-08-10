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

  const DetailRiwayatPage({
    super.key,
    required this.jam,
    required this.tanggal,
    required this.hasil,
    required this.gambarFile,
  });

  @override
  Widget
      build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1D9B6C), // background halaman
      appBar: AppBar(
        backgroundColor: const Color(0xFF1D9B6C),
        elevation: 0,
        leading: const BackButton(color: Colors.white),
        title: const Text(
          "Detail Riwayat",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever, color: Colors.white),
            onPressed: () async {
              final konfirmasi = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text("Hapus Riwayat?"),
                  content: const Text("Apakah kamu yakin ingin menghapus riwayat ini?"),
                  actions: [
                    TextButton(
                      child: const Text("Batal"),
                      onPressed: () => Navigator.pop(ctx, false),
                    ),
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

              if (konfirmasi == true) {
                final provider = Provider.of<RiwayatProvider>(context, listen: false);
                provider.hapusRiwayatByFile(gambarFile);

                if (await gambarFile.exists()) {
                  await gambarFile.delete();
                }

                Navigator.pop(context);
              }
            },
          )
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Gambar dengan border radius
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.file(
                gambarFile,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
            const SizedBox(height: 20),

            // Jam
            Text(
              "Jam: $jam",
              style: const TextStyle(fontSize: 18),
            ),

            // Tanggal
            Text(
              "Tanggal: $tanggal",
              style: const TextStyle(fontSize: 18),
            ),

            // Hasil
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
