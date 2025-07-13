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
