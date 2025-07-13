part of 'tugas_bloc.dart';

abstract class TugasEvent extends Equatable {
  const TugasEvent();

  @override
  List<Object> get props => [];
}

class FetchTugas extends TugasEvent {}

class UploadFileTugas extends TugasEvent {
  final int tugasId;
  final File file;

  const UploadFileTugas({required this.tugasId, required this.file});

  @override
  List<Object> get props => [tugasId, file];
}

class TandaiSelesaiTugas extends TugasEvent {
  final int tugasId;

  const TandaiSelesaiTugas({required this.tugasId});

  @override
  List<Object> get props => [tugasId];
}
