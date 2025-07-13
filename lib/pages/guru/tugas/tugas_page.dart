import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'tugas_form_page.dart';

class TugasPage extends StatefulWidget {
  final String token;
  const TugasPage({super.key, required this.token});

  @override
  State<TugasPage> createState() => _TugasPageState();
}

class _TugasPageState extends State<TugasPage> {
  List tugasList = [];
  bool isLoading = true;

  
  Future<void> fetchTugas() async {
    setState(() => isLoading = true);
    final response = await http.get(
      Uri.parse('http://10.0.2.2:8000/api/tugas'),
      headers: {
        'Authorization': 'Bearer ${widget.token}',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        tugasList = json.decode(response.body);
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
      _showSnack('Gagal mengambil data tugas');
    }
  }

  void _showSnack(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  @override
  void initState() {
    super.initState();
    fetchTugas();
  }

 
  Future<void> _deleteTugas(int id) async {
    final confirm = await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Hapus Tugas'),
        content: const Text('Yakin ingin menghapus tugas ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    final res = await http.delete(
      Uri.parse('http://10.0.2.2:8000/api/tugas/$id'),
      headers: {
        'Authorization': 'Bearer ${widget.token}',
        'Accept': 'application/json',
      },
    );

    if (res.statusCode == 200) {
      _showSnack('Tugas dihapus');
      fetchTugas();
    } else {
      _showSnack('Gagal menghapus tugas');
    }
  }

 
  Future<void> _openForm({Map<String, dynamic>? editTugas}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TugasFormPage(
          token: widget.token,
          tugas: editTugas,
        ),
      ),
    );
    if (result == true) fetchTugas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Tugas'),
        backgroundColor: Colors.blue[900],
        foregroundColor: Colors.white,   
        centerTitle: true, 
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : tugasList.isEmpty
              ? const Center(child: Text('Belum ada tugas'))
              : ListView.builder(
                  itemCount: tugasList.length,
                  itemBuilder: (context, index) {
                    final tugas = tugasList[index];
                    return Card(
                      margin:
                          const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      child: ListTile(
                        title: Text(tugas['judul']),
                        subtitle: Text('Deadline: ${tugas['deadline']}'),
                        onTap: () => _openForm(editTugas: tugas),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () => _openForm(editTugas: tugas),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteTugas(tugas['id']),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openForm(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
