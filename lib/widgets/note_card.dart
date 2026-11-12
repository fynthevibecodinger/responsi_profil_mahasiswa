import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/note.dart';

/// Kartu ringkasan satu catatan kuliah.
class NoteCard extends StatelessWidget {
  final Note note;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  /// Membuat kartu catatan.
  const NoteCard({super.key, required this.note, this.onTap, this.onDelete});

  @override
  Widget build(BuildContext context) {
    final date = DateFormat('dd/MM/yyyy HH:mm').format(note.date);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.deepPurple.withValues(alpha: 0.15)),
      ),
      child: ListTile(
        leading: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: Colors.deepPurple.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(
            Icons.description_outlined,
            color: Colors.deepPurple,
          ),
        ),
        title: Text(
          note.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(date),
        onTap: onTap,
        trailing: onDelete == null
            ? null
            : IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                tooltip: 'Hapus catatan',
                onPressed: onDelete,
              ),
      ),
    );
  }
}
