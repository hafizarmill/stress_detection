import 'dart:io';
import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

/// Kelas ini berfungsi sebagai *helper* untuk:
/// 1️⃣ Memuat model TensorFlow Lite (`.tflite`)
/// 2️⃣ Membaca label hasil klasifikasi
/// 3️⃣ Melakukan preprocessing pada gambar
/// 4️⃣ Menjalankan inferensi (prediksi) dengan model
class TFLiteHelper {
  Interpreter? _interpreter; // Komponen utama untuk menjalankan model TFLite
  List<String>? _labels; // Daftar label (misalnya: ["Normal", "Stres"])

  /// Fungsi untuk memuat model dan label dari folder assets
  Future<void> loadModel() async {
    try {
      // Memuat file model dari assets (pastikan path di pubspec.yaml sudah benar)
      _interpreter = await Interpreter.fromAsset('assets/model/model_stress.tflite');
      print('✅ Model loaded successfully');
    } catch (e) {
      print('❌ Failed to load model: $e');
    }

    try {
      // Membaca file label.txt yang berisi daftar kelas hasil prediksi
      final labelsData = await rootBundle.loadString('assets/model/label.txt');
      _labels = labelsData.split('\n').where((e) => e.isNotEmpty).toList();

      print('✅ Labels loaded: $_labels');
      // Debugging tambahan: tampilkan label satu per satu
      for (int i = 0; i < _labels!.length; i++) {
        print('Label $i: "${_labels![i]}"');
      }
    } catch (e) {
      print('❌ Failed to load labels: $e');
    }
  }

  /// Fungsi utama untuk melakukan klasifikasi gambar menjadi "Stres" / "Normal"
  /// Hasil berupa map: {"Stres": probabilitas, "Normal": probabilitas}
  Future<Map<String, double>> classifyImage(File image) async {
    // Jika model atau label belum dimuat, muat terlebih dahulu
    if (_interpreter == null || _labels == null) {
      await loadModel();
    }

    // Preprocessing gambar sebelum masuk ke model
    var input = _processRawImage(image);

    // Output model biasanya berupa array [1,1] atau sesuai arsitektur model
    var output = List.filled(1, List.filled(1, 0.0)); // Bentuk [1,1]

    // Jalankan inferensi
    _interpreter!.run(input, output);

    print("📊 Output: ${output[0]}");

    // Asumsi output[0][0] adalah probabilitas stres
    double probStres = output[0][0];
    double probNormal = 1.0 - probStres;

    // Mengembalikan hasil klasifikasi dalam bentuk map
    return {
      _labels![1]: probStres,  // Label kedua diasumsikan "Stres"
      _labels![0]: probNormal, // Label pertama diasumsikan "Normal"
    };
  }

  /// Fungsi preprocessing untuk menyiapkan gambar sebelum masuk model:
  /// - Resize gambar ke ukuran input model (224x224)
  /// - Ambil nilai RGB setiap piksel
  /// - Bentuk data menjadi [1, 224, 224, 3]
  List<List<List<List<double>>>> _processRawImage(File imageFile) {
    // Decode gambar dari file menjadi objek image
    final image = img.decodeImage(imageFile.readAsBytesSync())!;

    // Ubah ukuran gambar sesuai kebutuhan model
    final resizedImage = img.copyResize(image, width: 224, height: 224);

    // Konversi gambar ke format input model (4D array)
    return List.generate(
      1, // batch size (1 gambar)
      (_) => List.generate(
        224, // tinggi
        (y) => List.generate(
          224, // lebar
          (x) {
            var pixel = resizedImage.getPixel(x, y);
            return [
              pixel.r.toDouble(), // nilai red
              pixel.g.toDouble(), // nilai green
              pixel.b.toDouble(), // nilai blue
            ];
          },
        ),
      ),
    );
  }
}
