import 'package:flutter/material.dart';
import '../models/student.dart';
import '../providers/app_provider.dart';
import '../utils/validators.dart';
import '../widgets/profile_card.dart';

/// Layar untuk melihat dan mengubah profil mahasiswa.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _openEdit(
    BuildContext context,
    Student student,
  ) async {
    final updated = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (_) => _ProfileEditForm(student: student),
    );

    if (updated == true && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profil berhasil diperbarui'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = AppProvider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Mahasiswa'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: ProfileCard(
          student: provider.student,
          onEdit: () => _openEdit(context, provider.student),
        ),
      ),
    );
  }
}

class _ProfileEditForm extends StatefulWidget {
  final Student student;

  const _ProfileEditForm({required this.student});

  @override
  State<_ProfileEditForm> createState() => _ProfileEditFormState();
}

class _ProfileEditFormState extends State<_ProfileEditForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _nimController;
  late final TextEditingController _programStudiController;
  late final TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.student.name);
    _nimController = TextEditingController(text: widget.student.nim);
    _programStudiController = TextEditingController(
      text: widget.student.programStudi,
    );
    _emailController = TextEditingController(text: widget.student.email);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nimController.dispose();
    _programStudiController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final updated = Student(
      name: Validators.sanitize(_nameController.text),
      nim: Validators.sanitize(_nimController.text),
      programStudi: Validators.sanitize(_programStudiController.text),
      email: Validators.sanitize(_emailController.text),
    );

    await AppProvider.of(context, listen: false).updateStudent(updated);

    if (!mounted) return;
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        16,
        16,
        16,
        16 + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Edit Profil',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nama',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    Validators.validateRequired(value, fieldName: 'Nama'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _nimController,
                decoration: const InputDecoration(
                  labelText: 'NIM',
                  prefixIcon: Icon(Icons.badge),
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    Validators.validateRequired(value, fieldName: 'NIM'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _programStudiController,
                decoration: const InputDecoration(
                  labelText: 'Program Studi',
                  prefixIcon: Icon(Icons.school),
                  border: OutlineInputBorder(),
                ),
                validator: (value) => Validators.validateRequired(
                  value,
                  fieldName: 'Program studi',
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
                validator: Validators.validateEmail,
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _save,
                icon: const Icon(Icons.save),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                label: const Text('Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
