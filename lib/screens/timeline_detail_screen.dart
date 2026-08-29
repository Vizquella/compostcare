import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';

class TimelineDetailScreen extends StatefulWidget {
  final String namaKompos;
  final DateTime tanggalMulai;
  final double beratInput;
  final double estimasiPadat;
  final double estimasiCair;

  const TimelineDetailScreen({
    super.key,
    required this.namaKompos,
    required this.tanggalMulai,
    required this.beratInput,
    required this.estimasiPadat,
    required this.estimasiCair,
  });

  @override
  State<TimelineDetailScreen> createState() => _TimelineDetailScreenState();
}

class _TimelineDetailScreenState extends State<TimelineDetailScreen> {
  // ========================================================
  // VARIABEL STATE UNTUK GAMBAR DAN TEKS
  // ========================================================
  File? _imageFile;
  final TextEditingController _catatanController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  // ========================================================
  // FUNGSI MENGAMBIL GAMBAR DARI KAMERA / GALERI
  // ========================================================
  Future<void> _pickImage(ImageSource source, StateSetter updateModalState) async {
    final XFile? pickedFile = await _picker.pickImage(
      source: source,
      imageQuality: 50, // Kompres gambar agar ringan di memori
    );

    if (pickedFile != null) {
      updateModalState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  // ========================================================
  // FUNGSI MENAMPILKAN POP-UP FORM LAPORAN
  // ========================================================
  void _tampilkanFormLaporan(BuildContext context, String hari) {
    // Reset form setiap kali dibuka
    _imageFile = null;
    _catatanController.clear();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter updateModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 20,
                right: 20,
                top: 25,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Laporan Kompos - $hari", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1B4332))),
                  const SizedBox(height: 15),

                  // 1. INPUT GAMBAR (KOTAK FOTO)
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text("Pilih Sumber Foto", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                leading: const Icon(Icons.camera_alt, color: Color(0xFF1B4332)),
                                title: const Text("Kamera"),
                                onTap: () {
                                  Navigator.pop(context);
                                  _pickImage(ImageSource.camera, updateModalState);
                                },
                              ),
                              ListTile(
                                leading: const Icon(Icons.photo_library, color: Color(0xFF1B4332)),
                                title: const Text("Galeri"),
                                onTap: () {
                                  Navigator.pop(context);
                                  _pickImage(ImageSource.gallery, updateModalState);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    child: Container(
                      height: 150,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.grey.shade400, style: BorderStyle.solid),
                      ),
                      child: _imageFile != null
                          ? ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.file(_imageFile!, fit: BoxFit.cover),
                      )
                          : const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_a_photo, size: 40, color: Colors.grey),
                          SizedBox(height: 8),
                          Text("Tap untuk tambah foto kondisi kompos", style: TextStyle(color: Colors.grey, fontSize: 12)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 2. INPUT TEKS (CATATAN)
                  TextField(
                    controller: _catatanController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: "Contoh: Suhu mulai hangat, bau tidak menyengat...",
                      hintStyle: const TextStyle(fontSize: 13, color: Colors.grey),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(color: Color(0xFF1B4332), width: 2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 3. TOMBOL SIMPAN
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1B4332),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      ),
                      onPressed: () async {
                        // Tutup keyboard
                        FocusScope.of(context).unfocus();

                        // Validasi sederhana
                        if (_imageFile == null && _catatanController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Harap isi foto atau catatan!")));
                          return;
                        }

                        // Tampilkan dialog loading
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) => const Center(child: CircularProgressIndicator(color: Colors.white)),
                        );

                        try {
                          String base64Image = '';
                          final user = FirebaseAuth.instance.currentUser;

                          // 1. UBAH GAMBAR JADI TEKS (BASE64) - TANPA FIREBASE STORAGE!
                          if (_imageFile != null) {
                            // Baca file gambar sebagai byte data
                            final bytes = await _imageFile!.readAsBytes();
                            // Ubah byte data menjadi string teks (Base64)
                            base64Image = base64Encode(bytes);
                          }

                          // 2. Simpan Data (Teks Catatan + Teks Gambar) langsung ke Firestore Database
                          await FirebaseFirestore.instance.collection('laporan_kompos').add({
                            'uid': user?.uid,
                            'email': user?.email,
                            'hari': hari,
                            'catatan': _catatanController.text.trim(),
                            'imageBase64': base64Image, // <--- Menyimpan gambar dalam bentuk teks
                            'timestamp': FieldValue.serverTimestamp(),
                          });

                          // Tutup loading dan pop-up
                          if (context.mounted) {
                            Navigator.pop(context); // Tutup loading
                            Navigator.pop(context); // Tutup form laporan
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Laporan berhasil dikirim ke Admin! ✅"), backgroundColor: Color(0xFF43A047)));
                          }
                        } catch (e) {
                          if (context.mounted) {
                            Navigator.pop(context); // Tutup loading
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Gagal mengirim laporan: $e")));
                          }
                        }
                      },
                      child: const Text("Kirim Laporan", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // ========================================================
  // TAMPILAN UTAMA (BUILD)
  // ========================================================
  @override
  Widget build(BuildContext context) {
    // Menghitung selisih hari dengan merujuk ke widget.tanggalMulai (karena stateful)
    final int daysPassed = DateTime.now().difference(widget.tanggalMulai).inDays;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text(widget.namaKompos, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: const Color(0xFF1B4332),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Kartu Estimasi Hasil Panen
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Estimasi Hasil Panen (Ember Tumpuk)", style: TextStyle(color: Colors.white70, fontSize: 14)),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildEstimasiItem(Icons.eco, "Bahan Awal", "${widget.beratInput} Kg"),
                    Container(height: 40, width: 1, color: Colors.white30),
                    _buildEstimasiItem(Icons.layers, "Pupuk Padat", "${widget.estimasiPadat} Kg"),
                    Container(height: 40, width: 1, color: Colors.white30),
                    _buildEstimasiItem(Icons.water_drop, "Pupuk Cair", "${widget.estimasiCair} L"),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Kartu Status Hari
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1B4332).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.timer, color: Color(0xFF1B4332)),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "Berjalan: Hari ke-${daysPassed + 1}. Kami akan mengingatkanmu secara otomatis!",
                    style: const TextStyle(color: Color(0xFF1B4332), fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),

          // Daftar Timeline
          _buildTimelineTile(
            context: context,
            day: "Hari 1",
            title: "Awal Pembuatan",
            desc: "Masukkan bahan-bahan organik dan bioaktivator ke dalam ember",
            isCompleted: daysPassed >= 0,
            isLast: false,
          ),
          _buildTimelineTile(
            context: context,
            day: "Hari 3",
            title: "Aduk Pertama",
            desc: "Balik kompos agar oksigen masuk. Cek apakah ada cairan turun ke ember bawah.",
            isCompleted: daysPassed >= 2,
            isLast: false,
          ),
          _buildTimelineTile(
            context: context,
            day: "Hari 7",
            title: "Cek Suhu & Lindi",
            desc: "Kompos terasa hangat. Cek ember bawah, buka keran jika pupuk cair (lindi) sudah menggenang.",
            isCompleted: daysPassed >= 6,
            isLast: false,
          ),
          _buildTimelineTile(
            context: context,
            day: "Hari 14",
            title: "Aduk Berkala",
            desc: "Proses penguraian sedang aktif. Warnanya mulai menghitam dan menyusut.",
            isCompleted: daysPassed >= 13,
            isLast: false,
          ),
          _buildTimelineTile(
            context: context,
            day: "Hari 30",
            title: "Panen Kompos & POC! 🌿",
            desc: "Pupuk padat siap di ember atas, dan sisa pupuk organik cair (POC) siap dipanen di ember bawah.",
            isCompleted: daysPassed >= 29,
            isLast: true,
          ),
        ],
      ),
    );
  }

  // ==== WIDGET PEMBANTU: IKON ESTIMASI ====
  Widget _buildEstimasiItem(IconData icon, String title, String value) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFFD4A017), size: 24),
        const SizedBox(height: 5),
        Text(title, style: const TextStyle(color: Colors.white70, fontSize: 12)),
        Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
      ],
    );
  }

  // ==== WIDGET PEMBANTU: CETAKAN KARTU TIMELINE ====
  Widget _buildTimelineTile({
    required BuildContext context,
    required String day,
    required String title,
    required String desc,
    required bool isCompleted,
    required bool isLast
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Garis dan titik di sebelah kiri
          Column(
            children: [
              Container(
                width: 30, height: 30,
                decoration: BoxDecoration(
                    color: isCompleted ? const Color(0xFF1B4332) : Colors.grey[300],
                    shape: BoxShape.circle
                ),
                child: isCompleted
                    ? const Icon(Icons.check, color: Colors.white, size: 18)
                    : const Icon(Icons.circle, color: Colors.white, size: 12),
              ),
              if (!isLast)
                Expanded(
                    child: Container(
                        width: 3,
                        color: isCompleted ? const Color(0xFF1B4332) : Colors.grey[300]
                    )
                ),
            ],
          ),
          const SizedBox(width: 15),

          // Konten Kartu Timeline
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      day,
                      style: TextStyle(color: isCompleted ? const Color(0xFFD4A017) : Colors.grey, fontWeight: FontWeight.bold)
                  ),
                  const SizedBox(height: 5),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5, offset: const Offset(0, 3))
                        ],
                        border: Border.all(color: isCompleted ? const Color(0xFF1B4332).withOpacity(0.3) : Colors.transparent)
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 5),
                        Text(desc, style: TextStyle(color: Colors.grey[600], fontSize: 13)),

                        const SizedBox(height: 12),

                        // BARISAN TOMBOL
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            // Tombol Diagnostik Khusus Hari 7 dan 14
                            if (day == "Hari 7" || day == "Hari 14")
                              OutlinedButton.icon(
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: const Color(0xFF1B4332),
                                  side: const BorderSide(color: Color(0xFF1B4332)),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                icon: const Icon(Icons.quiz_outlined, size: 16),
                                label: const Text("Panduan Cek Kondisi", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                onPressed: () => _tampilkanDialogDiagnostik(context),
                              ),

                            // Tombol Input Laporan Gambar & Teks (Ada di setiap hari)
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFD4A017),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                elevation: 0,
                              ),
                              icon: const Icon(Icons.add_a_photo, size: 16, color: Colors.white),
                              label: const Text("Buat Laporan", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
                              onPressed: () => _tampilkanFormLaporan(context, day),
                            ),
                          ],
                        ),

                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==== FUNGSI LOGIKA: POP-UP DIAGNOSTIK ====
  void _tampilkanDialogDiagnostik(BuildContext context) {
    int? jawabanBau;
    int? jawabanPanas;
    int? jawabanKering;
    String? saranSolusi;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: const Row(
                children: [
                  Icon(Icons.health_and_safety, color: Color(0xFF1B4332)),
                  SizedBox(width: 10),
                  Text("Cek Kondisi Kompos", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Jawab pertanyaan berikut untuk mengecek kondisi ember komposmu:", style: TextStyle(fontSize: 13, color: Colors.grey)),
                    const SizedBox(height: 15),

                    // Pertanyaan 1: Bau
                    const Text("1. Apakah kompos berbau busuk menyengat?", style: TextStyle(fontWeight: FontWeight.bold)),
                    Row(
                      children: [
                        Expanded(
                          child: RadioListTile<int>(
                            title: const Text("Ya", style: TextStyle(fontSize: 14)),
                            value: 1,
                            groupValue: jawabanBau,
                            onChanged: (val) => setStateDialog(() => jawabanBau = val),
                          ),
                        ),
                        Expanded(
                          child: RadioListTile<int>(
                            title: const Text("Tidak", style: TextStyle(fontSize: 14)),
                            value: 0,
                            groupValue: jawabanBau,
                            onChanged: (val) => setStateDialog(() => jawabanBau = val),
                          ),
                        ),
                      ],
                    ),

                    // Pertanyaan 2: Suhu
                    const Text("2. Apakah kompos terasa hangat/panas?", style: TextStyle(fontWeight: FontWeight.bold)),
                    Row(
                      children: [
                        Expanded(
                          child: RadioListTile<int>(
                            title: const Text("Ya", style: TextStyle(fontSize: 14)),
                            value: 1,
                            groupValue: jawabanPanas,
                            onChanged: (val) => setStateDialog(() => jawabanPanas = val),
                          ),
                        ),
                        Expanded(
                          child: RadioListTile<int>(
                            title: const Text("Tidak", style: TextStyle(fontSize: 14)),
                            value: 0,
                            groupValue: jawabanPanas,
                            onChanged: (val) => setStateDialog(() => jawabanPanas = val),
                          ),
                        ),
                      ],
                    ),

                    // Pertanyaan 3: Kelembapan
                    const Text("3. Apakah kompos terlihat sangat kering?", style: TextStyle(fontWeight: FontWeight.bold)),
                    Row(
                      children: [
                        Expanded(
                          child: RadioListTile<int>(
                            title: const Text("Ya", style: TextStyle(fontSize: 14)),
                            value: 1,
                            groupValue: jawabanKering,
                            onChanged: (val) => setStateDialog(() => jawabanKering = val),
                          ),
                        ),
                        Expanded(
                          child: RadioListTile<int>(
                            title: const Text("Tidak", style: TextStyle(fontSize: 14)),
                            value: 0,
                            groupValue: jawabanKering,
                            onChanged: (val) => setStateDialog(() => jawabanKering = val),
                          ),
                        ),
                      ],
                    ),

                    // Kotak Hasil Diagnostik
                    if (saranSolusi != null) ...[
                      const SizedBox(height: 15),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFD4A017).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFFD4A017)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("💡 Rekomendasi Penanganan:", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF5D4037))),
                            const SizedBox(height: 5),
                            Text(saranSolusi!, style: const TextStyle(fontSize: 13, height: 1.4)),
                          ],
                        ),
                      ),
                    ]
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Tutup", style: TextStyle(color: Colors.grey)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1B4332)),
                  onPressed: () {
                    List<String> hasil = [];

                    if (jawabanBau == 1) {
                      hasil.add("• Bau Busuk: Kompos terlalu basah/kurang udara. Tambahkan daun kering/serbuk gergaji dan aduk rata.");
                    }
                    if (jawabanPanas == 0) {
                      hasil.add("• Kurang Hangat: Mikroba belum aktif. Tambahkan sisa kulit buah manis/sayuran hijau segar lalu siram sedikit air.");
                    }
                    if (jawabanKering == 1) {
                      hasil.add("• Terlalu Kering: Percikkan air cucian beras atau EM4 hingga lembap seperti spons pencuci piring.");
                    }
                    if (jawabanBau == 0 && jawabanPanas == 1 && jawabanKering == 0) {
                      hasil.add("✅ Kondisi Kompos Bagus! Proses penguraian berjalan optimal. Lanjutkan pengadukan sesuai jadwal.");
                    }

                    if (hasil.isEmpty) {
                      setStateDialog(() {
                        saranSolusi = "Silakan jawab pertanyaan di atas terlebih dahulu.";
                      });
                    } else {
                      setStateDialog(() {
                        saranSolusi = hasil.join("\n\n");
                      });
                    }
                  },
                  child: const Text("Cek Analisis", style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        );
      },
    );
  }
}