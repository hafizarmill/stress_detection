import 'dart:io';
import 'package:flutter/material.dart';

class RiwayatItem {
  final File gambar;
  final String jam;
  final String tanggal;
  final String status;
  final Color warna;

  RiwayatItem({
    required this.gambar,
    required this.jam,
    required this.tanggal,
    required this.status,
    required this.warna,
  });

  // Untuk menyimpan ke file
  Map<String, dynamic> toMap() => {
    'gambarPath': gambar.path,
    'jam': jam,
    'tanggal': tanggal,
    'status': status,
    'warna': warna.value, // Simpan int dari warna
  };

  // Untuk membaca dari file
  static RiwayatItem fromMap(Map<String, dynamic> json) {
    return RiwayatItem(
      gambar: File(json['gambarPath']),
      jam: json['jam'],
      tanggal: json['tanggal'],
      status: json['status'],
      warna: Color(json['warna']),
    );
  }
}
