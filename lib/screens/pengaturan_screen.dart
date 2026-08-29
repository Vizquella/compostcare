  import 'package:flutter/material.dart';
  import 'package:shared_preferences/shared_preferences.dart';
  import 'package:firebase_auth/firebase_auth.dart';
  import '../services/notification_service.dart';
  import 'profile_screen.dart'; // <--- Import file profil

  class PengaturanScreen extends StatelessWidget {
    const PengaturanScreen({super.key});

    // ==== FUNGSI LOGOUT (KELUAR AKUN) ====
    Future<void> _logout(BuildContext context) async {
      bool? confirm = await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Keluar Akun", style: TextStyle(fontWeight: FontWeight.bold)),
          content: const Text("Apakah kamu yakin ingin keluar dari aplikasi?"),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Batal", style: TextStyle(color: Colors.grey))),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () => Navigator.pop(context, true),
              child: const Text("Keluar", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );

      if (confirm == true) {
        if (context.mounted) Navigator.of(context).popUntil((route) => route.isFirst);
        await FirebaseAuth.instance.signOut(); // Firebase akan melempar user ke halaman Login
      }
    }

    // ==== FUNGSI RESET DATA ====
    Future<void> _konfirmasiResetData(BuildContext context) async {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            title: const Row(
              children: [
                Icon(Icons.warning_amber_rounded, color: Colors.red),
                SizedBox(width: 10),
                Text("Reset Semua Data?", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            content: const Text("Tindakan ini akan menghapus semua daftar kompos dan catatan harianmu. Data yang dihapus tidak dapat dikembalikan!", style: TextStyle(fontSize: 14)),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text("Batal", style: TextStyle(color: Colors.grey))),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () async {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.clear();
                  if (context.mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Semua data berhasil direset! 🗑️"), backgroundColor: Colors.redAccent));
                  }
                },
                child: const Text("Ya, Hapus Data", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ],
          );
        },
      );
    }

    // ==== FUNGSI TENTANG KKN ====
    void _tampilkanTentangKKN(BuildContext context) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            contentPadding: const EdgeInsets.all(25),
            content: SizedBox(
              width: double.maxFinite,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(height: 80, width: 80, decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), image: const DecorationImage(image: AssetImage('assets/logo.png'), fit: BoxFit.cover))),
                    const SizedBox(height: 15),
                    const Text("CompostCare", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1B4332))),
                    const Text("Versi 1.0.0 (Online Mode)", style: TextStyle(color: Colors.grey, fontSize: 12)),
                    const SizedBox(height: 15), const Divider(), const SizedBox(height: 15),

                    // Logo Mitra
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Image.asset('assets/logo_unmul.png', height: 45, fit: BoxFit.contain),
                        Image.asset('assets/logo_kkn.png', height: 45, fit: BoxFit.contain),
                        Image.asset('assets/logo_pertamina.png', height: 45, fit: BoxFit.contain),
                      ],
                    ),
                    const SizedBox(height: 20),

                    const Text("Aplikasi ini dikembangkan sebagai bagian dari pelaksanaan Program Kerja KKN Bina Desa 2026 Universitas Mulawarman yang bermitra dengan PT Pertamina EP Sangatta - Lapangan Semberah dalam mendukung edukasi pengolahan sampah dan peningkatan kesadaran masyarakat terhadap pengelolaan sampah organik.", textAlign: TextAlign.center, style: TextStyle(fontSize: 12, height: 1.5)),
                    const SizedBox(height: 20),
                    const Text("Dikembangkan oleh:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1B4332))),
                    const SizedBox(height: 5),
                    const Text("KKN Bina Desa Universitas Mulawarman Tahun 2026\nKelompok 1 Desa Batu-Batu, Kec. Muara Badak", textAlign: TextAlign.center, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 15),

                    Container(
                      width: double.infinity, padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.grey.shade300)),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("PJ Program Kerja:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Colors.grey)),
                          Text("Bagus Setianto", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                          SizedBox(height: 10),
                          Text("Anggota Kelompok:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Colors.grey)),
                          Text("• Abdurahman Shidiq\n• Alif Lutfian Rahmayani Rudy\n• Ayu Virnanda\n• Muhammad Kelvin Saputra\n• Putri Tendry Zahrany\n• Saniya Putri\n• Thesa Dian", style: TextStyle(fontSize: 12, height: 1.4)),
                          SizedBox(height: 10),
                          Text("Dosen Pembimbing:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Colors.grey)),
                          Text("Muhammad Rizky Septyandy", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text("Kami mengucapkan terima kasih kepada Universitas Mulawarman, Pertamina EP Sangatta Field selaku mitra Program KKN Bina Desa (Bindes) 2026, dosen pembimbing lapangan, pemerintah desa, serta seluruh masyarakat yang telah memberikan dukungan, kerja sama, dan partisipasi selama pelaksanaan program.", textAlign: TextAlign.center, style: TextStyle(fontSize: 11, fontStyle: FontStyle.italic, color: Colors.grey, height: 1.5)),
                  ],
                ),
              ),
            ),
            actions: [
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1B4332), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), minimumSize: const Size(double.infinity, 45)),
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Tutup", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          );
        },
      );
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        appBar: AppBar(
          title: const Text('Pengaturan', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
          backgroundColor: const Color(0xFF1B4332),
          iconTheme: const IconThemeData(color: Colors.white),
          elevation: 0,
        ),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // KATEGORI 1: AKUN
            const Text("Akun", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 12)),
            const SizedBox(height: 10),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)), elevation: 1,
              child: ListTile(
                leading: const Icon(Icons.person_outline, color: Color(0xFF1B4332)),
                title: const Text("Profil Saya", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileScreen()));
                },
              ),
            ),
            const SizedBox(height: 25),

            // KATEGORI 2: SISTEM & NOTIFIKASI
            const Text("Sistem & Notifikasi", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 12)),
            const SizedBox(height: 10),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)), elevation: 1,
              child: ListTile(
                leading: const Icon(Icons.notifications_active_outlined, color: Color(0xFF1B4332)),
                title: const Text("Tes Notifikasi", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                subtitle: const Text("Uji apakah notifikasi muncul", style: TextStyle(fontSize: 12)),
                trailing: const Icon(Icons.send_outlined, size: 18, color: Colors.grey),
                onTap: () async {
                  await NotificationService().showInstantNotification('🔔 Tes Notifikasi', 'Sistem notifikasi berjalan lancar!');
                  if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Notifikasi dikirim!')));
                },
              ),
            ),
            const SizedBox(height: 25),

            // KATEGORI 3: KELOLA DATA
            const Text("Kelola Data", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 12)),
            const SizedBox(height: 10),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)), elevation: 1,
              child: ListTile(
                leading: const Icon(Icons.delete_forever_outlined, color: Colors.red),
                title: const Text("Reset Data Lokal", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red, fontSize: 15)),
                trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
                onTap: () => _konfirmasiResetData(context), // Pastikan fungsinya sudah disalin
              ),
            ),
            const SizedBox(height: 25),

            // KATEGORI 4: INFORMASI
            const Text("Informasi Akun", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 12)),
            const SizedBox(height: 10),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)), elevation: 1,
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.info_outline, color: Color(0xFF1B4332)),
                    title: const Text("Tentang Aplikasi", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
                    onTap: () => _tampilkanTentangKKN(context), // Pastikan fungsinya sudah disalin
                  ),
                  const Divider(height: 1, indent: 15, endIndent: 15),
                  ListTile(
                    leading: const Icon(Icons.logout, color: Colors.red),
                    title: const Text("Keluar (Logout)", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.red)),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
                    onTap: () => _logout(context), // Pastikan fungsinya sudah disalin
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      );
    }
  }