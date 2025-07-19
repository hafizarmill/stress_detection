import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tes/utils/riwayat_item.dart';
import 'package:tes/utils/riwayat_provider.dart';

class KuisionerPage
    extends StatefulWidget {
  final String
      hasilDeteksi;
  final File
      gambar;
  final String
      jam;
  final String
      tanggal;

  const KuisionerPage({
    super.key,
    required this.hasilDeteksi,
    required this.gambar,
    required this.jam,
    required this.tanggal,
  });

  @override
  State<KuisionerPage> createState() =>
      _KuisionerPageState();
}

class _KuisionerPageState
    extends State<KuisionerPage> {
  final List<String>
      _pertanyaan =
      [
    "Apakah Anda sering merasa lelah secara mental?",
    "Apakah Anda sulit tidur akhir-akhir ini?",
    "Apakah Anda merasa cemas tanpa alasan jelas?",
    "Apakah Anda kehilangan motivasi beraktivitas?",
    "Apakah Anda mudah tersinggung?",
    "Apakah Anda merasa tidak mampu menyelesaikan tugas?",
    "Apakah Anda merasa ingin menyendiri?",
    "Apakah Anda merasa sulit berkonsentrasi?",
    "Apakah Anda sering merasa tertekan?",
    "Apakah Anda merasa waktu berjalan terlalu cepat/tidak cukup?"
  ];

  List<int?>
      _jawaban =
      List.filled(10, null);

  String decisionTree(
      String hasilDeteksi,
      int skor) {
    if (hasilDeteksi ==
        "Normal") {
      return "Normal";
    } else {
      if (skor >= 5) {
        return "Stres";
      } else {
        return "Terindikasi Stres";
      }
    }
  }

  void
      _submitKuisioner() {
    if (_jawaban.contains(null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Harap jawab semua pertanyaan.")),
      );
      return;
    }

    int skor =
        _jawaban.fold(0, (total, val) => total + (val ?? 0));
    String
        hasilAkhir =
        decisionTree(widget.hasilDeteksi, skor);

    final warna = hasilAkhir == "Stres"
        ? Colors.red
        : hasilAkhir == "Normal"
            ? Colors.green
            : Colors.orange;

    final item =
        RiwayatItem(
      gambar: widget.gambar,
      jam: widget.jam,
      tanggal: widget.tanggal,
      status: hasilAkhir,
      warna: warna,
    );

    Provider.of<RiwayatProvider>(context, listen: false).tambahRiwayat(item);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Hasil Akhir"),
        content: Text(
          "📸 Deteksi Wajah: ${widget.hasilDeteksi}\n"
          "📋 Skor Kuisioner: $skor dari 10\n"
          "🧠 Hasil Akhir: $hasilAkhir",
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context); // kembali ke kamera
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  Widget
      _buildPertanyaan(int index) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Pertanyaan ${index + 1}: ${_pertanyaan[index]}"),
            Row(
              children: [
                Radio<int>(
                  value: 1,
                  groupValue: _jawaban[index],
                  onChanged: (value) {
                    setState(() => _jawaban[index] = value);
                  },
                ),
                const Text("Ya"),
                Radio<int>(
                  value: 0,
                  groupValue: _jawaban[index],
                  onChanged: (value) {
                    setState(() => _jawaban[index] = value);
                  },
                ),
                const Text("Tidak"),
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget
      build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kuisioner Validasi"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              "Jawablah semua pertanyaan berikut untuk validasi kondisi Anda:",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: _pertanyaan.length,
                itemBuilder: (_, index) => _buildPertanyaan(index),
              ),
            ),
            ElevatedButton(
              onPressed: _submitKuisioner,
              child: const Text("Submit"),
            ),
          ],
        ),
      ),
    );
  }
}
