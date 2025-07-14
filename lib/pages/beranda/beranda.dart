import 'package:flutter/material.dart';
import 'package:tes/pages/ambil_foto/kamera.dart';
import 'package:tes/pages/riwayat/riwayat.dart';

class Beranda
    extends StatefulWidget {
  const Beranda(
      {super.key});

  @override
  // ignore: library_private_types_in_public_api
  _BerandaState createState() =>
      _BerandaState();
}

class _BerandaState
    extends State<Beranda> {
  final PageController
      _pageController =
      PageController(
    initialPage:
        1,
    viewportFraction:
        0.85,
  );

  int currentIndex =
      1;

  @override
  void
      initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _pageController.jumpToPage(1);
    });
  }

  @override
  void
      dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void handleCardTap(
      int index) {
    String
        title =
        '';
    String
        content =
        '';

    if (index ==
        0) {
      title = 'Ciri-Ciri Stres';
      content = '• Sakit kepala, kelelahan, nyeri punggung/leher, jantung berdebar kencang.\n'
          '• Nafas cepat, tekanan darah naik, gangguan pencernaan.\n'
          '• Sulit berkonsentrasi, pikiran melayang, kecemasan, mudah marah atau mood naik - turun.\n'
          '• Pola tidur terganggu (insomnia atau terlalu banyak tidur), perubahan pola makan, menarik diri dari lingkungan sosial.\n'
          '• Konsentrasi menurun';
    } else if (index ==
        1) {
      title = 'Penjelasan Stres';
      content = 'Stres adalah respons tubuh (fisik & psikologis) terhadap tekanan atau tuntutan baik yang jangka pendek (akut) maupun jangka panjang (kronis). '
          'Pada stres akut, tubuh melepaskan hormon seperti adrenalin dan cortisol untuk menghadapi tantangan, sedangkan stres kronis yang terus-menerus '
          'dapat berdampak negatif seperti gangguan mental dan risiko penyakit jantung.';
    } else {
      title = 'Penyebab Stres';
      content = '• Tekanan pekerjaan atau akademik (deadline, beban tugas).\n'
          '• Masalah hubungan atau keluarga, konflik interpersonal.\n'
          '• Kekhawatiran finansial, perubahan hidup besar.';
    }

    showCardDialog(title,
        content);
  }

  void showCardDialog(
      String title,
      String content) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 16,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    content,
                    style: const TextStyle(fontSize: 16),
                    textAlign: title == 'Penjelasan Stres' ? TextAlign.justify : TextAlign.start,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget
      build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1D9B6C),
      body: SafeArea(
        child: Column(
          children: [
            // Atas: Salam dan scroll card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Halo,", style: TextStyle(color: Colors.white, fontSize: 20)),
                  const Text(
                    "Selamat Datang",
                    style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),

                  // Scrollable Card
                  SizedBox(
                    height: 150,
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: 3,
                      onPageChanged: (index) {
                        setState(() {
                          currentIndex = index;
                        });
                      },
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: GestureDetector(
                            onTap: () => handleCardTap(index),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE2F6F2),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: const [
                                  BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 2)),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Image.asset(
                                    'assets/gambar/logo-1.png',
                                    height: 80,
                                    color: Colors.black,
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          index == 0
                                              ? "Ciri-Ciri Stres"
                                              : index == 1
                                                  ? "Penjelasan Stres"
                                                  : "Penyebab Stres",
                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Icon(Icons.info_outline, color: Colors.teal),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // Indikator bar
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(3, (index) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: currentIndex == index ? 30 : 10,
                        height: 5,
                        decoration: BoxDecoration(
                          color: currentIndex == index ? Colors.white : Colors.white54,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),

            // Bawah: fitur tombol
            SizedBox(
              height: 500,
              child: Stack(
                children: [
                  // Latar belakang putih
                  Container(
                    padding: const EdgeInsets.all(90),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F7F5),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Column(
                      children: [
                        fiturCard(
                          icon: Icons.camera_alt,
                          label: "Gambar",
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => Kamera()));
                          },
                        ),
                        const SizedBox(height: 40),
                        fiturCard(
                          icon: Icons.history,
                          label: "Riwayat",
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => Riwayat()));
                          },
                        ),
                      ],
                    ),
                  ),

                  // Teks di kiri atas container putih
                  const Positioned(
                    top: 20,
                    left: 30,
                    child: Text(
                      "Mari cek stres:",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget
      fiturCard({
    required IconData
        icon,
    required String
        label,
    required VoidCallback
        onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 160,
        height: 140,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.green),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.green, size: 40),
            const SizedBox(height: 10),
            Text(label, style: const TextStyle(fontSize: 16, color: Colors.black)),
          ],
        ),
      ),
    );
  }
}
