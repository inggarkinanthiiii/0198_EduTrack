import 'dart:convert';
import 'package:http/http.dart' as http;

class TugasService {
  final String _baseUrl = 'http://10.0.2.2:8000/api';

  Future<List<dynamic>> getTugas(String token) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/tugas'),
      headers: {
        'Authorization': 'Bearer $token', 
        'Accept': 'application/json',
      },
    );

    print('GET STATUS: ${response.statusCode}');
    print('GET BODY: ${response.body}');
    print('TOKEN GET: $token');

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Gagal mengambil data tugas');
    }
  }

  Future<void> tambahTugas(String token, Map<String, dynamic> data) async {
    print('TOKEN POST: $token'); 
    final response = await http.post(
      Uri.parse('$_baseUrl/tugas'),
      headers: {
        'Authorization': 'Bearer $token', 
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(data),
    );

    print('POST STATUS: ${response.statusCode}');
    print('POST BODY: ${response.body}');

    if (response.statusCode != 201) {
   
      throw Exception('Gagal menambahkan tugas: ${response.body}');
    }
  }

  Future<void> updateTugas(String token, int id, Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/tugas/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(data),
    );

    print('PUT STATUS: ${response.statusCode}');
    print('PUT BODY: ${response.body}');

    if (response.statusCode != 200) {
      throw Exception('Gagal mengupdate tugas: ${response.body}');
    }
  }

  Future<void> hapusTugas(String token, int id) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl/tugas/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    print('DELETE STATUS: ${response.statusCode}');
    print('DELETE BODY: ${response.body}');

    if (response.statusCode != 200) {
      throw Exception('Gagal menghapus tugas: ${response.body}');
    }
  }
}
