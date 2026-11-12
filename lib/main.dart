import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'config/app_config.dart';
import 'providers/app_provider.dart';
import 'screens/home_screen.dart';
import 'utils/logger.dart';

/// Entry point aplikasi.
///
/// Memuat konfigurasi `.env` sebelum menjalankan aplikasi.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load(fileName: '.env');
  } catch (error) {
    Logger.error('Gagal memuat file .env', error: error);
  }

  if (!AppConfig.isConfigured()) {
    Logger.warning('Konfigurasi .env tidak lengkap. Periksa file .env.');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AppProviderWrapper(
      child: MaterialApp(
        title: 'Profil Mahasiswa & Catatan Kuliah',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
