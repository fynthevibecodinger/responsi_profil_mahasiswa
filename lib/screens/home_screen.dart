import 'package:flutter/material.dart';
import '../models/note.dart';
import '../models/student.dart';
import '../providers/app_provider.dart';
import '../widgets/empty_state.dart';
import '../widgets/note_card.dart';
import 'note_form_screen.dart';
import 'profile_screen.dart';

/// Layar utama yang menampilkan profil singkat dan daftar catatan.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _openForm(BuildContext context) async {
    final added = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const NoteFormScreen()),
    );

    if (added == true && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Catatan berhasil ditambahkan'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _showContent(BuildContext context, Note note) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(note.title),
        content: SingleChildScrollView(
          child: Text(note.content ?? 'Isi catatan tidak tersedia.'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    AppProvider provider,
    Note note,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Hapus Catatan'),
        content: Text('Yakin ingin menghapus "${note.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text(
              'Hapus',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    try {
      await provider.deleteNote(note.id);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Catatan berhasil dihapus'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal menghapus catatan'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = AppProvider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Catatan Kuliah'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            tooltip: 'Profil',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfileScreen()),
              );
            },
          ),
        ],
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : provider.errorMessage != null
          ? _ErrorState(
              message: provider.errorMessage!,
              onRetry: provider.reload,
            )
          : Column(
              children: [
                _ProfileSummary(student: provider.student),
                Expanded(
                  child: provider.notes.isEmpty
                      ? EmptyState(onAction: () => _openForm(context))
                      : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 88),
                          itemCount: provider.notes.length,
                          itemBuilder: (context, index) {
                            final note = provider.notes[index];
                            return NoteCard(
                              note: note,
                              onTap: () => _showContent(context, note),
                              onDelete: () =>
                                  _confirmDelete(context, provider, note),
                            );
                          },
                        ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openForm(context),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Catatan'),
      ),
    );
  }
}

class _ProfileSummary extends StatelessWidget {
  final Student student;

  const _ProfileSummary({required this.student});

  String get _initials {
    final parts = student.name
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
          child: Text(
            _initials,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          student.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('NIM: ${student.nim}'),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ProfileScreen()),
          );
        },
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final Future<void> Function() onRetry;

  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Coba Lagi'),
            ),
          ],
        ),
      ),
    );
  }
}
