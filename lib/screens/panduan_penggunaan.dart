import 'package:flutter/material.dart';

class PanduanPenggunaanScreen extends StatelessWidget {
  const PanduanPenggunaanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Cara Pakai Ember', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: const Color(0xFF1B4332),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF1B4332),
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Row(
              children: [
                Icon(Icons.lightbulb, color: Color(0xFFD4A017), size: 40),
                SizedBox(width: 15),
                Expanded(
                  child: Text(
                    "Panduan harian memasukkan sampah ke dalam Ember Tumpuk agar tidak berbau dan bebas belatung.",
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 25),

          _buildStepCard(
            step: "1",
            title: "Siapkan Alas (Starter)",
            desc: "Sebelum diisi sampah, masukkan segenggam kompos jadi, tanah, atau daun kering ke dasar ember atas sebagai 'rumah' awal bagi bakteri baik.",
            icon: Icons.grass,
          ),
          _buildStepCard(
            step: "2",
            title: "Cacah Sampah Dapur",
            desc: "Potong kecil-kecil sampah organik dapur (sisa sayur, kulit buah). Semakin kecil potongannya, semakin cepat menjadi pupuk.",
            icon: Icons.content_cut,
          ),
          _buildStepCard(
            step: "3",
            title: "Masukkan & Semprot (Opsional)",
            desc: "Masukkan sampah hijau tadi ke ember atas. Jika ada, semprotkan sedikit cairan EM4 atau air cucian beras untuk mempercepat penguraian.",
            icon: Icons.water_drop_outlined,
          ),
          _buildStepCard(
            step: "4",
            title: "Tutup dengan Bahan Cokelat",
            desc: "Ini kunci agar tidak bau! Setiap kali memasukkan sampah basah, tutupi bagian atasnya dengan selapis daun kering, sekam, atau sobekan kardus.",
            icon: Icons.layers,
          ),
          _buildStepCard(
            step: "5",
            title: "Tutup Rapat Ember",
            desc: "Pastikan tutup ember paling atas tertutup.",
            icon: Icons.lock_outline,
          ),
          _buildStepCard(
            step: "6",
            title: "Panen POC dari Keran Bawah",
            desc: "Setiap 3-7 hari, buka keran di ember bagian bawah. Tampung air lindi (Pupuk Cair) yang keluar. Encerkan dengan air biasa sebelum disiram ke tanaman.",
            icon: Icons.opacity,
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildStepCard({required String step, required String title, required String desc, required IconData icon, bool isLast = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: const Color(0xFFD4A017),
                child: Text(step, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
              if (!isLast)
                Container(
                  margin: const EdgeInsets.only(top: 5),
                  width: 2,
                  height: 80,
                  color: const Color(0xFFD4A017).withOpacity(0.5),
                )
            ],
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5, offset: const Offset(0, 3)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(icon, size: 20, color: const Color(0xFF1B4332)),
                      const SizedBox(width: 8),
                      Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1B4332)))),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(desc, style: TextStyle(color: Colors.grey[700], fontSize: 13, height: 1.4)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}