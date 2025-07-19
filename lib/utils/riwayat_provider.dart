import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'riwayat_item.dart';

class RiwayatProvider
    extends ChangeNotifier {
  final List<RiwayatItem>
      _riwayatList =
      [];
  String
      _riwayatFilePath =
      '';

  List<RiwayatItem> get riwayatList =>
      _riwayatList;

  RiwayatProvider() {
    _init();
  }

  Future<void>
      _init() async {
    final dir =
        await getApplicationDocumentsDirectory();
    _riwayatFilePath =
        '${dir.path}/riwayat.json';
    await muatRiwayatDariFile();
  }

  Future<void>
      tambahRiwayat(RiwayatItem item) async {
    _riwayatList.insert(0,
        item);
    await simpanRiwayatKeFile();
    notifyListeners();
  }

  Future<void>
      hapusRiwayat(RiwayatItem item) async {
    try {
      if (await item.gambar.exists()) {
        await item.gambar.delete();
      }
      _riwayatList.remove(item);
      await simpanRiwayatKeFile();
      notifyListeners();
    } catch (e) {
      print('Gagal menghapus riwayat: $e');
    }
  }

  Future<void>
      simpanRiwayatKeFile() async {
    try {
      final file = File(_riwayatFilePath);
      final jsonList = _riwayatList.map((item) => item.toMap()).toList();
      await file.writeAsString(json.encode(jsonList));
    } catch (e) {
      print('Gagal menyimpan riwayat ke file: $e');
    }
  }

  void hapusRiwayatByFile(
      File file) {
    _riwayatList.removeWhere((item) =>
        item.gambar.path ==
        file.path);
    simpanRiwayatKeFile();
    notifyListeners();
  }

  Future<void>
      muatRiwayatDariFile() async {
    try {
      final file = File(_riwayatFilePath);
      if (await file.exists()) {
        final contents = await file.readAsString();
        final List<dynamic> jsonList = json.decode(contents);
        _riwayatList.clear();
        _riwayatList.addAll(
          jsonList.map((jsonItem) => RiwayatItem.fromMap(jsonItem)).toList(),
        );
        notifyListeners();
      }
    } catch (e) {
      print("Gagal memuat riwayat: $e");
    }
  }

  Future<void>
      hapusSemuaRiwayat() async {
    try {
      for (var item in _riwayatList) {
        if (await item.gambar.exists()) {
          await item.gambar.delete();
        }
      }
      _riwayatList.clear();
      await simpanRiwayatKeFile();
      notifyListeners();
    } catch (e) {
      print('Gagal menghapus semua riwayat: $e');
    }
  }
}
