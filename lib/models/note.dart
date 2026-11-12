/// Model catatan kuliah.
///
/// [content] hanya disimpan di memori dan di secure storage.
/// Metadata yang ditulis ke SharedPreferences tidak memuat isi catatan.
class Note {
  final String id;
  final String title;
  final DateTime date;
  final String? content;

  const Note({
    required this.id,
    required this.title,
    required this.date,
    this.content,
  });

  /// Membuat salinan dengan sebagian field yang diubah.
  Note copyWith({
    String? id,
    String? title,
    DateTime? date,
    String? content,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      date: date ?? this.date,
      content: content ?? this.content,
    );
  }

  /// Metadata yang aman disimpan di SharedPreferences.
  Map<String, dynamic> toMetadataJson() {
    return {
      'id': id,
      'title': title,
      'date': date.toIso8601String(),
    };
  }

  /// Membuat [Note] dari metadata SharedPreferences.
  factory Note.fromMetadataJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      date: DateTime.tryParse(json['date'] as String? ?? '') ?? DateTime.now(),
    );
  }
}
