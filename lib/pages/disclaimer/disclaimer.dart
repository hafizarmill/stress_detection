// Mengimpor pustaka utama Flutter untuk membangun antarmuka pengguna (UI).
import 'package:flutter/material.dart';

// Kelas DisclaimerDialog merupakan widget statis (StatelessWidget),
// artinya tampilan ini tidak memiliki data yang berubah.
// Widget ini digunakan untuk menampilkan pop-up peringatan (AlertDialog)
// berisi penjelasan bahwa aplikasi hanya mendeteksi stres secara dini.
class DisclaimerDialog extends StatelessWidget {
  // Konstruktor const untuk efisiensi widget.
  // Tidak akan dibangun ulang jika tidak ada perubahan data.
  const DisclaimerDialog({super.key});

  @override
  // Method build digunakan untuk membangun tampilan pop-up dialog ini.
  Widget build(BuildContext context) {
    // AlertDialog adalah komponen pop-up standar Flutter.
    // Biasanya digunakan untuk menampilkan pesan, konfirmasi, atau peringatan.
    return AlertDialog(
      // Mengatur bentuk pop-up dengan sudut membulat agar tampil lebih modern.
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),

      // Bagian judul dialog.
      title: const Text(
        "Pemberitahuan!", // Judul peringatan di bagian atas dialog.
        style: TextStyle(
          fontWeight: FontWeight.bold, // Membuat teks tebal agar lebih menonjol.
          fontSize: 22, // Ukuran teks judul.
          color: Color(0xFF1D9B6C), // Warna hijau khas tema aplikasi.
        ),
        textAlign: TextAlign.center, // Judul diratakan ke tengah.
      ),

      // Bagian isi utama dari dialog.
      // SingleChildScrollView digunakan agar isi dapat di-scroll jika terlalu panjang.
      content: const SingleChildScrollView(
        // Column digunakan untuk menata teks secara vertikal.
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Teks dimulai dari sisi kiri.
          children: [
            // Teks utama berisi penjelasan fungsi aplikasi dan anjuran kepada pengguna.
            Text(
              "Aplikasi ini hanya bertujuan untuk membantu mendeteksi stres secara dini berdasarkan wajah Anda. Hasil dari aplikasi ini bukan merupakan diagnosis akhir. Dianjurkan untuk berkonsultasi lebih lanjut dengan tenaga medis, psikolog, atau pihak yang berwenang untuk penanganan profesional.",
              style: TextStyle(fontSize: 18, height: 1.5), // Ukuran dan jarak antar baris teks.
              textAlign: TextAlign.justify, // Teks diratakan agar tampak rapi di kiri-kanan.
            ),
            SizedBox(height: 8), // Memberikan jarak vertikal kecil di bawah teks.
          ],
        ),
      ),

      // Mengatur posisi tombol tindakan (actions) agar berada di tengah bawah dialog.
      actionsAlignment: MainAxisAlignment.center,

      // Bagian tombol aksi di bagian bawah dialog.
      actions: [
        // TextButton adalah tombol datar (tanpa elevasi) khas Material Design.
        TextButton(
          // Ketika tombol ditekan, dialog akan ditutup menggunakan Navigator.pop().
          onPressed: () => Navigator.of(context).pop(),

          // Mengatur gaya tampilan tombol.
          style: TextButton.styleFrom(
            foregroundColor: Colors.white, // Warna teks di tombol.
            backgroundColor: const Color(0xFF1D9B6C), // Warna latar tombol (hijau khas aplikasi).
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12), // Membuat sudut tombol membulat.
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 20, // Jarak kiri-kanan dalam tombol.
              vertical: 10, // Jarak atas-bawah dalam tombol.
            ),
          ),

          // Teks yang ditampilkan di dalam tombol.
          child: const Text(
            'Saya Mengerti',
            style: TextStyle(
              fontSize: 18, // Ukuran teks tombol.
            ),
          ),
        ),
      ],
    );
  }
}
