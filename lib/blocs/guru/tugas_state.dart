import 'package:equatable/equatable.dart';
import 'package:edutrack/models/guru/tugas_model.dart';

abstract class TugasState extends Equatable {
  const TugasState();

  @override
  List<Object?> get props => [];
}

class TugasInitial extends TugasState {}

class TugasLoading extends TugasState {}

class TugasLoaded extends TugasState {
  final List<Tugas> daftarTugas;

  const TugasLoaded(this.daftarTugas);

  @override
  List<Object?> get props => [daftarTugas];
}

class TugasError extends TugasState {
  final String message;

  const TugasError(this.message);

  @override
  List<Object?> get props => [message];
}
