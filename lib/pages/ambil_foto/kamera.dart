import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tes/utils/tflite_helper.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image/image.dart'
    as img;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tes/pages/petunjuk/petunjuk.dart';
import 'package:tes/pages/kuisioner/kuisioner.dart';
import 'package:tes/utils/riwayat_provider.dart';
import 'package:tes/utils/riwayat_item.dart';

class Kamera
    extends StatefulWidget {
  @override
  _KameraPageState createState() =>
      _KameraPageState();
}

class _KameraPageState
    extends State<Kamera> {
  File?
      _imageFile;
  final ImagePicker
      _picker =
      ImagePicker();
  String
      _status =
      "";
  bool
      _loading =
      false;
  late FaceDetector
      _faceDetector;
  String?
      _jam;
  String?
      _tanggal;
  bool
      _tombolKuisioner =
      false;
  bool
      _sudahSimpan =
      false;

  @override
  void
      initState() {
    super.initState();
    _faceDetector =
        FaceDetector(
      options: FaceDetectorOptions(),
    );
  }

  @override
  void
      dispose() {
    _faceDetector.close();
    super.dispose();
  }

  Future<void>
      _ambilFotoAtauGaleri(ImageSource source) async {
    final pickedFile =
        await _picker.pickImage(source: source);
    if (pickedFile ==
        null)
      return;

    setState(() {
      _loading = true;
      _status = "";
      _tombolKuisioner = false;
      _sudahSimpan = false;
    });

    await _deteksiStress(File(pickedFile.path));
  }

  Future<void>
      _deteksiStress(File image) async {
    try {
      final inputImage = InputImage.fromFile(image);
      final faces = await _faceDetector.processImage(inputImage);

      if (faces.isEmpty) {
        setState(() {
          _loading = false;
          _status = "Wajah Tidak Terdeteksi";
          _imageFile = null;
        });
        return;
      }

      final bytes = await image.readAsBytes();
      final decoded = img.decodeImage(bytes);
      if (decoded == null)
        throw Exception("Gagal decode");

      final face = faces.first;
      final box = face.boundingBox;

      final cropped = img.copyCrop(
        decoded,
        x: box.left.toInt().clamp(0, decoded.width),
        y: box.top.toInt().clamp(0, decoded.height),
        width: box.width.toInt().clamp(0, decoded.width),
        height: box.height.toInt().clamp(0, decoded.height),
      );

      final now = DateTime.now();
      _jam = DateFormat.Hm().format(now);
      _tanggal = DateFormat('dd MMMM yyyy').format(now);

      final dir = await getApplicationDocumentsDirectory();
      final path = '${dir.path}/stress_${now.millisecondsSinceEpoch}.png';
      final file = File(path)..writeAsBytesSync(img.encodePng(cropped));

      final tfliteHelper = TFLiteHelper();
      final hasil = await tfliteHelper.classifyImage(file);

      // DEBUG: Print hasil klasifikasi
      print("Hasil klasifikasi: $hasil");

      final label = hasil.entries.reduce((a, b) => a.value > b.value ? a : b);

      // PERBAIKAN: Bersihkan string dari karakter tersembunyi
      final cleanedLabel = label.key.trim().replaceAll(RegExp(r'[^\w\s]'), '');

      // // DEBUG: Print label yang dipilih
      // print("Label asli: '${label.key}'");
      // print("Label dibersihkan: '$cleanedLabel'");
      // print("Confidence: ${label.value}");
      // print("Panjang string asli: ${label.key.length}");
      // print("Panjang string bersih: ${cleanedLabel.length}");

      // // DEBUG: Print karakter per karakter
      // print("Karakter dalam label.key:");
      // for (int i = 0; i < label.key.length; i++) {
      //   print("  Index $i: '${label.key[i]}' (${label.key.codeUnitAt(i)})");
      // }

      setState(() {
        _imageFile = file;
        _status = cleanedLabel; // Gunakan label yang sudah dibersihkan
        _loading = false;
        _tombolKuisioner = cleanedLabel.toLowerCase() == "stres";
      });

      // PERBAIKAN: Gunakan perbandingan yang lebih robust
      if (cleanedLabel.toLowerCase() == "normal") {
        print("Masuk ke kondisi Normal, akan menyimpan riwayat");
        final item = RiwayatItem(
          gambar: file,
          jam: _jam!,
          tanggal: _tanggal!,
          status: "Normal",
          warna: Colors.green,
        );

        try {
          Provider.of<RiwayatProvider>(context, listen: false).tambahRiwayat(item);
          print("Riwayat Normal berhasil disimpan");
          _sudahSimpan = true;
        } catch (e) {
          print("Error saat menyimpan riwayat Normal: $e");
        }
      } else if (cleanedLabel.toLowerCase() == "stres") {
        print("Terdeteksi stres, tombol kuisioner akan muncul");
      } else {
        print("Label tidak dikenali: '$cleanedLabel'");
      }
    } catch (e) {
      print("Error di _deteksiStress: $e");
      setState(() {
        _loading = false;
        _status = "Error";
      });
    }
  }

  Future<bool>
      _handleBack() async {
    if (_status == "Stres" &&
        !_sudahSimpan &&
        _imageFile != null &&
        _jam != null &&
        _tanggal != null) {
      final item = RiwayatItem(
        gambar: _imageFile!,
        jam: _jam!,
        tanggal: _tanggal!,
        status: "Stres",
        warna: Colors.red,
        catatan: "Tanpa Isi Kuisioner",
      );
      Provider.of<RiwayatProvider>(context, listen: false).tambahRiwayat(item);
      _sudahSimpan = true;
    }
    return true;
  }

  @override
  Widget
      build(BuildContext context) {
    return WillPopScope(
      onWillPop: _handleBack,
      child: Scaffold(
        backgroundColor: const Color(0xFF1D9B6C),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: const BackButton(color: Colors.white),
          title: const Text("Kamera", style: TextStyle(color: Colors.white)),
        ),
        body: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Color(0xFFF1F7F5),
            borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
          ),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  height: 300,
                  width: double.infinity,
                  color: Colors.grey[300],
                  child: _imageFile == null ? Center(child: Icon(Icons.image, size: 100, color: Colors.grey[500])) : Image.file(_imageFile!, fit: BoxFit.cover),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () => _ambilFotoAtauGaleri(ImageSource.camera),
                child: const Text("Ambil Foto", style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1D9B6C),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => _ambilFotoAtauGaleri(ImageSource.gallery),
                child: const Text("Ambil Galeri", style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1D9B6C),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(horizontal: 45, vertical: 15),
                ),
              ),
              const SizedBox(height: 16),
              if (_loading) const CircularProgressIndicator(),
              if (_status.isNotEmpty)
                Column(
                  children: [
                    Text(
                      "Status: $_status",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: _status == "Stres" || _status == "Wajah Tidak Terdeteksi" ? Colors.red : Colors.green,
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (_tombolKuisioner && _imageFile != null && _jam != null && _tanggal != null)
                      ElevatedButton(
                        onPressed: () {
                          setState(() => _sudahSimpan = true);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => KuisionerPage(
                                hasilDeteksi: _status,
                                gambar: _imageFile!,
                                jam: _jam!,
                                tanggal: _tanggal!,
                              ),
                            ),
                          );
                        },
                        child: const Text("Lanjut Kuisioner", style: TextStyle(color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                        ),
                      ),
                  ],
                ),
              const Spacer(),
              GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PetunjukPage())),
                child: const Text(
                  "Petunjuk Pengambilan Gambar",
                  style: TextStyle(color: Colors.blueAccent, decoration: TextDecoration.underline),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}