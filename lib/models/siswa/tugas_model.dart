class TugasModel {
  final int id;
  final String judul;
  final String deskripsi;
  final String deadline;
  final String status;      
  final String? file;
  final bool isSelesai;    
  TugasModel({
    required this.id,
    required this.judul,
    required this.deskripsi,
    required this.deadline,
    required this.status,
    this.file,
    this.isSelesai = false,
  });


  factory TugasModel.fromJson(Map<String, dynamic> json) {
    return TugasModel(
      id: json['id'] ?? 0,
      judul: json['judul'] ?? '',
      deskripsi: json['deskripsi'] ?? '',
      deadline: json['deadline'] ?? '',
      status: json['status'] ?? 'belum',
      file: json['file'],
      isSelesai: (json['status'] ?? 'belum') == 'selesai',
    );
  }


  factory TugasModel.fromMap(Map<String, dynamic> map) {
    return TugasModel(
      id: map['id'],
      judul: map['judul'],
      deskripsi: map['deskripsi'],
      deadline: map['deadline'],
      status: map['status'] ?? 'belum',
      file: map['file'],
      isSelesai: map['isSelesai'] == 1,
    );
  }

 
  Map<String, dynamic> toMap() => {
        'id': id,
        'judul': judul,
        'deskripsi': deskripsi,
        'deadline': deadline,
        'isSelesai': isSelesai ? 1 : 0,
        'status': status,
        'file': file,
      };
}
