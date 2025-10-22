// 🔹 Mengimpor paket-paket Flutter yang dibutuhkan
import 'package:flutter/material.dart';
import 'package:tes/pages/ambil_foto/kamera.dart';
import 'package:tes/pages/riwayat/riwayat.dart';
import 'package:tes/pages/disclaimer/disclaimer.dart'; // pastikan path ini sesuai lokasi file disclaimer.dart

// 🔹 Widget Beranda merupakan StatefulWidget karena memiliki data (state) yang dapat berubah, 
// seperti halaman aktif dan tampilan dialog.
class Beranda extends StatefulWidget {
  const Beranda({super.key});

  // 🔹 createState() digunakan untuk membuat instance dari kelas state (_BerandaState)
  @override
  _BerandaState createState() => _BerandaState();
}

// 🔹 Kelas _BerandaState menampung logika dan tampilan (UI) dari halaman Beranda.
// Simbol "_" di awal nama artinya bersifat private (hanya bisa diakses di file ini).
class _BerandaState extends State<Beranda> {
  // 🔹 Controller untuk mengatur PageView (scrollable card)
  final PageController _pageController = PageController(
    initialPage: 1,
    viewportFraction: 0.85,
  );

  // 🔹 Menyimpan indeks halaman card yang sedang aktif
  int currentIndex = 1;

  // 🔹 Variabel pengaturan tampilan teks pada card dan dialog info
  final double infoCardFontSize = 18; // ukuran font judul pada card
  final double infoDialogFontSize = 18; // ukuran font teks dalam popup dialog
  final double infoDialogSpacing = 8; // jarak antar poin di popup dialog

  // 🔹 Fungsi initState() dipanggil pertama kali ketika widget dibuat.
  // Di sini digunakan untuk menampilkan dialog disclaimer saat aplikasi pertama dibuka.
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _pageController.jumpToPage(1); // langsung ke halaman card tengah

      // 🔹 Menampilkan pop up peringatan (DisclaimerDialog) agar pengguna membaca penjelasan awal
      showDialog(
        context: context,
        barrierDismissible: false, // tidak bisa ditutup dengan tap di luar dialog
        builder: (context) => const DisclaimerDialog(),
      );
    });
  }

  // 🔹 Fungsi dispose() dipanggil saat widget dihapus dari tree
  // Digunakan untuk membebaskan resource PageController agar tidak terjadi kebocoran memori.
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // 🔹 Fungsi ini menangani aksi saat user menekan salah satu card di beranda.
  void handleCardTap(int index) {
    String title = '';
    dynamic content;

    // 🔹 Menentukan isi dialog berdasarkan card yang ditekan
    if (index == 0) {
      title = 'Ciri-Ciri Stres';
      content = [
        'Sakit kepala, kelelahan, nyeri punggung/leher, jantung berdebar kencang.',
        'Nafas cepat, tekanan darah naik, gangguan pencernaan.',
        'Sulit berkonsentrasi, pikiran melayang, kecemasan, mudah marah atau mood naik-turun.',
        'Pola tidur terganggu (insomnia atau terlalu banyak tidur), perubahan pola makan, menarik diri dari lingkungan sosial.',
        'Konsentrasi menurun.'
      ];
    } else if (index == 1) {
      title = 'Penjelasan Stres';
      content =
          'Stres adalah respons tubuh (fisik & psikologis) terhadap tekanan atau tuntutan baik yang jangka pendek (akut) maupun jangka panjang (kronis). Pada stres akut, tubuh melepaskan hormon seperti adrenalin dan cortisol untuk menghadapi tantangan, sedangkan stres kronis yang terus-menerus akan dapat berdampak negatif seperti gangguan mental dan risiko penyakit jantung.';
    } else {
      title = 'Penyebab Stres';
      content = [
        'Tekanan pekerjaan atau akademik (deadline, beban tugas).',
        'Masalah hubungan atau keluarga, konflik interpersonal.',
        'Kekhawatiran finansial, perubahan hidup besar.'
      ];
    }

    // 🔹 Menampilkan dialog berisi informasi berdasarkan card yang ditekan
    showCardDialog(title, content);
  }

  // 🔹 Fungsi untuk membuat dan menampilkan dialog berisi penjelasan
  void showCardDialog(String title, dynamic content) {
    showDialog(
      context: context,
      barrierDismissible: true, // bisa ditutup dengan tap di luar dialog
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          titlePadding: const EdgeInsets.all(16),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 12),

          // 🔹 Bagian judul dialog dengan ikon dan teks
          title: Row(
            children: [
              const Icon(Icons.info, color: Color(0xFF1D9B6C), size: 28),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Color(0xFF1D9B6C),
                  ),
                ),
              ),
            ],
          ),

          // 🔹 Bagian isi dialog (berupa teks tunggal atau daftar poin)
          content: SingleChildScrollView(
            child: content is String
                ? Text(
                    content,
                    style: TextStyle(
                      fontSize: infoDialogFontSize,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.justify,
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(content.length, (i) {
                      return Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: infoDialogSpacing / 2),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(top: 6),
                              child: Icon(Icons.circle,
                                  size: 8, color: Color(0xFF1D9B6C)),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                content[i],
                                style: TextStyle(
                                  fontSize: infoDialogFontSize,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
          ),

          // 🔹 Tombol untuk menutup dialog
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: const Color(0xFF1D9B6C),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Tutup", style: TextStyle(fontSize: 16)),
            ),
          ],
        );
      },
    );
  }

  // 🔹 Fungsi build() adalah fungsi utama dalam widget yang digunakan untuk membangun UI.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1D9B6C), // warna dasar halaman
      body: SafeArea(
        child: Column(
          children: [
            // 🔹 Bagian atas halaman berisi salam dan card informasi stres
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Halo,",
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                  const Text(
                    "Selamat Datang",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),

                  // 🔹 Scrollable Card menggunakan PageView
                  SizedBox(
                    height: 150,
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: 3,
                      onPageChanged: (index) {
                        setState(() {
                          currentIndex = index; // ubah indikator aktif
                        });
                      },
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: GestureDetector(
                            onTap: () => handleCardTap(index), // aksi tap card
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE2F6F2),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: const [
                                  BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 6,
                                      offset: Offset(0, 2)),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          index == 0
                                              ? "Ciri-Ciri Stres"
                                              : index == 1
                                                  ? "Penjelasan Stres"
                                                  : "Penyebab Stres",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: infoCardFontSize,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Icon(Icons.info_outline,
                                      color: Color(0xFF1D9B6C)),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // 🔹 Indikator posisi halaman card (titik-titik bawah card)
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
                          color: currentIndex == index
                              ? Colors.white
                              : Colors.white54,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),

            // 🔹 Bagian bawah halaman berisi tombol fitur utama
            SizedBox(
              height: 500,
              child: Stack(
                children: [
                  // 🔹 Latar belakang putih dengan dua tombol fitur
                  Container(
                    padding: const EdgeInsets.all(90),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F7F5),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Column(
                      children: [
                        // Tombol menuju halaman kamera
                        fiturCard(
                          icon: Icons.camera_alt,
                          label: "Gambar",
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Kamera()));
                          },
                        ),
                        const SizedBox(height: 40),

                        // Tombol menuju halaman riwayat
                        fiturCard(
                          icon: Icons.history,
                          label: "Riwayat",
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Riwayat()));
                          },
                        ),
                      ],
                    ),
                  ),

                  // 🔹 Teks "Mari cek stres:" di atas tombol
                  const Positioned(
                    top: 20,
                    left: 30,
                    child: Text(
                      "Mari cek stres:",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
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

  // 🔹 Widget kecil untuk membuat kartu fitur (seperti tombol kamera & riwayat)
  Widget fiturCard({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 160,
        height: 140,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFF1D9B6C)),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: const Color(0xFF1D9B6C), size: 40),
            const SizedBox(height: 10),
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
