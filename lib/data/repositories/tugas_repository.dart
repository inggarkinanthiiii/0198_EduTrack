import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:edutrack/models/guru/tugas_model.dart';

class TugasRepository {
  final String baseUrl;
  final String token;

  TugasRepository({required this.baseUrl, required this.token});

  Future<List<Tugas>> fetchTugas() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/tugas'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Tugas.fromJson(json)).toList();
    } else {
      throw Exception('Gagal memuat tugas');
    }
  }

  Future<void> createTugas({
    required String judul,
    required String deskripsi,
    required String deadline,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/tugas'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
      body: {
        'judul': judul,
        'deskripsi': deskripsi,
        'deadline': deadline,
      },
    );

    if (response.statusCode != 201) {
      throw Exception('Gagal menambahkan tugas');
    }
  }

  Future<void> updateTugas({
    required int id,
    required String judul,
    required String deskripsi,
    required String deadline,
  }) async {
    final response = await http.put(
      Uri.parse('$baseUrl/api/tugas/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
      body: {
        'judul': judul,
        'deskripsi': deskripsi,
        'deadline': deadline,
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Gagal memperbarui tugas');
    }
  }

  Future<void> deleteTugas(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/api/tugas/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Gagal menghapus tugas');
    }
  }
}
