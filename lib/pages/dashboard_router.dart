import 'package:flutter/material.dart';
import 'guru/guru_dashboard.dart';
import 'siswa/siswa_dashboard.dart';

class DashboardRouter extends StatelessWidget {
  final String email;
  final String role;
  final String token; 

  const DashboardRouter({
    super.key,
    required this.email,
    required this.role,
    required this.token,
  });

  @override
  Widget build(BuildContext context) {
    if (role == 'Guru') {
      return DashboardGuru(email: email, token: token); 
    } else if (role == 'Siswa') {
      return SiswaDashboard(email: email, token: token); 
    } else {
      return const Scaffold(
        body: Center(child: Text('Peran tidak dikenali')),
      );
    }
  }
}
