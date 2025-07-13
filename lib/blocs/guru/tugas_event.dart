import 'package:equatable/equatable.dart';

abstract class TugasEvent extends Equatable {
  const TugasEvent();

  @override
  List<Object?> get props => [];
}

class LoadTugas extends TugasEvent {}

class AddTugas extends TugasEvent {
  final String judul;
  final String deskripsi;
  final String deadline;

  const AddTugas(this.judul, this.deskripsi, this.deadline);

  @override
  List<Object?> get props => [judul, deskripsi, deadline];
}

class UpdateTugas extends TugasEvent {
  final int id;
  final String judul;
  final String deskripsi;
  final String deadline;

  const UpdateTugas(this.id, this.judul, this.deskripsi, this.deadline);

  @override
  List<Object?> get props => [id, judul, deskripsi, deadline];
}

class DeleteTugas extends TugasEvent {
  final int id;

  const DeleteTugas(this.id);

  @override
  List<Object?> get props => [id];
}
