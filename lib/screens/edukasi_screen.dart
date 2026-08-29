import 'package:flutter/material.dart';

class EdukasiScreen extends StatelessWidget {
  const EdukasiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        appBar: AppBar(
          title: const Text('Edukasi Sampah', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
          backgroundColor: const Color(0xFF1B4332),
          iconTheme: const IconThemeData(color: Colors.white),
          bottom: const TabBar(
            indicatorColor: Color(0xFFD4A017),
            indicatorWeight: 3,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white54,
            tabs: [
              Tab(icon: Icon(Icons.eco), text: "Organik"),
              Tab(icon: Icon(Icons.recycling), text: "Anorganik"),
              Tab(icon: Icon(Icons.autorenew), text: "Prinsip 3R"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildTabOrganik(),
            _buildTabAnorganik(),
            _buildTab3R(),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // TAB 1: SAMPAH ORGANIK
  // ==========================================
  Widget _buildTabOrganik() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _buildHeaderCard(
          title: "Apa itu Sampah Organik?",
          desc: "Sampah organik berasal dari bahan hayati dan umumnya sangat mudah terurai melalui proses alami. Ini adalah bahan baku utama untuk membuat kompos.",
          color: const Color(0xFF2D5A27),
          icon: Icons.grass,
        ),
        const SizedBox(height: 20),
        const Text("Contoh Sampah Organik", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF5D4037))),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10, runSpacing: 10,
          children: [
            _buildChip("Sisa Makanan", Icons.restaurant),
            _buildChip("Kulit Buah", Icons.apple),
            _buildChip("Daun Kering", Icons.eco_outlined),
            _buildChip("Potongan Sayur", Icons.spa),
          ],
        ),
        const SizedBox(height: 25),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _buildInfoBox(
                title: "LAKUKAN (✅)",
                items: [
                  "Pisahkan dari plastik, logam, & kaca.",
                  "Tiriskan cairan/kuah terlebih dahulu.",
                  "Potong kecil agar cepat terurai.",
                  "Simpan di wadah tertutup."
                ],
                color: Colors.green,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: _buildInfoBox(
                title: "HINDARI (❌)",
                items: [
                  "Mencampur dengan plastik bungkus.",
                  "Memasukkan minyak atau bahan kimia.",
                  "Memasukkan benda tajam.",
                  "Menumpuk terlalu lama hingga bau."
                ],
                color: Colors.red,
              ),
            ),
          ],
        )
      ],
    );
  }

  // ==========================================
  // TAB 2: SAMPAH ANORGANIK & KHUSUS
  // ==========================================
  Widget _buildTabAnorganik() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _buildHeaderCard(
          title: "Sampah Anorganik",
          desc: "Sampah yang sulit terurai secara alami namun sangat bisa dimanfaatkan kembali atau didaur ulang.",
          color: const Color(0xFF1976D2),
          icon: Icons.delete_outline,
        ),
        const SizedBox(height: 15),
        const Text("Syarat Daur Ulang:", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1976D2))),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(child: _buildStepCard("1. Kosongkan", "Buang isi tersisa", Icons.remove_circle_outline)),
            Expanded(child: _buildStepCard("2. Bilas", "Bersihkan kotoran", Icons.water_drop_outlined)),
            Expanded(child: _buildStepCard("3. Keringkan", "Cegah bau & jamur", Icons.wb_sunny_outlined)),
          ],
        ),
        const SizedBox(height: 30),

        const Text("Peringatan: Sampah Khusus ⚠️", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red)),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(color: Colors.red.withOpacity(0.1), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.red.withOpacity(0.3))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Contoh: Baterai, lampu rusak, kaca pecah, dan kemasan bahan kimia.", style: TextStyle(fontSize: 13)),
              const Divider(color: Colors.red),
              const Text("ATURAN 3J:", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
              const SizedBox(height: 5),
              _buildBulletList("JANGAN sentuh langsung bila berbahaya."),
              _buildBulletList("JANGAN campur dengan sampah biasa."),
              _buildBulletList("JELASKAN kepada pengelola/pendamping."),
            ],
          ),
        ),
      ],
    );
  }

  // ==========================================
  // TAB 3: PRINSIP 3R
  // ==========================================
  Widget _buildTab3R() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _buildHeaderCard(
          title: "Prinsip Utama 3R",
          desc: "Urutan langkah bijak dalam mengelola sampah. Ingat urutannya: Kurangi → Gunakan Kembali → Daur Ulang.",
          color: const Color(0xFF00796B),
          icon: Icons.sync,
        ),
        const SizedBox(height: 20),

        _build3RCard(
          title: "1. Reduce (Kurangi)",
          desc: "Kurangi produksi sampah sejak awal. Contoh: Membawa botol minum sendiri dan mengambil makanan secukupnya agar tidak bersisa.",
          icon: Icons.trending_down,
          color: const Color(0xFF43A047),
        ),
        const SizedBox(height: 15),

        _build3RCard(
          title: "2. Reuse (Gunakan Kembali)",
          desc: "Pakai kembali barang yang masih layak. Contoh: Menggunakan sisi kosong pada kertas bekas atau memakai ulang wadah plastik yang masih baik.",
          icon: Icons.repeat,
          color: const Color(0xFFF57C00),
        ),
        const SizedBox(height: 15),

        _build3RCard(
          title: "3. Recycle (Daur Ulang)",
          desc: "Ubah sampah menjadi barang baru. Contoh: Memilah botol plastik, kertas, dan kaleng untuk diserahkan ke bank sampah atau pengolah daur ulang.",
          icon: Icons.recycling,
          color: const Color(0xFF1976D2),
        ),
      ],
    );
  }

  // ==========================================
  // WIDGET PEMBANTU (MENGHEMAT KODE)
  // ==========================================

  Widget _buildHeaderCard({required String title, required String desc, required Color color, required IconData icon}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(15)),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 40),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
                const SizedBox(height: 5),
                Text(desc, style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.4)),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildChip(String label, IconData icon) {
    return Chip(
      avatar: Icon(icon, size: 16, color: const Color(0xFF5D4037)),
      label: Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF5D4037))),
      backgroundColor: const Color(0xFFD4A017).withOpacity(0.2),
      side: BorderSide.none,
    );
  }

  Widget _buildInfoBox({required String title, required List<String> items, required Color color}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withOpacity(0.5))
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 13)),
          const SizedBox(height: 10),
          ...items.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.circle, size: 6, color: color).paddingTop(),
                const SizedBox(width: 8),
                Expanded(child: Text(item, style: const TextStyle(fontSize: 12, height: 1.3))),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildStepCard(String title, String desc, IconData icon) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), side: BorderSide(color: Colors.grey.shade300)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 5),
        child: Column(
          children: [
            Icon(icon, color: const Color(0xFF1976D2)),
            const SizedBox(height: 5),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11), textAlign: TextAlign.center),
            Text(desc, style: const TextStyle(fontSize: 10, color: Colors.grey), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget _buildBulletList(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("• ", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 13, color: Colors.black87))),
        ],
      ),
    );
  }

  Widget _build3RCard({required String title, required String desc, required IconData icon, required Color color}) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5, offset: const Offset(0, 3))]
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: color)),
                const SizedBox(height: 5),
                Text(desc, style: TextStyle(fontSize: 13, color: Colors.grey[700], height: 1.4)),
              ],
            ),
          )
        ],
      ),
    );
  }
}

// Extension pembantu untuk merapikan posisi dot pada bullet list
extension WidgetPadding on Widget {
  Widget paddingTop() {
    return Padding(padding: const EdgeInsets.only(top: 4), child: this);
  }
}