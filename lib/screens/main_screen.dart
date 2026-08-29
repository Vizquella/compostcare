  import 'package:flutter/material.dart';
  import 'dashboard_screen.dart';
  import 'pengaturan_screen.dart';
  import 'riwayat_screen.dart';

  class MainScreen extends StatefulWidget {
    const MainScreen({super.key});

    @override
    State<MainScreen> createState() => _MainScreenState();
  }

  class _MainScreenState extends State<MainScreen> {
    // Variabel penentu tab mana yang sedang aktif (0 = Home, 1 = Riwayat, 2 = Profil)
    int _selectedIndex = 0;

    // Daftar halaman yang akan ditampilkan sesuai urutan tab
    final List<Widget> _pages = [
      const DashboardScreen(),
      const RiwayatScreen(),
      const PengaturanScreen(),
    ];

    // Fungsi yang dipanggil saat ikon di Bottom Navigation ditekan
    void _onItemTapped(int index) {
      setState(() {
        _selectedIndex = index;
      });
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        // Body akan berubah sesuai dengan index tab yang dipilih
        body: _pages[_selectedIndex],

        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: const Color(0xFF1B4332), // Hijau Tua
          unselectedItemColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Riwayat'),
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Pengaturan'),
          ],
        ),
      );
    }
  }