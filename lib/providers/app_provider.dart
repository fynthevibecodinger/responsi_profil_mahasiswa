import 'package:flutter/material.dart';
import '../models/note.dart';
import '../models/student.dart';
import '../repositories/note_repository.dart';
import '../utils/logger.dart';

/// Menyediakan state profil dan catatan ke seluruh subtree.
class AppProvider extends InheritedWidget {
  final Student student;
  final List<Note> notes;
  final bool isLoading;
  final String? errorMessage;
  final Future<void> Function(Student) updateStudent;
  final Future<void> Function(Note) addNote;
  final Future<void> Function(String) deleteNote;
  final Future<void> Function() reload;

  const AppProvider({
    super.key,
    required this.student,
    required this.notes,
    required this.isLoading,
    required this.errorMessage,
    required this.updateStudent,
    required this.addNote,
    required this.deleteNote,
    required this.reload,
    required super.child,
  });

  /// Mengambil provider terdekat dari [context].
  ///
  /// Gunakan `listen: false` di dalam callback untuk menghindari rebuild.
  static AppProvider of(BuildContext context, {bool listen = true}) {
    final provider = listen
        ? context.dependOnInheritedWidgetOfExactType<AppProvider>()
        : context.getInheritedWidgetOfExactType<AppProvider>();
    assert(provider != null, 'AppProvider tidak ditemukan di widget tree');
    return provider!;
  }

  @override
  bool updateShouldNotify(AppProvider oldWidget) {
    return student != oldWidget.student ||
        notes != oldWidget.notes ||
        isLoading != oldWidget.isLoading ||
        errorMessage != oldWidget.errorMessage;
  }
}

/// Mengelola state global dan menyediakan [AppProvider] ke subtree.
class AppProviderWrapper extends StatefulWidget {
  final Widget child;
  final NoteRepository? repository;
  final Student initialStudent;

  const AppProviderWrapper({
    super.key,
    required this.child,
    this.repository,
    this.initialStudent = const Student(
      name: 'Alfian Chandra',
      nim: '25.11.6580',
      programStudi: 'S1 Informatika',
      email: 'alfian@students.amikom.ac.id',
    ),
  });

  @override
  State<AppProviderWrapper> createState() => _AppProviderWrapperState();
}

class _AppProviderWrapperState extends State<AppProviderWrapper> {
  late final NoteRepository _repository;
  late Student _student;
  List<Note> _notes = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _repository = widget.repository ?? NoteRepository();
    _student = widget.initialStudent;
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final notes = await _repository.loadNotes();
      if (!mounted) return;
      setState(() {
        _notes = notes;
        _isLoading = false;
      });
    } catch (error) {
      Logger.error('Gagal memuat catatan', error: error);
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = 'Gagal memuat catatan. Silakan coba lagi.';
      });
    }
  }

  Future<void> _updateStudent(Student student) async {
    setState(() {
      _student = student;
    });
  }

  Future<void> _addNote(Note note) async {
    await _repository.addNote(note);
    if (!mounted) return;
    setState(() {
      _notes = [note, ..._notes.where((item) => item.id != note.id)];
    });
  }

  Future<void> _deleteNote(String noteId) async {
    await _repository.deleteNote(noteId);
    if (!mounted) return;
    setState(() {
      _notes = _notes.where((note) => note.id != noteId).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppProvider(
      student: _student,
      notes: List.unmodifiable(_notes),
      isLoading: _isLoading,
      errorMessage: _errorMessage,
      updateStudent: _updateStudent,
      addNote: _addNote,
      deleteNote: _deleteNote,
      reload: _loadNotes,
      child: widget.child,
    );
  }
}
