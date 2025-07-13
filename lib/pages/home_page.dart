import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final String email;
  final String role;

  const HomePage({super.key, required this.email, required this.role});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Home")),
      body: Center(
        child: Text('Selamat datang $role: $email'),
      ),
    );
  }
}
