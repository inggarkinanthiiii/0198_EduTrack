import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthRepository {

  final String _baseUrl = 'http://10.0.2.2:8000/api';


  Future<Map<String, dynamic>> login({
    required String email,
    required String password, required String role,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email.trim(),
        'password': password.trim(),
      }),
    );

    print('[LOGIN] ${response.statusCode} → ${response.body}');

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }
    throw Exception('Gagal login: ${response.body}');
  }


Future<Map<String, dynamic>> register({
  required String name,
  required String email,
  required String password,
  required String role,
}) async {
  final response = await http.post(
    Uri.parse('$_baseUrl/register'),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json', 
    },
    body: jsonEncode({
      'name': name.trim(),
      'email': email.trim(),
      'password': password.trim(),
      'password_confirmation': password.trim(), 
      'role': role.trim().toLowerCase(),
    }),
  );

  print('[REGISTER] ${response.statusCode} → ${response.body}');

  if (response.statusCode >= 200 && response.statusCode < 300) {
    return jsonDecode(response.body) as Map<String, dynamic>;
  }
  throw Exception('Gagal register: ${response.body}');
}

}
