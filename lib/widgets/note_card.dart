import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/note.dart';

/// Kartu ringkasan satu catatan kuliah.
class NoteCard extends StatelessWidget {
  final Note note;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const NoteCard({super.key, required this.note, this.onTap, this.onDelete});

  @override
  Widget build(BuildContext context) {
    final date = DateFormat('dd/MM/yyyy HH:mm').format(note.date);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
          child: Icon(Icons.note_alt_outlined),
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
