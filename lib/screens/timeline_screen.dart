import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/notification_service.dart';
import 'timeline_detail_screen.dart';

class TimelineScreen extends StatefulWidget {
  const TimelineScreen({super.key});

  @override
  State<TimelineScreen> createState() => _TimelineScreenState();
}

class _TimelineScreenState extends State<TimelineScreen> {
  List<Map<String, dynamic>> _daftarKompos = [];

  @override
  void initState() {
    super.initState();
    _loadDaftarKompos();
  }

  Future<void> _loadDaftarKompos() async {
    final prefs = await SharedPreferences.getInstance();
    final String? dataString = prefs.getString('daftar_kompos');
    if (dataString != null) {
      final List<dynamic> decodedData = json.decode(dataString);
      setState(() {
        _daftarKompos = decodedData.map((e) => e as Map<String, dynamic>).toList();
      });
    }
  }

  Future<void> _saveDaftarKompos() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('daftar_kompos', json.encode(_daftarKompos));
  }

  // ==== FUNGSI BARU: POP-UP FORMULIR ====
  // ==== FUNGSI POP-UP FORMULIR DENGAN VALIDASI ====
  void _tampilkanFormTambahKompos() {
    final TextEditingController namaController = TextEditingController(text: "Ember Kompos ${_daftarKompos.length + 1}");
    final TextEditingController beratController = TextEditingController();

    // Variabel untuk menyimpan pesan error
    String? pesanError;

    showDialog(
      context: context,
      builder: (context) {
        // Gunakan StatefulBuilder agar pop-up bisa memunculkan teks error secara real-time
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              title: const Text('Mulai Kompos Baru', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1B4332))),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: namaController,
                    decoration: InputDecoration(
                      labelText: 'Nama / Lokasi Ember',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      prefixIcon: const Icon(Icons.eco),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: beratController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true), // Keyboard khusus angka & desimal
                    decoration: InputDecoration(
                      labelText: 'Berat Bahan Masuk (Kg)',
                      hintText: 'Misal: 5 atau 2.5',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      prefixIcon: const Icon(Icons.scale),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Tampilkan pesan error berwarna merah jika input salah
                  if (pesanError != null) ...[
                    Text(
                      pesanError!,
                      style: const TextStyle(color: Colors.redAccent, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                  ],

                  const Text(
                    "*Estimasi: Kompos menyusut 50% untuk pupuk padat & menghasilkan 10% cairan Lindi (POC).",
                    style: TextStyle(fontSize: 11, color: Colors.grey, fontStyle: FontStyle.italic),
                  )
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Batal', style: TextStyle(color: Colors.grey)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD4A017)),
                  onPressed: () {
                    final nama = namaController.text.trim();
                    final beratTeks = beratController.text.trim().replaceAll(',', '.'); // Ganti koma jadi titik untuk desimal

                    // ==== LOGIKA VALIDASI ====
                    if (nama.isEmpty) {
                      setStateDialog(() {
                        pesanError = "⚠️ Nama ember tidak boleh kosong!";
                      });
                      return; // Stop proses
                    }

                    if (beratTeks.isEmpty) {
                      setStateDialog(() {
                        pesanError = "⚠️ Berat bahan wajib diisi!";
                      });
                      return; // Stop proses
                    }

                    // Cek apakah input benar-benar angka dan lebih dari 0
                    final double? beratAngka = double.tryParse(beratTeks);
                    if (beratAngka == null || beratAngka <= 0) {
                      setStateDialog(() {
                        pesanError = "⚠️ Masukkan angka berat yang valid (misal: 5 atau 2.5)!";
                      });
                      return; // Stop proses
                    }

                    // Jika semua valid, bersihkan error, simpan data, lalu tutup pop-up
                    setStateDialog(() {
                      pesanError = null;
                    });

                    _simpanKomposBaru(nama, beratAngka);
                    Navigator.pop(context);
                  },
                  child: const Text('Mulai Proses', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // ==== FUNGSI SIMPAN SETELAH FORMULIR DIISI ====
  Future<void> _simpanKomposBaru(String nama, double beratInput) async {
    final now = DateTime.now();
    final int baseNotifId = now.millisecondsSinceEpoch.remainder(100000);

    // Hitung Estimasi
    double estimasiPadat = beratInput * 0.5; // 50% dari bahan awal
    double estimasiCair = beratInput * 0.1;  // 10% jadi cairan (liter)

    setState(() {
      _daftarKompos.insert(0, {
        'nama': nama,
        'tanggal_mulai': now.toIso8601String(),
        'base_notif_id': baseNotifId,
        'berat_input': beratInput,
        'estimasi_padat': estimasiPadat,
        'estimasi_cair': estimasiCair,
      });
    });

    await _saveDaftarKompos();

    // Jadwalkan Notifikasi
    await NotificationService().scheduleNotification(id: baseNotifId + 1, title: "🌿 Waktunya Aduk $nama!", body: "Sudah Hari ke-3. Buka keran bawah jika ada lindi.", scheduledDate: now.add(const Duration(days: 3)));
    await NotificationService().scheduleNotification(id: baseNotifId + 2, title: "🌡️ Cek Suhu $nama", body: "Hari ke-7: Seharusnya kompos hangat. Cek ember bawah untuk POC.", scheduledDate: now.add(const Duration(days: 7)));
    await NotificationService().scheduleNotification(id: baseNotifId + 3, title: "🔄 Aduk Berkala $nama", body: "Hari ke-14: Proses penguraian aktif. Aduk ember atas!", scheduledDate: now.add(const Duration(days: 14)));
    await NotificationService().scheduleNotification(id: baseNotifId + 4, title: "🎉 Panen $nama!", body: "Hari ke-30: Pupuk padat & cair siap digunakan!", scheduledDate: now.add(const Duration(days: 30)));

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$nama berhasil dibuat! 🌿'), backgroundColor: const Color(0xFF1B4332)));
    }
  }

  Future<void> _hapusKompos(int index) async {
    setState(() => _daftarKompos.removeAt(index));
    await _saveDaftarKompos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Daftar Kompos', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: const Color(0xFF1B4332),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _daftarKompos.isEmpty ? _buildEmptyState() : _buildListView(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _tampilkanFormTambahKompos, // <-- Ubah fungsi yang dipanggil di sini
        backgroundColor: const Color(0xFFD4A017),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text("Kompos Baru", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.layers, size: 100, color: Colors.grey),
            const SizedBox(height: 20),
            const Text("Belum Ada Kompos", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF5D4037))),
            const SizedBox(height: 10),
            const Text("Tekan tombol di bawah untuk memasukkan data Ember Tumpuk pertamamu!", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontSize: 16)),
          ],
        ),
      ),
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _daftarKompos.length,
      itemBuilder: (context, index) {
        final kompos = _daftarKompos[index];
        final tanggalMulai = DateTime.parse(kompos['tanggal_mulai']);
        final daysPassed = DateTime.now().difference(tanggalMulai).inDays;
        final isPanen = daysPassed >= 30;

        // Ambil data berat untuk ditampilkan sekilas di daftar
        final double inputKg = kompos['berat_input'] ?? 0.0;

        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 2,
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            leading: CircleAvatar(
              backgroundColor: isPanen ? Colors.green : const Color(0xFF1B4332).withOpacity(0.1),
              child: Icon(isPanen ? Icons.check_circle : Icons.eco, color: isPanen ? Colors.white : const Color(0xFF1B4332)),
            ),
            title: Text(kompos['nama'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 5),
                Text(isPanen ? "Siap Panen!" : "Berjalan: Hari ke-${daysPassed + 1}", style: TextStyle(color: isPanen ? Colors.green : Colors.grey[700])),
                Text("Bahan: $inputKg Kg", style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
            trailing: IconButton(icon: const Icon(Icons.delete_outline, color: Colors.redAccent), onPressed: () => _hapusKompos(index)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TimelineDetailScreen(
                    namaKompos: kompos['nama'],
                    tanggalMulai: tanggalMulai,
                    beratInput: inputKg,
                    estimasiPadat: kompos['estimasi_padat'] ?? 0.0,
                    estimasiCair: kompos['estimasi_cair'] ?? 0.0,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}