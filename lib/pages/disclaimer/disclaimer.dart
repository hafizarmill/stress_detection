import 'package:flutter/material.dart';

class DisclaimerDialog extends StatelessWidget {
  const DisclaimerDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          const Text(
            'Disclaimer!',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
      content: const SingleChildScrollView(
        child: const Text( 
          'Aplikasi ini hanya bertujuan untuk membantu mendeteksi stres secara dini berdasarkan wajah Anda. Hasil dari aplikasi ini bukan merupakan diagnosis akhir. Dianjurkan untuk berkonsultasi lebih lanjut dengan tenaga medis, psikolog, atau pihak yang berwenang untuk penanganan profesional.',
          textAlign: TextAlign.justify,
          style: TextStyle(fontSize: 15, height: 1.5),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Saya Mengerti'),
        ),
      ],
    );
  }
}
