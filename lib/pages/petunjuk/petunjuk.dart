import 'package:flutter/material.dart';

class PetunjukPage
    extends StatelessWidget {
  const PetunjukPage(
      {super.key});

  @override
  Widget
      build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F7F5),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            const Text(
              "Petunjuk Pengambilan Gambar",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),

            // 👉 Gambar ditaruh di sini
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              height: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                image: const DecorationImage(
                  image: AssetImage('assets/gambar/petunjuk.png'), //Masukkan gambar yang sesuai
                  fit: BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  )
                ],
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Instruksi Pengambilan Gambar:",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xFF1D9B6C),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text("1. Objek dalam foto harus terlihat jelas."),
                  Text("2. Foto dengan latar belakang polos."),
                  Text("3. Foto memiliki pencahayaan yang cukup."),
                  Text("4. Foto tidak blur dan fokus."),
                  Text("5. Gunakan foto beresolusi baik untuk akurasi tinggi."),
                ],
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1D9B6C),
                padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Saya mengerti",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
