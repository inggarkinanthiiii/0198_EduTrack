import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

import 'package:edutrack/models/siswa/tugas_model.dart';
import 'package:edutrack/data/local/tugas_db.dart';
import 'package:edutrack/utils/notification_helper.dart'; 

part 'tugas_event.dart';
part 'tugas_state.dart';

class TugasBloc extends Bloc<TugasEvent, TugasState> {
  final String token;
  final String baseUrl = 'http://10.0.2.2:8000/api';

  TugasBloc({required this.token}) : super(TugasInitial()) {
    on<FetchTugas>(_onFetchTugas);
    on<UploadFileTugas>(_onUploadFileTugas);
    on<TandaiSelesaiTugas>(_onTandaiSelesaiTugas);
  }

  
  Future<void> _onFetchTugas(FetchTugas event, Emitter<TugasState> emit) async {
    emit(TugasLoading());
    try {
      final res = await http.get(
        Uri.parse('$baseUrl/tugas/siswa'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (res.statusCode == 200) {
        final List<dynamic> data = jsonDecode(res.body);

        final tugasList = data
            .map((e) {
              try {
                return TugasModel.fromJson(e as Map<String, dynamic>);
              } catch (_) {
                return null;
              }
            })
            .where((e) => e != null)
            .cast<TugasModel>()
            .toList();

       
        await TugasDatabase.instance.clearAll();
        for (var tugas in tugasList) {
          await TugasDatabase.instance.insertTugas(tugas);
        }

        emit(TugasLoaded(tugasList));

        
        for (final tugas in tugasList) {
          if (!tugas.isSelesai) {
            await NotificationHelper.scheduleDeadlineNotif(
              id: tugas.id,
              title: tugas.judul,
              deadline: DateTime.parse(tugas.deadline),
            );
          }
        }
      } else {
        emit(TugasError('Gagal memuat data tugas (${res.statusCode})'));
      }
    } catch (e) {
      emit(TugasError('Error: $e'));
    }
  }

  Future<void> _onUploadFileTugas(
      UploadFileTugas event, Emitter<TugasState> emit) async {
    emit(TugasLoading());
    try {
      final uri = Uri.parse('$baseUrl/tugas/${event.tugasId}/upload');
      final req = http.MultipartRequest('POST', uri)
        ..headers['Authorization'] = 'Bearer $token'
        ..files.add(await http.MultipartFile.fromPath('file', event.file.path));

      final res = await req.send();

      if (res.statusCode == 200) {
        emit(TugasFileUploaded());
        add(FetchTugas()); 
      } else {
        emit(TugasError('Gagal upload file (${res.statusCode})'));
      }
    } catch (e) {
      emit(TugasError('Error: $e'));
    }
  }


  Future<void> _onTandaiSelesaiTugas(
      TandaiSelesaiTugas event, Emitter<TugasState> emit) async {
    emit(TugasLoading());
    try {
      final res = await http.patch(
        Uri.parse('$baseUrl/tugas/${event.tugasId}/selesai'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (res.statusCode == 200) {
      
        await FlutterLocalNotificationsPlugin().cancel(event.tugasId);

        emit(TugasMarkedDone());
        add(FetchTugas()); 
      } else {
        emit(TugasError('Gagal menandai selesai (${res.statusCode})'));
      }
    } catch (e) {
      emit(TugasError('Error: $e'));
    }
  }
}
