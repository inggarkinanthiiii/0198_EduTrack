import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';

import 'package:edutrack/blocs/siswa/tugas_bloc.dart';
import 'package:edutrack/models/siswa/tugas_model.dart';

class TugasListPage extends StatelessWidget {
  const TugasListPage({super.key});

  void _uploadFile(BuildContext context, int tugasId) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
    );

    if (result != null) {
      final file = File(result.files.single.path!);
      context.read<TugasBloc>().add(UploadFileTugas(tugasId: tugasId, file: file));

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('File berhasil diunggah')),
      );
    }
  }

  void _tandaiSelesai(BuildContext context, int tugasId) {
    context.read<TugasBloc>().add(TandaiSelesaiTugas(tugasId: tugasId));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Tugas ditandai selesai')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
      title: const Text('Daftar Tugas'),
      backgroundColor: Colors.blue, 
      foregroundColor: Colors.white, 
      elevation: 0,
    ),
