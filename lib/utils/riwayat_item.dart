// 📦 Import library bawaan Dart untuk mengelola file
import 'dart:io';

// 🎨 Import library Flutter untuk menggunakan tipe data Color
import 'package:flutter/material.dart';

// 🧱 Class ini merepresentasikan satu entri (item) riwayat hasil deteksi stres.
//    Setiap RiwayatItem menyimpan data seperti gambar, waktu deteksi, status hasil,
//    serta warna penanda kondisi (hijau = normal, merah = stres).
class RiwayatItem {
  // 🖼️ Menyimpan file gambar hasil deteksi wajah.
  final File gambar;

  // ⏰ Menyimpan jam kapan deteksi dilakukan.
  final String jam;

  // 📅 Menyimpan tanggal deteksi.
  final String tanggal;

  // 🧠 Menyimpan hasil klasifikasi (contoh: "Stres" atau "Normal").
  final String status;

  // 🎨 Menyimpan warna latar item (hijau untuk normal, merah untuk stres).
  final Color warna;

  // 🧩 Konstruktor utama untuk membuat objek RiwayatItem baru.
  RiwayatItem({
    required this.gambar,
    required this.jam,
    required this.tanggal,
    required this.status,
    required this.warna,
  });

  // 💾 Mengubah objek RiwayatItem menjadi Map (format JSON sederhana)
  //     agar bisa disimpan ke file lokal (misalnya ke format .json).
  Map<String, dynamic> toMap() => {
        'gambarPath': gambar.path, // Simpan path file, bukan objek File langsung.
        'jam': jam,
        'tanggal': tanggal,
        'status': status,
        'warna': warna.value, // Simpan nilai integer dari warna.
      };

  // 📂 Mengubah data Map (hasil baca dari file JSON) kembali menjadi objek RiwayatItem.
  static RiwayatItem fromMap(Map<String, dynamic> json) {
    return RiwayatItem(
      gambar: File(json['gambarPath']), // Bangun kembali objek File dari path.
      jam: json['jam'],
      tanggal: json['tanggal'],
      status: json['status'],
      warna: Color(json['warna']), // Ubah nilai integer warna menjadi objek Color.
    );
  }
}

