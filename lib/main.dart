import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:edutrack/blocs/login_bloc.dart';
import 'package:edutrack/pages/login_page.dart';
import 'package:edutrack/data/auth_repository.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'package:edutrack/utils/notification_helper.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await NotificationHelper.init();

 
  await deleteOldDatabase();

  runApp(const EduTrackApp());
}

Future<void> deleteOldDatabase() async {
  final dbPath = await getDatabasesPath();
  final path = join(dbPath, 'tugas.db');


  await deleteDatabase(path);
}

class EduTrackApp extends StatelessWidget {
  const EduTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authRepository = AuthRepository(); 

    return RepositoryProvider.value(
      value: authRepository,
      child: BlocProvider(
        create: (context) => LoginBloc(authRepository: authRepository),
        child: MaterialApp(
          title: 'EduTrack',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: const LoginPage(), 
        ),
      ),
    );
  }
}
