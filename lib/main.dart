import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'screens/main_screen.dart';
import 'screens/auth_screen.dart';
import 'screens/admin_screen.dart';
import 'services/notification_service.dart'; // <--- 1. Tambahkan import ini

void main() async {
  // Wajib ditambahkan agar Flutter siap menjalankan mesin Firebase & Notifikasi
  WidgetsFlutterBinding.ensureInitialized();

  // Menginisialisasi Firebase berdasarkan platform (Android)
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // ---> 2. MASUKKAN INIT NOTIFIKASI DI SINI <---
  await NotificationService().init();
  // Jika kamu punya fungsi request permission di dalam service-mu, aktifkan baris di bawah ini:
  // await NotificationService().requestPermission();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CompostCare',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF1B4332),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1B4332)),
      ),
      // StreamBuilder bertugas mendeteksi perubahan status login secara real-time
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(body: Center(child: CircularProgressIndicator(color: Color(0xFF1B4332))));
          }

          if (snapshot.hasData) {
            final user = snapshot.data!;
            // LOGIKA ADMIN: Jika email yang login adalah admin, arahkan ke layar Admin
            if (user.email == 'admin@compostcare.com') {
              return const AdminScreen();
            }
            // Jika bukan admin (warga biasa), arahkan ke Bottom Navigation
            return const MainScreen();
          }

          return const AuthScreen();
        },
      ),
    );
  }
}