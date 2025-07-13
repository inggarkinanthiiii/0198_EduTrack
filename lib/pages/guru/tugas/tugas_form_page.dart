import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TugasFormPage extends StatefulWidget {
  final String token;
  final Map<String, dynamic>? tugas; // null = tambah, ada = edit

  const TugasFormPage({
    super.key,
    required this.token,
    this.tugas,
  });

  @override
  State<TugasFormPage> createState() => _TugasFormPageState();
}

class _TugasFormPageState extends State<TugasFormPage> {
  final _formKey = GlobalKey<FormState>();
  final judulController = TextEditingController();
  final deskripsiController = TextEditingController();
  final deadlineController = TextEditingController();
  bool isSubmitting = false;

  @override
  void initState() {
    super.initState();
    // 👉 Isi otomatis jika mode EDIT
    if (widget.tugas != null) {
      judulController.text = widget.tugas!['judul'] ?? '';
      deskripsiController.text = widget.tugas!['deskripsi'] ?? '';
      deadlineController.text = widget.tugas!['deadline'] ?? '';
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isSubmitting = true);

    final isEdit = widget.tugas != null;
    final url = isEdit
        ? 'http://10.0.2.2:8000/api/tugas/${widget.tugas!['id']}'
        : 'http://10.0.2.2:8000/api/tugas';

    final headers = {
      'Authorization': 'Bearer ${widget.token}',
      'Accept': 'application/json',
    };

    http.Response response;

    if (isEdit) {
      // PUT ⬅️ kirim JSON
      headers['Content-Type'] = 'application/json';
      response = await http.put(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode({
          'judul': judulController.text,
          'deskripsi': deskripsiController.text,
          'deadline': deadlineController.text,
        }),
      );
    } else {
      // POST ⬅️ form‑urlencoded cukup
      response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: {
          'judul': judulController.text,
          'deskripsi': deskripsiController.text,
          'deadline': deadlineController.text,
        },
      );
    }

    setState(() => isSubmitting = false);

    if (response.statusCode == 200 || response.statusCode == 201) {
      Navigator.pop(context, true); // sukses → refresh list
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isEdit ? 'Gagal memperbarui tugas' : 'Gagal menambahkan tugas',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.tugas != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Tugas' : 'Tambah Tugas'),
        backgroundColor: Colors.blue[900],
        foregroundColor: Colors.white, 
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: judulController,
                decoration: const InputDecoration(labelText: 'Judul'),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Judul tidak boleh kosong' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: deskripsiController,
                decoration: const InputDecoration(labelText: 'Deskripsi'),
                maxLines: 3,
                validator: (v) =>
                    v == null || v.isEmpty ? 'Deskripsi wajib diisi' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: deadlineController,
                decoration:
                    const InputDecoration(labelText: 'Deadline (YYYY-MM-DD)'),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Deadline wajib diisi' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: isSubmitting ? null : _submit,
                child: Text(isEdit ? 'Perbarui' : 'Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
