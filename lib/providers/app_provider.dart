import 'package:flutter/material.dart';
import '../models/student.dart';

/// Menyediakan state profil mahasiswa ke seluruh subtree.
class AppProvider extends InheritedWidget {
  final Student student;
  final Future<void> Function(Student) updateStudent;

  const AppProvider({
    super.key,
    required this.student,
    required this.updateStudent,
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
    return student != oldWidget.student;
  }
}

/// Mengelola state global dan menyediakan [AppProvider] ke subtree.
class AppProviderWrapper extends StatefulWidget {
  final Widget child;
  final Student initialStudent;

  const AppProviderWrapper({
    super.key,
    required this.child,
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
  late Student _student;

  @override
  void initState() {
    super.initState();
    _student = widget.initialStudent;
  }

  Future<void> _updateStudent(Student student) async {
    setState(() {
      _student = student;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppProvider(
      student: _student,
      updateStudent: _updateStudent,
      child: widget.child,
    );
  }
}
