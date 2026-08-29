import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Mengambil data user saat ini
  User? user = FirebaseAuth.instance.currentUser;

  // ==== FUNGSI EDIT PROFIL ====
  Future<void> _editProfil(BuildContext context) async {
    TextEditingController nameController = TextEditingController(text: user?.displayName ?? "");

    bool? save = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: const Text("Edit Profil", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1B4332))),
          content: TextField(
            controller: nameController,
            decoration: InputDecoration(
              labelText: "Nama Lengkap",
              prefixIcon: const Icon(Icons.person_outline, color: Color(0xFF1B4332)),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFF1B4332), width: 2),
              ),
            ),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text("Batal", style: TextStyle(color: Colors.grey))
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1B4332)),
              onPressed: () => Navigator.pop(context, true),
              child: const Text("Simpan", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );

    if (save == true && nameController.text.isNotEmpty) {
      try {
        await user?.updateDisplayName(nameController.text.trim());
        await user?.reload();

        setState(() {
          user = FirebaseAuth.instance.currentUser;
        });

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Profil berhasil diperbarui! ✅"), backgroundColor: Color(0xFF43A047)));
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Gagal memperbarui profil."), backgroundColor: Colors.red));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    String namaTampilan = user?.displayName ?? "";
    if (namaTampilan.isEmpty) namaTampilan = "Warga Komposter";

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Profil Saya', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: const Color(0xFF1B4332),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))],
            ),
            child: Column(
              children: [
                CircleAvatar(
                    radius: 45,
                    backgroundColor: const Color(0xFF1B4332).withOpacity(0.1),
                    child: const Icon(Icons.person, size: 50, color: Color(0xFF1B4332))
                ),
                const SizedBox(height: 15),
                Text(namaTampilan, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Color(0xFF1B4332))),
                const SizedBox(height: 5),
                Text(user?.email ?? "Email tidak tersedia", style: const TextStyle(fontSize: 14, color: Colors.grey)),
                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD4A017),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(vertical: 12)
                    ),
                    icon: const Icon(Icons.edit_outlined, color: Colors.white, size: 18),
                    label: const Text("Edit Profil", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    onPressed: () => _editProfil(context),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}