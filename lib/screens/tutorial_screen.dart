import 'package:flutter/material.dart';

class TutorialScreen extends StatelessWidget {
  const TutorialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Tutorial Pembuatan Ember Komposter', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: const Color(0xFF1B4332),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // BAGIAN 1: APA ITU EMBER KOMPOS?
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF2D5A27), Color(0xFF1B4332)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5)),
              ],
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.help_outline, color: Color(0xFFD4A017), size: 28),
                    SizedBox(width: 10),
                    Text("Apa itu Ember Komposter?", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
                  ],
                ),
                SizedBox(height: 12),
                Text(
                  "Ember Komposter (Ember Tumpuk) adalah alat pemroses pupuk sederhana yang terdiri dari dua ember bersusun. Ember bagian atas berfungsi untuk mengolah sampah organik menjadi pupuk padat, sedangkan ember bagian bawah berfungsi menampung cairan lindi yang nantinya dipanen menjadi Pupuk Organik Cair (POC).",
                  style: TextStyle(color: Colors.white, fontSize: 13, height: 1.5),
                ),

              ],
            ),
          ),
          const SizedBox(height: 25),

          // BAGIAN 2: PERSIAPAN ALAT DAN BAHAN
          const Text("Persiapan Alat & Bahan", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF5D4037))),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5, offset: const Offset(0, 3))],
            ),
            child: Column(
              children: [
                _buildMaterialItem('assets/ember.png', "2 buah ember bekas beserta tutupnya (Kita sebut sebagai Ember A dan Ember B)."),
                const Divider(),
                _buildMaterialItem('assets/alat_bor.png', "Alat pelubang (seperti mesin bor, paku yang dipanaskan, atau solder)."),
                const Divider(),
                _buildMaterialItem('assets/keran.png', "1 buah keran air (lengkap dengan seal karet agar tidak bocor)."),
              ],
            ),
          ),
          const SizedBox(height: 30),

          // BAGIAN 3: LANGKAH-LANGKAH PEMBUATAN
          const Text("Langkah-Langkah Pembuatan", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF5D4037))),
          const SizedBox(height: 15),

          _buildStepCard(
            stepNumber: "1",
            title: "Modifikasi Ember A",
            imagePath: 'assets/langkah1.jpeg', // <--- Gambar Langkah 1
            desc: "• Balikkan Ember A.\n• Buatlah beberapa lubang kecil di bagian dasar ember tersebut.",
            fungsi: "Lubang-lubang ini akan menjadi jalur resapan agar air yang dihasilkan dari tumpukan bahan kompos bisa menetes ke bawah.",
            icon: Icons.upload,
            color: const Color(0xFF43A047),
          ),

          _buildStepCard(
            stepNumber: "2",
            title: "Modifikasi Tutup Ember B",
            imagePath: 'assets/langkah2.jpeg', // <--- Gambar Langkah 2
            desc: "• Ambil tutup dari Ember B.\n• Potong dan lubangi bagian tengah tutup tersebut, sisakan hanya bagian tepian (ujung keliling) tutupnya saja.",
            fungsi: "Tutup ini nantinya dipasang di Ember B untuk menjadi bantalan atau penyangga agar Ember A bisa diletakkan dengan pas dan stabil di atas Ember B.",
            icon: Icons.adjust,
            color: const Color(0xFFF57C00),
          ),

          _buildStepCard(
            stepNumber: "3",
            title: "Modifikasi Ember B",
            imagePath: 'assets/langkah3.png', // <--- Gambar Langkah 3
            desc: "• Buat satu lubang di bagian samping bawah Ember B (sesuaikan ukurannya dengan diameter keran).\n• Pasang keran air pada lubang tersebut dan pastikan terpasang rapat agar tidak bocor.",
            fungsi: "Keran ini berguna untuk mengalirkan dan memanen Pupuk Organik Cair (POC) yang tertampung di dalam Ember B.",
            icon: Icons.opacity,
            color: const Color(0xFF1976D2),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // ==== WIDGET PEMBANTU: DAFTAR ALAT & BAHAN ====
  Widget _buildMaterialItem(String imagePath, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              imagePath,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 65,
                  height: 65,
                  color: Colors.grey.shade200,
                  child: const Icon(Icons.image_not_supported, color: Colors.grey),
                );
              },
            ),
          ),
          const SizedBox(width: 15),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 14, height: 1.4))),
        ],
      ),
    );
  }

  // ==== WIDGET PEMBANTU: KARTU LANGKAH-LANGKAH ====
  Widget _buildStepCard({
    required String stepNumber,
    required String title,
    required String imagePath, // Menerima parameter gambar baru
    required String desc,
    required String fungsi,
    required IconData icon,
    required Color color
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 4))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Langkah
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 14,
                    backgroundColor: color,
                    child: Text(stepNumber, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: color)),
                  ),
                  Icon(icon, color: color, size: 20),
                ],
              ),
            ),

            // Gambar Langkah
            ClipRRect(
              child: Image.asset(
                imagePath,
                width: double.infinity,
                height: 400, // Tinggi gambar membentang
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: double.infinity,
                    height: 150,
                    color: Colors.grey.shade200,
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.image, color: Colors.grey, size: 40),
                        SizedBox(height: 5),
                        Text("Gambar belum tersedia", style: TextStyle(color: Colors.grey, fontSize: 12))
                      ],
                    ),
                  );
                },
              ),
            ),

            // Isi Langkah (Deskripsi & Fungsi)
            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(desc, style: const TextStyle(fontSize: 13, height: 1.5, color: Colors.black87)),
                  const SizedBox(height: 15),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.info_outline, size: 18, color: Colors.grey),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text("Fungsi:\n$fungsi", style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Colors.black87, height: 1.4)),
                        ),
                      ],
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
}