import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tes/utils/riwayat_provider.dart';
import 'package:tes/pages/riwayat/detail%20riwayat/detail_riwayat.dart';

class Riwayat
    extends StatelessWidget {
  const Riwayat(
      {super.key});

  @override
  Widget
      build(BuildContext context) {
    final riwayatProvider =
        Provider.of<RiwayatProvider>(context);
    final riwayatList =
        riwayatProvider.riwayatList;

    // jika belum terisi, coba muat dari file (opsional)
    if (riwayatList.isEmpty) {
      riwayatProvider.muatRiwayatDariFile();
    }

    return Scaffold(
      backgroundColor: const Color(0xFF1D9B6C),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.white),
        title: const Text('Riwayat', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever, color: Colors.white),
            tooltip: 'Hapus Semua Riwayat',
            onPressed: riwayatList.isEmpty
                ? null
                : () {
                    showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Hapus Semua Riwayat'),
                        content: const Text('Yakin ingin menghapus semua riwayat?'),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Batal')),
                          TextButton(
                            onPressed: () => Navigator.pop(ctx, true),
                            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      ),
                    ).then((confirmed) {
                      if (confirmed == true) {
                        riwayatProvider.hapusSemuaRiwayat();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Semua riwayat telah dihapus')),
                        );
                      }
                    });
                  },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFF1F7F5),
          borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
        ),
        child: riwayatList.isEmpty
            // Tampilan saat tidak ada riwayat
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
            // Tampilan saat ada riwayat
            : ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: riwayatList.length,
                itemBuilder: (context, index) {
                  final item = riwayatList[index];

                  return GestureDetector(
                      onTap: () {
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
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: item.warna.withOpacity(0.85),
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
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
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      // const Icon(Icons.access_time, color: Colors.white70, size: 14),
                                      // const SizedBox(width: 4),
                                      Text(
                                        "${item.jam} • ${item.tanggal}",
                                        style: const TextStyle(color: Colors.white, fontSize: 14),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "Hasil: ${item.status}",
                                    style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
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
