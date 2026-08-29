import 'package:flutter/material.dart';

class LogbookScreen extends StatefulWidget {
  const LogbookScreen({super.key});

  @override
  State<LogbookScreen> createState() => _LogbookScreenState();
}

class _LogbookScreenState extends State<LogbookScreen> {
  // Dataset sementara untuk menyimpan riwayat input pengguna
  final List<Map<String, dynamic>> _logData = [];

  // Fungsi untuk membuka modal form tambah data
  void _tambahCatatanModal(BuildContext context) {
    String selectedSuhu = 'Hangat';
    String selectedKelembapan = 'Pas';
    final TextEditingController tindakanController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Agar modal bisa naik saat keyboard muncul
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 20,
                right: 20,
                top: 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Tambah Catatan Baru",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1B4332)),
                  ),
                  const SizedBox(height: 20),

                  // Input Kategorikal: Suhu
                  const Text("Suhu Kompos:", style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 10,
                    children: ['Dingin', 'Hangat', 'Panas'].map((suhu) {
                      return ChoiceChip(
                        label: Text(suhu),
                        selected: selectedSuhu == suhu,
                        selectedColor: const Color(0xFFD4A017).withOpacity(0.3),
                        onSelected: (bool selected) {
                          setModalState(() {
                            selectedSuhu = suhu;
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),

                  // Input Kategorikal: Kelembapan
                  const Text("Kelembapan:", style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 10,
                    children: ['Kering', 'Pas', 'Basah'].map((lembab) {
                      return ChoiceChip(
                        label: Text(lembab),
                        selected: selectedKelembapan == lembab,
                        selectedColor: const Color(0xFFD4A017).withOpacity(0.3),
                        onSelected: (bool selected) {
                          setModalState(() {
                            selectedKelembapan = lembab;
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),

                  // Input Teks: Tindakan/Catatan
                  const Text("Tindakan yang dilakukan:", style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: tindakanController,
                    decoration: InputDecoration(
                      hintText: "Misal: Mengaduk kompos, tambah air...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF1B4332)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Tombol Simpan
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1B4332),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      onPressed: () {
                        // Memasukkan data ke dalam list (dataset lokal)
                        setState(() {
                          _logData.insert(0, {
                            'tanggal': "Hari ${(_logData.length + 1)}", // Simulasi hari
                            'suhu': selectedSuhu,
                            'kelembapan': selectedKelembapan,
                            'tindakan': tindakanController.text.isNotEmpty ? tindakanController.text : "Tidak ada tindakan khusus",
                            'date_time': DateTime.now(),
                          });
                        });
                        Navigator.pop(context); // Tutup modal
                      },
                      child: const Text("Simpan Catatan", style: TextStyle(color: Colors.white, fontSize: 16)),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Logbook Kompos', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: const Color(0xFF1B4332),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _logData.isEmpty
          ? const Center(
        child: Text(
          "Belum ada catatan.\nMulai cek komposmu hari ini!",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _logData.length,
        itemBuilder: (context, index) {
          final data = _logData[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        data['tanggal'],
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF5D4037)),
                      ),
                      Text(
                        "${data['date_time'].day}/${data['date_time'].month}/${data['date_time'].year}",
                        style: const TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                  const Divider(height: 20, color: Colors.black12),
                  Row(
                    children: [
                      _buildInfoBadge(Icons.thermostat, data['suhu'], Colors.orange),
                      const SizedBox(width: 10),
                      _buildInfoBadge(Icons.water_drop, data['kelembapan'], Colors.blue),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text("Catatan: ${data['tindakan']}", style: const TextStyle(fontStyle: FontStyle.italic)),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _tambahCatatanModal(context),
        backgroundColor: const Color(0xFFD4A017),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text("Catat", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  // Widget bantuan untuk menampilkan label suhu & kelembapan
  Widget _buildInfoBadge(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 4),
          Text(text, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12)),
        ],
      ),
    );
  }
}