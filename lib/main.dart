import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:edutrack/blocs/login_bloc.dart';
import 'package:edutrack/pages/login_page.dart';
import 'package:edutrack/data/auth_repository.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'package:edutrack/utils/notification_helper.dart'; // ✅ Tambahkan ini

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Inisialisasi notifikasi lokal
  await NotificationHelper.init();

  // ✅ Hapus database lama agar struktur tabel terbaru digunakan
  await deleteOldDatabase();

  runApp(const EduTrackApp());
}

// ✅ Fungsi untuk hapus database lokal lama
Future<void> deleteOldDatabase() async {
  final dbPath = await getDatabasesPath();
  final path = join(dbPath, 'tugas.db');

  // Hapus database jika ada
  await deleteDatabase(path);
}

class EduTrackApp extends StatelessWidget {
  const EduTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authRepository = AuthRepository(); // Inisialisasi repository

    return RepositoryProvider.value(
      value: authRepository,
      child: BlocProvider(
        create: (context) => LoginBloc(authRepository: authRepository),
        child: MaterialApp(
          title: 'EduTrack',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: const LoginPage(), // Halaman login utama
        ),
      ),
    );
  }
}
