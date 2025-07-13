import 'package:flutter_bloc/flutter_bloc.dart';
import 'tugas_event.dart';
import 'tugas_state.dart';
import 'package:edutrack/data/repositories/tugas_repository.dart';

class TugasBloc extends Bloc<TugasEvent, TugasState> {
  final TugasRepository repository;

  TugasBloc({required this.repository}) : super(TugasInitial()) {
    on<LoadTugas>(_onLoadTugas);
    on<AddTugas>(_onAddTugas);
    on<UpdateTugas>(_onUpdateTugas);
    on<DeleteTugas>(_onDeleteTugas);
  }

  Future<void> _onLoadTugas(LoadTugas event, Emitter<TugasState> emit) async {
    emit(TugasLoading());
    try {
      final tugas = await repository.fetchTugas();
      emit(TugasLoaded(tugas));
    } catch (e) {
      emit(TugasError('Gagal memuat tugas'));
    }
  }

  Future<void> _onAddTugas(AddTugas event, Emitter<TugasState> emit) async {
    try {
      await repository.createTugas(
        judul: event.judul,
        deskripsi: event.deskripsi,
        deadline: event.deadline,
      );
      add(LoadTugas());
    } catch (e) {
      emit(TugasError('Gagal menambah tugas'));
    }
  }

  Future<void> _onUpdateTugas(UpdateTugas event, Emitter<TugasState> emit) async {
    try {
      await repository.updateTugas(
        id: event.id,
        judul: event.judul,
        deskripsi: event.deskripsi,
        deadline: event.deadline,
      );
      add(LoadTugas()); 
    } catch (e) {
      emit(TugasError('Gagal memperbarui tugas'));
    }
  }

  Future<void> _onDeleteTugas(DeleteTugas event, Emitter<TugasState> emit) async {
    try {
      await repository.deleteTugas(event.id);
      add(LoadTugas()); 
    } catch (e) {
      emit(TugasError('Gagal menghapus tugas'));
    }
  }
}
