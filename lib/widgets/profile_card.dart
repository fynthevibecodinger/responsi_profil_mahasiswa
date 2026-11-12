import 'package:flutter/material.dart';
import '../models/student.dart';

/// Kartu yang menampilkan ringkasan profil mahasiswa.
class ProfileCard extends StatelessWidget {
  final Student student;
  final VoidCallback? onEdit;

  /// Membuat kartu profil mahasiswa.
  const ProfileCard({super.key, required this.student, this.onEdit});

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
      elevation: 2,
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CircleAvatar(
              radius: 44,
              backgroundColor: Colors.deepPurple,
              child: Text(
                _initials,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              student.name,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              'NIM: ${student.nim}',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
            const Divider(height: 32),
            _InfoRow(icon: Icons.school, label: student.programStudi),
            const SizedBox(height: 12),
            _InfoRow(icon: Icons.email, label: student.email),
            if (onEdit != null) ...[
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: onEdit,
                icon: const Icon(Icons.edit),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                label: const Text('Edit Profil'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoRow({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.deepPurple, size: 22),
        const SizedBox(width: 12),
        Expanded(child: Text(label, style: const TextStyle(fontSize: 16))),
      ],
    );
  }
}
