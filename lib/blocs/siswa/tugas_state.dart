part of 'tugas_bloc.dart';

abstract class TugasState extends Equatable {
  const TugasState();

  @override
  List<Object> get props => [];
}

class TugasInitial extends TugasState {}

class TugasLoading extends TugasState {}

class TugasLoaded extends TugasState {
  final List<TugasModel> tugasList;

  const TugasLoaded(this.tugasList);

  @override
  List<Object> get props => [tugasList];
}

class TugasError extends TugasState {
  final String message;

  const TugasError(this.message);

  @override
  List<Object> get props => [message];
}

class TugasFileUploaded extends TugasState {}

class TugasMarkedDone extends TugasState {}
