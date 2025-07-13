import 'package:flutter/material.dart';
import 'package:edutrack/data/auth_repository.dart';
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController(); 
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String? selectedRole;

  final authRepository = AuthRepository(); 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      body: Center(
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
                    const Text('Buat Akun Baru',
                        style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple)),
                    const SizedBox(height: 8),
                    Text('Daftar untuk memulai',
                        style: TextStyle(fontSize: 16, color: Colors.grey[600])),
                    const SizedBox(height: 32),

           
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: 'Nama Lengkap',
                        prefixIcon: const Icon(Icons.person),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                        filled: true,
                        fillColor: Colors.grey[100],
                      ),
                      validator: (value) => value == null || value.isEmpty ? 'Masukkan nama lengkap Anda' : null,
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        prefixIcon: const Icon(Icons.email),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                        filled: true,
                        fillColor: Colors.grey[100],
                      ),
                      validator: (value) => value == null || value.isEmpty ? 'Masukkan email Anda' : null,
                    ),
                    const SizedBox(height: 16),

              
                    TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.lock),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                        filled: true,
                        fillColor: Colors.grey[100],
                      ),
                      validator: (value) => value == null || value.isEmpty ? 'Masukkan password Anda' : null,
                    ),
                    const SizedBox(height: 16),

              
                    DropdownButtonFormField<String>(
                      value: selectedRole,
                      items: const [
                        DropdownMenuItem(value: 'Siswa', child: Text('Siswa')),
                        DropdownMenuItem(value: 'Guru', child: Text('Guru')),
                      ],
                      onChanged: (value) => setState(() => selectedRole = value),
                      decoration: InputDecoration(
                        labelText: 'Pilih Peran',
                        prefixIcon: const Icon(Icons.person_outline),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                        filled: true,
                        fillColor: Colors.grey[100],
                      ),
                      validator: (value) => value == null ? 'Pilih peran terlebih dahulu' : null,
                    ),
                    const SizedBox(height: 32),

                
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            try {
                              final response = await authRepository.register(
                                name: nameController.text,
                                email: emailController.text,
                                password: passwordController.text,
                                role: selectedRole!,
                              );

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(response['message'] ?? 'Registrasi berhasil')),
                              );

                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (_) => const LoginPage()),
                              );
                            } catch (e) {

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Gagal daftar: ${e.toString()}')),
                              );
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                          elevation: 5,
                        ),
                        child: const Text('Daftar', style: TextStyle(fontSize: 18, color: Colors.white)),
                      ),
                    ),
                    const SizedBox(height: 20),


                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (_) => const LoginPage()));
                      },
                      child: Text('Sudah punya akun? Login Sekarang!',
                        style: TextStyle(color: Colors.deepPurple[700])),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
