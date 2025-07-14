import 'dart:io';
import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart'
    as img;

class TFLiteHelper {
  Interpreter?
      _interpreter;
  List<String>?
      _labels;

  /// Load model dan label
  Future<void>
      loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset('assets/model/model_stress.tflite');
      print('✅ Model loaded successfully');
    } catch (e) {
      print('❌ Failed to load model: $e');
    }

    try {
      final labelsData = await rootBundle.loadString('assets/model/label.txt');
      _labels = labelsData.split('\n').where((e) => e.isNotEmpty).toList();
      print('✅ Labels loaded: $_labels');
      for (int i = 0; i < _labels!.length; i++) {
        print('Label $i: "${_labels![i]}"');
      }
    } catch (e) {
      print('❌ Failed to load labels: $e');
    }
  }

  /// Klasifikasi gambar menjadi Stres / Normal
  Future<Map<String, double>>
      classifyImage(File image) async {
    if (_interpreter == null ||
        _labels == null) {
      await loadModel();
    }

    var input =
        _processRawImage(image);

    var output =
        List.filled(1, List.filled(1, 0.0)); // [1,1]
    _interpreter!.run(input,
        output);

    print("📊 Output: ${output[0]}");

    double
        probStres =
        output[0][0];
    double
        probNormal =
        1.0 - probStres;

    return {
      _labels![1]: probStres, // "Stres"
      _labels![0]: probNormal, // "Normal"
    };
  }

  /// Preprocessing: resize, normalisasi, menggunakan .r, .g, .b seperti temanmu
  List<List<List<List<double>>>>
      _processRawImage(File imageFile) {
    final image =
        img.decodeImage(imageFile.readAsBytesSync())!;
    final resizedImage = img.copyResize(image,
        width: 224,
        height: 224);

    return List.generate(
      1,
      (_) => List.generate(
        224,
        (y) => List.generate(
          224,
          (x) {
            var pixel = resizedImage.getPixel(x, y);
            return [
              pixel.r.toDouble(),
              pixel.g.toDouble(),
              pixel.b.toDouble(),
            ];
          },
        ),
      ),
    );
  }
}
