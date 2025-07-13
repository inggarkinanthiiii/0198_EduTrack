import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'tugas/tugas_page.dart';

class DashboardGuru extends StatefulWidget {
  final String email;
  final String token;

  const DashboardGuru({
    super.key,
    required this.email,
    required this.token,
  });

  @override
  State<DashboardGuru> createState() => _DashboardGuruState();
}

class _DashboardGuruState extends State<DashboardGuru> {
  List tugasList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTugas();
  }

  Future<void> fetchTugas() async {
    setState(() => isLoading = true);
    final res = await http.get(
      Uri.parse('http://10.0.2.2:8000/api/tugas'),
      headers: {
        'Authorization': 'Bearer ${widget.token}',
        'Accept': 'application/json',
      },
    );

    if (res.statusCode == 200) {
      setState(() {
        tugasList = json.decode(res.body);
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal memuat tugas')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      title: const Text('Dashboard Guru'),
      backgroundColor: Colors.blue[900],
      foregroundColor: Colors.white,
      centerTitle: true,  
      ),
      body: RefreshIndicator(
        onRefresh: fetchTugas,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text('Halo, ${widget.email} 👋',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                )),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => TugasPage(token: widget.token),
                  ),
                );
              },
              child: const Text('Kelola Tugas'),
            ),
            const SizedBox(height: 24),
            const Text('Daftar Tugas:', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 12),
            if (isLoading)
              const Center(child: CircularProgressIndicator())
            else if (tugasList.isEmpty)
              const Text('Belum ada tugas', textAlign: TextAlign.center)
            else
              ...tugasList.map((tugas) => Card(
                    child: ListTile(
                      title: Text(tugas['judul']),
                      subtitle: Text('Deadline: ${tugas['deadline']}'),
                    ),
                  )),
          ],
        ),
      ),
    );
  }
}
