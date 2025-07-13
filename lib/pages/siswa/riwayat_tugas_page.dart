import 'package:flutter/material.dart';
import 'package:edutrack/data/local/tugas_db.dart';
import 'package:edutrack/models/siswa/tugas_model.dart';

class RiwayatTugasPage extends StatefulWidget {
  const RiwayatTugasPage({super.key});

  @override
  State<RiwayatTugasPage> createState() => _RiwayatTugasPageState();
}

class _RiwayatTugasPageState extends State<RiwayatTugasPage> {
  String _filter = 'Semua';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Tugas'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _filter,
              icon: const Icon(Icons.filter_list, color: Colors.white),
              dropdownColor: Colors.white,
              items: const [
                DropdownMenuItem(value: 'Semua', child: Text('Semua')),
                DropdownMenuItem(value: 'Selesai', child: Text('Selesai')),
                DropdownMenuItem(value: 'Belum', child: Text('Belum')),
              ],
              onChanged: (value) {
                setState(() {
                  _filter = value!;
                });
              },
            ),
          ),
        ],
      ),
      backgroundColor: const Color(0xFFFDF6FF),
      body: FutureBuilder<List<TugasModel>>(
        future: TugasDatabase.instance.getAllTugas(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final allTugas = snapshot.data!;
          List<TugasModel> filteredTugas;

          if (_filter == 'Selesai') {
            filteredTugas = allTugas.where((t) => t.isSelesai).toList();
          } else if (_filter == 'Belum') {
            filteredTugas = allTugas.where((t) => !t.isSelesai).toList();
          } else {
            filteredTugas = allTugas;
          }

          if (filteredTugas.isEmpty) {
            return const Center(child: Text('Tidak ada tugas sesuai filter.'));
          }

          return ListView.builder(
            itemCount: filteredTugas.length,
            itemBuilder: (context, index) {
              final tugas = filteredTugas[index];
              final isSelesai = tugas.isSelesai;

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
                  trailing: Icon(
                    isSelesai ? Icons.check_circle : Icons.hourglass_bottom,
                    color: isSelesai ? Colors.green : Colors.orange,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
