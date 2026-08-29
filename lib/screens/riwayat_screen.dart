import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fl_chart/fl_chart.dart';
import 'timeline_detail_screen.dart';

class RiwayatScreen extends StatefulWidget {
  const RiwayatScreen({super.key});

  @override
  State<RiwayatScreen> createState() => _RiwayatScreenState();
}

class _RiwayatScreenState extends State<RiwayatScreen> {
  List<Map<String, dynamic>> _riwayatKompos = [];

  // Variabel untuk Statistik
  double _totalSampahDiolah = 0.0;
  double _totalEstimasiPOC = 0.0;
  double _totalEstimasiPadat = 0.0;

  // Data untuk Grafik (Bulan 1-12)
  final Map<int, int> _komposPerBulan = {
    1: 0, 2: 0, 3: 0, 4: 0, 5: 0, 6: 0,
    7: 0, 8: 0, 9: 0, 10: 0, 11: 0, 12: 0
  };

  @override
  void initState() {
    super.initState();
    _loadRiwayatData();
  }

  Future<void> _loadRiwayatData() async {
    final prefs = await SharedPreferences.getInstance();
    final String? dataString = prefs.getString('daftar_kompos');

    if (dataString != null) {
      final List<dynamic> decodedData = json.decode(dataString);
      double tempSampah = 0;
      double tempPOC = 0;
      double tempPadat = 0;

      for (var item in decodedData) {
        final Map<String, dynamic> kompos = item as Map<String, dynamic>;
        _riwayatKompos.add(kompos);

        // Hitung Total Dampak
        tempSampah += (kompos['berat_input'] ?? 0.0);
        tempPOC += (kompos['estimasi_cair'] ?? 0.0);
        tempPadat += (kompos['estimasi_padat'] ?? 0.0);

        // Ekstrak Bulan untuk Grafik
        DateTime tanggal = DateTime.parse(kompos['tanggal_mulai']);
        _komposPerBulan[tanggal.month] = (_komposPerBulan[tanggal.month] ?? 0) + 1;
      }

      setState(() {
        _totalSampahDiolah = tempSampah;
        _totalEstimasiPOC = tempPOC;
        _totalEstimasiPadat = tempPadat;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Riwayat & Statistik', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: const Color(0xFF1B4332),
        elevation: 0,
      ),
      body: _riwayatKompos.isEmpty ? _buildEmptyState() : _buildDataView(),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history_toggle_off, size: 80, color: Colors.grey),
          SizedBox(height: 15),
          Text("Belum Ada Riwayat", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF5D4037))),
          Text("Data akan muncul setelah kamu membuat kompos.", style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildDataView() {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Dampak Lingkunganmu 🌍", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF5D4037))),
                const SizedBox(height: 15),
                // Kartu Statistik Total
                Row(
                  children: [
                    Expanded(child: _buildStatCard("Sampah Diolah", "${_totalSampahDiolah.toStringAsFixed(1)} Kg", Icons.delete_sweep, Colors.red[400]!)),
                    const SizedBox(width: 15),
                    Expanded(child: _buildStatCard("Panen Padat", "${_totalEstimasiPadat.toStringAsFixed(1)} Kg", Icons.layers, Colors.brown[400]!)),
                    const SizedBox(width: 15),
                    Expanded(child: _buildStatCard("Panen POC", "${_totalEstimasiPOC.toStringAsFixed(1)} L", Icons.water_drop, Colors.blue[400]!)),
                  ],
                ),
                const SizedBox(height: 30),

                const Text("Frekuensi Pembuatan (Tahun Ini)", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF5D4037))),
                const SizedBox(height: 20),

                // Grafik Batang
                Container(
                  height: 200,
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))],
                  ),
                  child: _buildChart(),
                ),
                const SizedBox(height: 30),

                const Text("Detail Riwayat", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF5D4037))),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),

        // Daftar Riwayat (List Ember)
        SliverList(
          delegate: SliverChildBuilderDelegate(
                (context, index) {
              final kompos = _riwayatKompos[index];
              final tanggal = DateTime.parse(kompos['tanggal_mulai']);
              final String formatTanggal = "${tanggal.day}/${tanggal.month}/${tanggal.year}";

              final int daysPassed = DateTime.now().difference(tanggal).inDays;
              final bool isPanen = daysPassed >= 30;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 1,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: isPanen ? Colors.green.withOpacity(0.2) : const Color(0xFFD4A017).withOpacity(0.2),
                      child: Icon(isPanen ? Icons.check_circle : Icons.sync, color: isPanen ? Colors.green : const Color(0xFFD4A017)),
                    ),
                    title: Text(kompos['nama'], style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text("Mulai: $formatTanggal • Bahan: ${kompos['berat_input']} Kg"),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) => TimelineDetailScreen(
                          namaKompos: kompos['nama'],
                          tanggalMulai: tanggal,
                          beratInput: kompos['berat_input'] ?? 0.0,
                          estimasiPadat: kompos['estimasi_padat'] ?? 0.0,
                          estimasiCair: kompos['estimasi_cair'] ?? 0.0,
                        ),
                      ));
                    },
                  ),
                ),
              );
            },
            childCount: _riwayatKompos.length,
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 80)),
      ],
    );
  }

  // Widget Pembuat Kartu Statistik
  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: color.withOpacity(0.3)),
        boxShadow: [BoxShadow(color: color.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 4),
          Text(title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        ],
      ),
    );
  }

  // Widget Pembuat Grafik Batang menggunakan fl_chart
  Widget _buildChart() {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        barTouchData: BarTouchData(enabled: false),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (double value, TitleMeta meta) {
                const style = TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 10);
                // Nama Bulan
                List<String> bulan = ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Ags', 'Sep', 'Okt', 'Nov', 'Des'];
                Widget text = Text(bulan[value.toInt() - 1], style: style);
                return SideTitleWidget(axisSide: meta.axisSide, space: 4, child: text);
              },
            ),
          ),
          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        barGroups: List.generate(12, (index) {
          int month = index + 1;
          return BarChartGroupData(
            x: month,
            barRods: [
              BarChartRodData(
                toY: _komposPerBulan[month]?.toDouble() ?? 0,
                color: const Color(0xFF1B4332),
                width: 12,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
              )
            ],
          );
        }),
      ),
    );
  }
}