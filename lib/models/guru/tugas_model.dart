class Tugas {
  final int id;
  final String judul;
  final String deskripsi;
  final String deadline;
  final int guruId;
  final bool isSelesai;

  Tugas({
    required this.id,
    required this.judul,
    required this.deskripsi,
    required this.deadline,
    required this.guruId,
    this.isSelesai = false,
  });


  factory Tugas.fromJson(Map<String, dynamic> json) {
    return Tugas(
      id: json['id'],
      judul: json['judul'],
      deskripsi: json['deskripsi'],
      deadline: json['deadline'],
      guruId: json['guru_id'],
      isSelesai: json['isSelesai'] == 1 || json['isSelesai'] == true, 
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'judul': judul,
      'deskripsi': deskripsi,
      'deadline': deadline,
      'guru_id': guruId,
      'isSelesai': isSelesai ? 1 : 0,
    };
  }


  factory Tugas.fromMap(Map<String, dynamic> map) {
    return Tugas(
      id: map['id'],
      judul: map['judul'],
      deskripsi: map['deskripsi'],
      deadline: map['deadline'],
      guruId: map['guru_id'],
      isSelesai: map['isSelesai'] == 1,
    );
  }
}
