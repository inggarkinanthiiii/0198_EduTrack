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

      backgroundColor: const Color(0xFFFDF6FF),
      body: BlocBuilder<TugasBloc, TugasState>(
        builder: (context, state) {
          if (state is TugasLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TugasLoaded) {
            if (state.tugasList.isEmpty) {
              return const Center(child: Text('Tidak ada tugas.'));
            }

            return ListView.builder(
              itemCount: state.tugasList.length,
              itemBuilder: (context, index) {
                final tugas = state.tugasList[index];
                final bool isSelesai = tugas.isSelesai ?? false;

                return Card(
                  color: isSelesai ? Colors.green.shade100 : null,
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text(
                      tugas.judul,
                      style: TextStyle(
                        color: isSelesai ? Colors.green.shade900 : null,
                        fontWeight: isSelesai ? FontWeight.bold : null,
                      ),
                    ),
                    subtitle: Text('Deadline: ${tugas.deadline}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.upload_file),
                          tooltip: 'Upload File',
                          onPressed: () => _uploadFile(context, tugas.id),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.check_circle_outline,
                            color: isSelesai ? Colors.green : null,
                          ),
                          tooltip: 'Tandai Selesai',
                          onPressed: () => _tandaiSelesai(context, tugas.id),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (state is TugasError) {
            return Center(child: Text(state.message));
          }

          return const SizedBox();
        },
      ),
    );
  }
}
