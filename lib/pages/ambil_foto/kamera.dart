// 📦 Import package dan dependensi utama
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tes/utils/tflite_helper.dart'; // Untuk menjalankan model TFLite (deteksi stres)
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart'; // Untuk mendeteksi wajah
import 'package:image/image.dart' as img; // Untuk manipulasi gambar (crop, encode)
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart'; // Untuk format tanggal lokal Indonesia
import 'package:provider/provider.dart'; // State management
import 'package:tes/utils/riwayat_provider.dart'; // Penyimpanan hasil deteksi ke riwayat
import 'package:tes/utils/riwayat_item.dart'; // Struktur data riwayat
import 'package:path_provider/path_provider.dart'; // Menyimpan file ke direktori aplikasi
import 'package:tes/pages/petunjuk/petunjuk.dart'; // Halaman petunjuk pengambilan gambar

// 📷 Halaman Kamera — digunakan untuk mengambil gambar dan melakukan deteksi stres
class Kamera extends StatefulWidget {
  @override
  _KameraPageState createState() => _KameraPageState();
}

class _KameraPageState extends State<Kamera> {
  // 🔹 Variabel untuk menyimpan file gambar
  File? _imageFile;

  // 🔹 Instance image picker untuk mengambil gambar dari kamera atau galeri
  final ImagePicker _picker = ImagePicker();

  // 🔹 Status hasil deteksi (misal: “Stres (85%)” atau “Normal (92%)”)
  String _status = "";

  // 🔹 Indikator proses pemrosesan gambar sedang berjalan
  bool _loading = false;

  // 🔹 Detector wajah dari ML Kit
  late final FaceDetector _faceDetector;

  @override
  void initState() {
    super.initState();
    // Inisialisasi format tanggal lokal Indonesia
    initializeDateFormatting('id', null);

    // Inisialisasi Face Detector dengan opsi dasar (tanpa landmark/contour)
    _faceDetector = FaceDetector(
      options: FaceDetectorOptions(
        enableContours: false,
        enableClassification: false,
        enableLandmarks: false,
      ),
    );
  }

  @override
  void dispose() {
    // Tutup instance face detector agar tidak ada memory leak
    _faceDetector.close();
    super.dispose();
  }

  // 📸 Fungsi untuk mengambil gambar dari kamera depan
  Future<void> ambilFoto() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.front,
    );

    // Jika gambar berhasil diambil
    if (pickedFile != null) {
      setState(() {
        _loading = true; // tampilkan indikator loading
        _status = ""; // reset status
        _imageFile = null; // reset gambar sebelumnya
      });
      await _deteksiStress(File(pickedFile.path)); // jalankan deteksi stres
    }
  }

  // 🖼️ Fungsi untuk memilih gambar dari galeri
  Future<void> ambilDariGaleri() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    // Jika gambar berhasil dipilih
    if (pickedFile != null) {
      setState(() {
        _loading = true;
        _status = "";
        _imageFile = null;
      });
      await _deteksiStress(File(pickedFile.path));
    }
  }

  // 🧠 Fungsi utama untuk mendeteksi stres dari gambar wajah
  Future<void> _deteksiStress(File image) async {
    try {
      // Konversi gambar ke format yang bisa dibaca oleh ML Kit
      final inputImage = InputImage.fromFile(image);
      final faces = await _faceDetector.processImage(inputImage);

      // Jika wajah tidak terdeteksi, tampilkan pesan error
      if (faces.isEmpty) {
        setState(() {
          _loading = false;
          _status = "Wajah Tidak Terdeteksi";
          _imageFile = null;
        });
        return;
      }

      // Decode gambar agar bisa diolah (misal cropping)
      final imageBytes = await image.readAsBytes();
      final decodedImage = img.decodeImage(imageBytes);
      if (decodedImage == null) {
        throw Exception("Gagal decode gambar");
      }

      // Ambil area wajah berdasarkan bounding box hasil deteksi ML Kit
      final face = faces.first;
      final box = face.boundingBox;
      final cropped = img.copyCrop(
        decodedImage,
        x: box.left.toInt().clamp(0, decodedImage.width),
        y: box.top.toInt().clamp(0, decodedImage.height),
        width: box.width.toInt().clamp(0, decodedImage.width),
        height: box.height.toInt().clamp(0, decodedImage.height),
      );

      // Simpan hasil crop ke penyimpanan lokal
      final now = DateTime.now();
      final fileName = 'stress_${now.millisecondsSinceEpoch}.png';
      final appDir = await getApplicationDocumentsDirectory();
      final savedPath = '${appDir.path}/$fileName';
      final croppedFile = File(savedPath);
      await croppedFile.writeAsBytes(img.encodePng(cropped));

      // Perbarui tampilan dengan gambar hasil crop
      setState(() {
        _imageFile = croppedFile;
      });

      // 🔍 Jalankan model TensorFlow Lite untuk klasifikasi
      final tfliteHelper = TFLiteHelper();
      final hasil = await tfliteHelper.classifyImage(croppedFile);

      // Ambil label dengan nilai confidence tertinggi
      final label = hasil.entries.reduce((a, b) => a.value > b.value ? a : b);
      final confidence = (label.value * 100).toStringAsFixed(2);

      // Format waktu dan tanggal hasil deteksi
      final jam = DateFormat.Hm('id').format(now);
      final tanggal = DateFormat('dd MMMM yyyy', 'id').format(now);

      // Tentukan warna berdasarkan hasil deteksi
      final warna = label.key == "Stres" ? Colors.red : Colors.green;

      // Buat item riwayat baru dan simpan melalui Provider
      final item = RiwayatItem(
        gambar: croppedFile,
        jam: jam,
        tanggal: tanggal,
        status: "${label.key} ($confidence%)",
        warna: warna,
      );

      Provider.of<RiwayatProvider>(context, listen: false).tambahRiwayat(item);

      // Perbarui status tampilan
      setState(() {
        _status = "${label.key} ($confidence%)";
        _loading = false;
      });
    } catch (e) {
      // Tangani error umum (misal gagal deteksi atau file rusak)
      setState(() {
        _loading = false;
        _status = "Error";
      });
    }
  }

  // 🎨 Fungsi pemetaan warna teks status berdasarkan hasil
  Color _getStatusColor(String status) {
    final s = status.toLowerCase();
    if (s.contains('stres')) return Colors.red; // hasil "Stres"
    if (s.contains('wajah')) return Colors.red; // wajah tidak terdeteksi
    if (s.contains('error')) return Colors.red; // kesalahan proses
    if (s.contains('normal')) return Colors.green; // hasil "Normal"
    return Colors.black; // default jika tidak dikenali
  }

  // 🧩 Tampilan utama halaman Kamera
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1D9B6C), // warna hijau khas aplikasi
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.white), // tombol kembali
        title: const Text("Kamera", style: TextStyle(color: Colors.white)),
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Color(0xFFF1F7F5), // warna putih lembut
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30), // sudut melengkung atas
          ),
        ),
        child: Column(
          children: [
            // 🖼️ Area tampilan gambar hasil pengambilan/crop
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                height: 300,
                width: double.infinity,
                color: Colors.grey[300],
                child: Stack(
                  children: [
                    // Jika belum ada gambar, tampilkan ikon placeholder
                    Positioned.fill(
                      child: _imageFile == null
                          ? Center(
                              child: Icon(
                                Icons.image,
                                size: 100,
                                color: Colors.grey[500],
                              ),
                            )
                          // Jika ada gambar, tampilkan hasilnya
                          : Image.file(
                              _imageFile!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                    ),
                    // Overlay loading saat gambar sedang diproses
                    if (_loading)
                      Positioned.fill(
                        child: Container(
                          color: Colors.black.withOpacity(0.4),
                          child: const Center(
                            child: Text(
                              "Gambar Sedang di Proses...",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            // 🔘 Tombol ambil foto dari kamera
            ElevatedButton(
              onPressed: ambilFoto,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1D9B6C),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
              child: const Text("Ambil Foto",
                  style: TextStyle(color: Colors.white, fontSize: 20)),
            ),

            const SizedBox(height: 16),

            // 🔘 Tombol ambil gambar dari galeri
            ElevatedButton(
              onPressed: ambilDariGaleri,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1D9B6C),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 45, vertical: 15),
              ),
              child: const Text("Ambil Galeri",
                  style: TextStyle(color: Colors.white, fontSize: 20)),
            ),

            const SizedBox(height: 16),

            // 🧾 Menampilkan status hasil deteksi
            if (_status.isNotEmpty)
              Column(
                children: [
                  Text(
                    "Status: $_status",
                    style: TextStyle(
                      fontSize: 20,
                      color: _getStatusColor(_status),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

            const Spacer(),

            // 🔗 Tautan menuju halaman petunjuk pengambilan gambar
            GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PetunjukPage()),
              ),
              child: const Text(
                "Petunjuk Pengambilan Gambar",
                style: TextStyle(
                  fontSize: 20,
                  color: Color.fromARGB(255, 0, 0, 0),
                  decoration: TextDecoration.underline,
                ),
              ),
            ),

            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
