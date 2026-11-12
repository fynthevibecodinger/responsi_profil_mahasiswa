import 'package:flutter/material.dart';

/// Tampilan saat daftar catatan masih kosong.
class EmptyState extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback? onAction;

  const EmptyState({
    super.key,
    this.title = 'Belum ada catatan',
    this.message = 'Mulai tambahkan catatan kuliah pertamamu.',
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.menu_book_outlined,
              size: 80,
              color: Colors.deepPurple.shade200,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
            if (onAction != null) ...[
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: onAction,
                icon: const Icon(Icons.add),
                label: const Text('Tambah Catatan'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
