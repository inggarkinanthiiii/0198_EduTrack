import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';

import 'package:edutrack/blocs/siswa/tugas_bloc.dart';
import 'package:edutrack/models/siswa/tugas_model.dart';
import 'tugas_list_page.dart';
import 'riwayat_tugas_page.dart';
import 'package:edutrack/utils/notification_helper.dart';

class SiswaDashboard extends StatefulWidget {
  final String email;
  final String token;

  const SiswaDashboard({
    Key? key,
    required this.email,
    required this.token,
  }) : super(key: key);

  @override
  State<SiswaDashboard> createState() => _SiswaDashboardState();
}

class _SiswaDashboardState extends State<SiswaDashboard> {
  @override
  void initState() {
    super.initState();
    context.read<TugasBloc>().add(FetchTugas());
  }

  void _uploadFile(int tugasId) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
    );

    if (result != null) {
      final file = File(result.files.single.path!);
      context.read<TugasBloc>().add(UploadFileTugas(tugasId: tugasId, file: file));
    }
  }

  void _tandaiSelesai(int tugasId) {
    context.read<TugasBloc>().add(TandaiSelesaiTugas(tugasId: tugasId));
  }

  Future<void> _uploadDariKamera(int tugasId) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.camera);

    if (picked != null) {
      final file = File(picked.path);
      context.read<TugasBloc>().add(UploadFileTugas(tugasId: tugasId, file: file));
    }
  }

  Future<void> _ambilLokasi() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    if (permission == LocationPermission.deniedForever) return;

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Lokasi: ${position.latitude}, ${position.longitude}'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF6FF),
      appBar: AppBar(
        title: const Text('Dashboard Siswa'),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.list),
            tooltip: 'Lihat Semua Tugas',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    value: context.read<TugasBloc>(),
                    child: const TugasListPage(),
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: 'Riwayat Tugas',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const RiwayatTugasPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<TugasBloc, TugasState>(
          builder: (context, state) {
            if (state is TugasLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is TugasLoaded) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Halo, ${widget.email} 👋',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: Column(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BlocProvider.value(
                                  value: context.read<TugasBloc>(),
                                  child: const TugasListPage(),
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple[100],
                            foregroundColor: Colors.deepPurple,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          ),
                          child: const Text('📄 Lihat Tugas Saya'),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const RiwayatTugasPage(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange[100],
                            foregroundColor: Colors.deepOrange,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          ),
                          child: const Text('📜 Riwayat Tugas'),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () => NotificationHelper.showTestNotification(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[100],
                            foregroundColor: Colors.blue[900],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          ),
                          child: const Text('🔔 Test Notifikasi'),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () {
                            if (state.tugasList.isNotEmpty) {
                              _uploadDariKamera(state.tugasList.first.id);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red[100],
                            foregroundColor: Colors.red[900],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          ),
                          child: const Text('📷 Upload Gambar Kamera'),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: _ambilLokasi,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green[100],
                            foregroundColor: Colors.green[900],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          ),
                          child: const Text('📍 Ambil Lokasi Saya'),
                        ),
                      ],
                    ),
                  ),
