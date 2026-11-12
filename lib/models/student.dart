/// Model data profil mahasiswa.
class Student {
  final String name;
  final String nim;
  final String programStudi;
  final String email;

  /// Membuat data profil mahasiswa.
  const Student({
    required this.name,
    required this.nim,
    required this.programStudi,
    required this.email,
  });

  /// Membuat salinan dengan sebagian field yang diubah.
  Student copyWith({
    String? name,
    String? nim,
    String? programStudi,
    String? email,
  }) {
    return Student(
      name: name ?? this.name,
      nim: nim ?? this.nim,
      programStudi: programStudi ?? this.programStudi,
      email: email ?? this.email,
    );
  }

  /// Konversi ke Map.
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'nim': nim,
      'programStudi': programStudi,
      'email': email,
    };
  }

  /// Membuat [Student] dari Map.
  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      name: map['name'] as String? ?? '',
      nim: map['nim'] as String? ?? '',
      programStudi: map['programStudi'] as String? ?? '',
      email: map['email'] as String? ?? '',
    );
  }
}
