import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:edutrack/blocs/login_bloc.dart';
import 'package:edutrack/blocs/login_event.dart';
import 'package:edutrack/blocs/login_state.dart';
import 'package:edutrack/blocs/siswa/tugas_bloc.dart';
import 'package:edutrack/pages/dashboard_router.dart';
import 'package:edutrack/pages/register_page.dart';
import 'package:edutrack/bloc/siswa/tugas_bloc.dart'; 

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String? selectedRole = 'Guru';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      body: Center(
        child: BlocListener<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state.isSuccess && state.token != null && selectedRole != null) {
              if (selectedRole == 'Siswa') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BlocProvider(
                      create: (_) => TugasBloc(token: state.token!)..add(FetchTugas()),
                      child: DashboardRouter(
                        email: state.email,
                        role: selectedRole!,
                        token: state.token!,
                      ),
                    ),
                  ),
                );
              } else {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DashboardRouter(
                      email: state.email,
                      role: selectedRole!,
                      token: state.token!,
                    ),
                  ),
                );
              }
            } else if (state.isFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Login gagal. Cek email & password!')),
              );
            }
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Card(
              elevation: 8.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Selamat Datang!',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Silakan masuk untuk melanjutkan',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Email
                      BlocBuilder<LoginBloc, LoginState>(
                        builder: (context, state) {
                          return TextFormField(
                            initialValue: state.email,
                            onChanged: (value) {
                              context.read<LoginBloc>().add(LoginEmailChanged(value));
                            },
                            decoration: InputDecoration(
                              labelText: 'Email',
                              hintText: 'contoh@email.com',
                              prefixIcon: const Icon(Icons.email),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              filled: true,
                              fillColor: Colors.grey[100],
                            ),
                            validator: (value) =>
                                value == null || value.isEmpty ? 'Masukkan email Anda' : null,
                          );
                        },
                      ),

                      const SizedBox(height: 16),

                      BlocBuilder<LoginBloc, LoginState>(
                        builder: (context, state) {
                          return TextFormField(
                            initialValue: state.password,
                            onChanged: (value) {
                              context.read<LoginBloc>().add(LoginPasswordChanged(value));
                            },
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              prefixIcon: const Icon(Icons.lock),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              filled: true,
                              fillColor: Colors.grey[100],
                            ),
                            validator: (value) =>
                                value == null || value.isEmpty ? 'Masukkan password Anda' : null,
                          );
                        },
                      ),

                      const SizedBox(height: 16),

                      DropdownButtonFormField<String>(
                        value: selectedRole,
                        items: const [
                          DropdownMenuItem(value: 'Siswa', child: Text('Siswa')),
                          DropdownMenuItem(value: 'Guru', child: Text('Guru')),
                        ],
                        onChanged: (value) {
                          setState(() {
                            selectedRole = value;
                          });
                        },
                        decoration: InputDecoration(
                          labelText: 'Pilih Peran',
                          prefixIcon: const Icon(Icons.person),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          filled: true,
                          fillColor: Colors.grey[100],
                        ),
                        validator: (value) =>
                            value == null ? 'Pilih peran terlebih dahulu' : null,
                      ),

                      const SizedBox(height: 32),

                      // Tombol Login
                      BlocBuilder<LoginBloc, LoginState>(
                        builder: (context, state) {
                          return SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  context
                                      .read<LoginBloc>()
                                      .add(LoginSubmitted(role: selectedRole!));
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueAccent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                elevation: 5,
                              ),
                              child: state.isSubmitting
                                  ? const CircularProgressIndicator(color: Colors.white)
                                  : const Text(
                                      'Login',
                                      style: TextStyle(fontSize: 18, color: Colors.white),
                                    ),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 20),

                  
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => const RegisterPage()),
                          );
                        },
                        child: Text(
                          'Belum punya akun? Daftar Sekarang!',
                          style: TextStyle(color: Colors.blueAccent[700]),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
