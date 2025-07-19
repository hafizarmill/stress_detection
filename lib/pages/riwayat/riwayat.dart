import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tes/utils/riwayat_provider.dart';
import 'package:tes/pages/riwayat/detail%20riwayat/detail_riwayat.dart';

class Riwayat
    extends StatelessWidget {
  @override
  Widget
      build(BuildContext context) {
    final riwayatProvider =
        Provider.of<RiwayatProvider>(context);
    final riwayatList =
        riwayatProvider.riwayatList;

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
          if (riwayatList.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_forever, color: Colors.white),
              tooltip: 'Hapus Semua Riwayat',
              onPressed: () async {
                final konfirmasi = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Konfirmasi'),
                    content: const Text('Yakin ingin menghapus semua riwayat?'),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Batal')),
                      TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Hapus')),
                    ],
                  ),
                );
                if (konfirmasi == true) {
                  await riwayatProvider.hapusSemuaRiwayat();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Semua riwayat telah dihapus')),
                  );
                }
              },
            ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFF1F7F5),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: riwayatList.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.history, size: 80, color: Colors.grey),
                    SizedBox(height: 20),
                    Text("Belum Ada Riwayat", style: TextStyle(fontSize: 18, color: Colors.grey)),
                  ],
                ),
              )
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
                            catatan: item.catatan,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: item.warna.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.image, color: Colors.white, size: 40),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.access_time, color: Colors.white, size: 16),
                                    const SizedBox(width: 5),
                                    Text(item.jam, style: const TextStyle(color: Colors.white)),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(Icons.calendar_today, color: Colors.white, size: 16),
                                    const SizedBox(width: 5),
                                    Text(item.tanggal, style: const TextStyle(color: Colors.white)),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(Icons.description, color: Colors.white, size: 16),
                                    const SizedBox(width: 5),
                                    Text("Hasil: ${item.status}", style: const TextStyle(color: Colors.white)),
                                  ],
                                ),
                                if (item.catatan != null && item.catatan!.isNotEmpty) ...[
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Icon(Icons.note, color: Colors.white, size: 16),
                                      const SizedBox(width: 5),
                                      Text("Catatan: ${item.catatan}", style: const TextStyle(color: Colors.white)),
                                    ],
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
