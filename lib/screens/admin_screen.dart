import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text("Dashboard Admin", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: const Color(0xFF1B4332),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
          )
        ],
      ),
      // StreamBuilder akan terus memantau database secara real-time
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('laporan_kompos')
            .orderBy('timestamp', descending: true) // Urutkan dari yang paling baru
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFF1B4332)));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("Belum ada laporan dari warga.", style: TextStyle(color: Colors.grey)));
          }

          final laporanDocs = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: laporanDocs.length,
            itemBuilder: (context, index) {
              final data = laporanDocs[index].data() as Map<String, dynamic>;

              // Mengambil data dari database
              final String email = data['email'] ?? 'Anonim';
              final String hari = data['hari'] ?? 'Hari ?';
              final String catatan = data['catatan'] ?? '';
              final String imageUrl = data['imageUrl'] ?? '';

              return Card(
                margin: const EdgeInsets.only(bottom: 20),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                clipBehavior: Clip.antiAlias,
                elevation: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Card (Email Pengirim)
                    ListTile(
                      tileColor: const Color(0xFF1B4332).withOpacity(0.05),
                      leading: const CircleAvatar(backgroundColor: Color(0xFF1B4332), child: Icon(Icons.person, color: Colors.white)),
                      title: Text(email, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      subtitle: Text("Laporan $hari", style: const TextStyle(color: Color(0xFFD4A017), fontWeight: FontWeight.bold)),
                    ),

                    // Gambar Laporan (Jika Ada)
                    if (imageUrl.isNotEmpty)
                      Image.network(
                        imageUrl,
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, progress) {
                          if (progress == null) return child;
                          return const SizedBox(height: 200, child: Center(child: CircularProgressIndicator()));
                        },
                        errorBuilder: (context, error, stackTrace) => const SizedBox(height: 100, child: Center(child: Icon(Icons.broken_image, color: Colors.grey, size: 50))),
                      ),

                    // Catatan Teks
                    if (catatan.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: Text('"$catatan"', style: const TextStyle(fontStyle: FontStyle.italic, color: Colors.black87)),
                      ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}