import 'dart:io';
import 'package:flutter/material.dart';
import 'package:tes/pages/beranda/beranda.dart'; // ganti sesuai path kamu

class HasilDeteksi
    extends StatelessWidget {
  final String
      imagePath;
  final String
      status;

  const HasilDeteksi(
      {super.key,
      required this.imagePath,
      required this.status});

  @override
  Widget
      build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1D9B6C), // Latar belakang hijau
      appBar: AppBar(
        backgroundColor: const Color(0xFF1D9B6C),
        elevation: 0,
        leading: const BackButton(color: Colors.white),
        title: const Text(
          "Hasil Deteksi",
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Poppins',
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Color(0xFFF1F7F5), // Latar konten putih kehijauan
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.file(
                File(imagePath),
                height: 250,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              "Status Deteksi",
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              status,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
                fontFamily: 'Poppins',
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const Beranda()),
                    (route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1D9B6C),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Selesai",
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    color: Colors.white,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
