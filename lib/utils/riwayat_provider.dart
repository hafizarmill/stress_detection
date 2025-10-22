// 📦 Import library untuk konversi data JSON (agar bisa disimpan ke file lokal)
import 'dart:convert';

// 📁 Import library untuk mengelola file sistem
import 'dart:io';

// 🎨 Import bawaan Flutter untuk state management dan notifikasi perubahan
import 'package:flutter/material.dart';

// 📂 Import path provider untuk mendapatkan direktori penyimpanan aplikasi
import 'package:path_provider/path_provider.dart';

// 🧱 Import model data RiwayatItem (representasi satu entri hasil deteksi)
import 'riwayat_item.dart';

// 🧠 RiwayatProvider berfungsi sebagai pengelola (state manager)
//     untuk seluruh data riwayat hasil deteksi stres.
//     Provider ini mengatur proses:
//     - Menyimpan riwayat ke file JSON
//     - Membaca (load) riwayat dari file
//     - Menghapus satu atau semua riwayat
//     - Memberi notifikasi ke UI saat data berubah
class RiwayatProvider extends ChangeNotifier {
  // 🗂️ List yang menampung seluruh riwayat hasil deteksi
  final List<RiwayatItem> _riwayatList = [];

  // 📍 Path file JSON tempat data riwayat disimpan
  String _riwayatFilePath = '';

  // 📤 Getter untuk mengakses data riwayat dari luar (misal di UI)
  List<RiwayatItem> get riwayatList => _riwayatList;

  // 🚀 Konstruktor: otomatis menjalankan fungsi _init() saat objek dibuat
  RiwayatProvider() {
    _init();
  }

  // 📂 Inisialisasi path file riwayat dan memuat data dari file jika ada
  Future<void> _init() async {
    final dir = await getApplicationDocumentsDirectory(); // ambil direktori aplikasi
    _riwayatFilePath = '${dir.path}/riwayat.json'; // buat file riwayat.json di folder itu
    await muatRiwayatDariFile(); // coba muat data yang sudah tersimpan
  }

  // ➕ Tambah satu riwayat baru ke list dan simpan ke file
  Future<void> tambahRiwayat(RiwayatItem item) async {
    _riwayatList.insert(0, item); // simpan di urutan paling atas
    await simpanRiwayatKeFile(); // update file JSON
    notifyListeners(); // beri tahu UI agar ikut diperbarui
  }

  // ❌ Hapus satu item riwayat (termasuk file gambarnya)
  Future<void> hapusRiwayat(RiwayatItem item) async {
    try {
      // Hapus file gambar jika masih ada di penyimpanan
      if (await item.gambar.exists()) {
        await item.gambar.delete();
      }

      _riwayatList.remove(item); // hapus dari list
      await simpanRiwayatKeFile(); // update file JSON
      notifyListeners(); // update tampilan
    } catch (e) {
      print('Gagal menghapus riwayat: $e');
    }
  }

  // 💾 Simpan seluruh data riwayat ke file JSON
  Future<void> simpanRiwayatKeFile() async {
    try {
      final file = File(_riwayatFilePath);
      final jsonList = _riwayatList.map((item) => item.toMap()).toList(); // ubah ke format Map
      await file.writeAsString(json.encode(jsonList)); // simpan ke file
    } catch (e) {
      print('Gagal menyimpan riwayat ke file: $e');
    }
  }

  // ❌ Hapus riwayat berdasarkan file gambar (digunakan di halaman detail)
  void hapusRiwayatByFile(File file) {
    _riwayatList.removeWhere((item) => item.gambar.path == file.path);
    simpanRiwayatKeFile(); // perbarui file JSON
    notifyListeners(); // beri tahu UI
  }

  // 🧹 Hapus semua riwayat sekaligus
  void hapusSemuaRiwayat() {
    _riwayatList.clear(); // kosongkan list
    simpanRiwayatKeFile(); // perbarui file JSON agar kosong
    notifyListeners(); // beri tahu UI
  }

  // 📥 Muat (baca) seluruh riwayat dari file JSON ke dalam list aplikasi
  Future<void> muatRiwayatDariFile() async {
    try {
      final file = File(_riwayatFilePath);

      // Jika file tidak ada, hentikan proses
      if (await file.exists()) {
        final contents = await file.readAsString(); // baca isi file
        final List<dynamic> jsonList = json.decode(contents); // ubah dari JSON ke List

        // 🔄 Hindari duplikasi saat reload data
        _riwayatList.clear();

        // Konversi setiap item JSON ke objek RiwayatItem
        _riwayatList.addAll(
          jsonList.map((jsonItem) => RiwayatItem.fromMap(jsonItem)).toList(),
        );

        notifyListeners(); // update UI
      }
    } catch (e) {
      print("Gagal memuat riwayat: $e");
    }
  }
}
