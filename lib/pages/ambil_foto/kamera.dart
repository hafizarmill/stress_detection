import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tes/utils/tflite_helper.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image/image.dart'
    as img;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tes/utils/riwayat_provider.dart';
import 'package:tes/utils/riwayat_item.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tes/pages/petunjuk/petunjuk.dart';

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

  late final FaceDetector
      _faceDetector;

  @override
  void
      initState() {
    super.initState();
    _faceDetector =
        FaceDetector(
      options: FaceDetectorOptions(
        enableContours: false,
        enableClassification: false,
        enableLandmarks: false,
      ),
    );
  }

  @override
  void
      dispose() {
    _faceDetector.close();
    super.dispose();
  }

  Future<void>
      ambilFoto() async {
    final pickedFile =
        await _picker.pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.front,
    );

    if (pickedFile !=
        null) {
      setState(() {
        _loading = true;
        _status = "";
      });
      await _deteksiStress(File(pickedFile.path));
    }
  }

  Future<void>
      ambilDariGaleri() async {
    final pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile !=
        null) {
      setState(() {
        _loading = true;
        _status = "";
      });
      await _deteksiStress(File(pickedFile.path));
    }
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

      final imageBytes = await image.readAsBytes();
      final decodedImage = img.decodeImage(imageBytes);
      if (decodedImage == null) {
        throw Exception("Gagal decode gambar");
      }

      final face = faces.first;
      final box = face.boundingBox;
      final cropped = img.copyCrop(
        decodedImage,
        x: box.left.toInt().clamp(0, decodedImage.width),
        y: box.top.toInt().clamp(0, decodedImage.height),
        width: box.width.toInt().clamp(0, decodedImage.width),
        height: box.height.toInt().clamp(0, decodedImage.height),
      );

      final now = DateTime.now();
      final fileName = 'stress_${now.millisecondsSinceEpoch}.png';
      final appDir = await getApplicationDocumentsDirectory();
      final savedPath = '${appDir.path}/$fileName';
      final croppedFile = File(savedPath);
      await croppedFile.writeAsBytes(img.encodePng(cropped));

      setState(() {
        _imageFile = croppedFile;
      });

      final tfliteHelper = TFLiteHelper();
      final hasil = await tfliteHelper.classifyImage(croppedFile);
      final label = hasil.entries.reduce((a, b) => a.value > b.value ? a : b);

      final jam = DateFormat.Hm().format(now);
      final tanggal = DateFormat('dd MMMM yyyy').format(now);
      final warna = label.key == "Stres" ? Colors.red : Colors.green;

      final item = RiwayatItem(
        gambar: croppedFile,
        jam: jam,
        tanggal: tanggal,
        status: label.key,
        warna: warna,
      );

      Provider.of<RiwayatProvider>(context, listen: false).tambahRiwayat(item);

      setState(() {
        _status = label.key;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
        _status = "Error";
      });
    }
  }

  @override
  Widget
      build(BuildContext context) {
    return Scaffold(
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
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Column(
          children: [
            Container(
              height: 300,
              width: double.infinity,
              color: Colors.grey[300],
              child: _imageFile == null ? Center(child: Icon(Icons.image, size: 100, color: Colors.grey[500])) : Image.file(_imageFile!, fit: BoxFit.cover),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: ambilFoto,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1D9B6C),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
              child: const Text("Ambil Foto", style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: ambilDariGaleri,
              style: ElevatedButton.styleFrom(
                
                backgroundColor: const Color(0xFF1D9B6C),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(horizontal: 45, vertical: 15),
              ),
              child: const Text("Ambil Galeri", style: TextStyle(color: Colors.white, fontSize: 16)),
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
                      color: _status == "Stres" ? Colors.red : Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            const Spacer(),
            GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PetunjukPage()),
              ),
              child: const Text(
                "Petunjuk Pengambilan Gambar",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blueAccent,
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
