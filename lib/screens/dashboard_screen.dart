import 'package:compostcare/screens/panduan_penggunaan.dart';
import 'package:flutter/material.dart';
import 'edukasi_screen.dart';
import 'tutorial_screen.dart';
import 'logbook_screen.dart';
import 'timeline_screen.dart';
import 'profile_screen.dart';
import '../services/notification_service.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  // ==== FUNGSI UNTUK LONCENG NOTIFIKASI ====
  void _tampilkanNotifikasi(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          height: 350,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Pusat Notifikasi", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1B4332))),
              const SizedBox(height: 15),
              Expanded(
                child: ListView(
                  children: [
                    ListTile(
                      leading: const CircleAvatar(backgroundColor: Color(0xFFE8F5E9), child: Icon(Icons.water_drop, color: Color(0xFF2D5A27))),
                      title: const Text("Cek Kelembapan Kompos!"),
                      subtitle: const Text("Sudah hari ke-7, pastikan komposmu tidak terlalu kering.", style: TextStyle(fontSize: 12)),
                      trailing: const Text("Hari ini", style: TextStyle(fontSize: 10, color: Colors.grey)),
                    ),
                    const Divider(),
                    ListTile(
                      leading: const CircleAvatar(backgroundColor: Color(0xFFFFF8E1), child: Icon(Icons.wb_sunny, color: Color(0xFFD4A017))),
                      title: const Text("Aduk Komposmu"),
                      subtitle: const Text("Jangan lupa mengaduk kompos agar oksigen masuk dengan merata.", style: TextStyle(fontSize: 12)),
                      trailing: const Text("Kemarin", style: TextStyle(fontSize: 10, color: Colors.grey)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),

      // ==========================================
      // APPBAR MINIMALIS DENGAN TOMBOL PROFIL
      // ==========================================
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B4332),
        elevation: 0.5,
        titleSpacing: 20,
        title: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                'assets/logo.png',
                height: 30,
                width: 30,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.eco, color: Color(0xFF1B4332), size: 30),
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              "CompostCare",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        actions: [
          // 1. Ikon Lonceng Notifikasi
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded, color: Colors.white, size: 26),
            onPressed: () => _tampilkanNotifikasi(context),
          ),

          // 2. Tombol Profil (Akses Cepat ke Profile Screen)
          Padding(
            padding: const EdgeInsets.only(right: 15, left: 5),
            child: GestureDetector(
              onTap: () {
                // Mengarahkan ke ProfileScreen
                Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileScreen()));
              },
              child: CircleAvatar(
                radius: 16,
                backgroundColor: Colors.white.withOpacity(0.2),
                child: const Icon(Icons.person, size: 20, color: Colors.white),
              ),
            ),
          ),
        ],
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            "Halo, Komposter! 🌿",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF5D4037)),
          ),
          const SizedBox(height: 4),
          const Text(
            "Mari olah sampah organikmu hari ini.",
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),
          const SizedBox(height: 25),

          _buildMainCard(context, title: "Apa Itu Ember Komposter?", subtitle: "Cara membuat ember komposter sendiri", icon: Icons.auto_stories, color: const Color(0xFF1B4332), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const TutorialScreen()))),
          const SizedBox(height: 15),

          _buildMainCard(context, title: "Kenali dan pilah sampah", subtitle: "Panduan pemilahan sampah", icon: Icons.recycling, color: const Color(0xFF2D5A27), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const EdukasiScreen()))),
          const SizedBox(height: 15),

          _buildMainCard(context, title: "Penggunaan Ember Kompos", subtitle: "Panduan penggunaan ember kompos yang baik", icon: Icons.oil_barrel, color: const Color(0xFF2D5A27), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const PanduanPenggunaanScreen()))),
          const SizedBox(height: 15),

          _buildMainCard(context, title: "Buat Kompos", subtitle: "Mulai dan pantau proses pengomposanmu", icon: Icons.compost, color: const Color(0xFFD4A017), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const TimelineScreen()))),
          const SizedBox(height: 15),

          _buildMainCard(context, title: "Catatan Harian", subtitle: "Buat catatan tentang komposmu", icon: Icons.edit_document, color: const Color(0xFF5D4037), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const LogbookScreen()))),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildMainCard(BuildContext context, {required String title, required String subtitle, required IconData icon, required Color color, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))]),
        child: Row(
          children: [
            Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(15)), child: Icon(icon, color: color, size: 30)),
            const SizedBox(width: 20),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Color(0xFF5D4037))), const SizedBox(height: 4), Text(subtitle, style: TextStyle(color: Colors.grey[600], fontSize: 13))])),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}