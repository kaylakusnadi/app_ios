import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'data/services/api_service.dart';
import 'presentation/bloc/user_bloc.dart';
import 'presentation/bloc/notification_cubit.dart';
// Updated: 2026-07-01 by Kayla
// Change: Mengimpor ThemeCubit
// Reason: Untuk mendaftarkan state management tema secara global
import 'presentation/bloc/theme_cubit.dart';
import 'presentation/pages/splash_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => ApiService(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => UserBloc(context.read<ApiService>()),
          ),
          BlocProvider(
            create: (context) => NotificationCubit(),
          ),
// Updated: 2026-07-01 by Kayla
// Change: Mendaftarkan ThemeCubit ke dalam MultiBlocProvider
// Reason: Agar status tema (dark/light) bisa diakses dan diubah dari halaman manapun
          BlocProvider(
            create: (context) => ThemeCubit(),
          ),
        ],
// Updated: 2026-07-01 by Kayla
// Change: Membungkus MaterialApp dengan BlocBuilder dari ThemeCubit
// Reason: Agar MaterialApp merender ulang (re-build) seluruh UI ketika state tema berubah
        child: BlocBuilder<ThemeCubit, bool>(
          builder: (context, isDarkMode) {
            return MaterialApp(
              title: 'GitHub Mini App',
              themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
              theme: ThemeData(
                useMaterial3: true,
                colorScheme: ColorScheme.fromSeed(
                  seedColor: Colors.blue,
                  primary: Colors.blue,
                  brightness: Brightness.light,
                  surface: const Color(0xFFF8F9FA), // Latar belakang abu-abu muda
                ),
                scaffoldBackgroundColor: const Color(0xFFF8F9FA),
                appBarTheme: const AppBarTheme(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black87,
                  elevation: 0,
                  centerTitle: true,
                ),
                cardColor: Colors.white,
              ),
// Updated: 2026-07-01 by Kayla
// Change: Menambahkan konfigurasi darkTheme
// Reason: Mendefinisikan palet warna untuk mode gelap agar aplikasi tetap terlihat profesional dan terbaca
              darkTheme: ThemeData(
                useMaterial3: true,
                colorScheme: ColorScheme.fromSeed(
                  seedColor: Colors.blue,
                  primary: Colors.blue,
                  brightness: Brightness.dark,
                  surface: const Color(0xFF121212), // Latar belakang gelap khas Material
                ),
                scaffoldBackgroundColor: const Color(0xFF121212),
                appBarTheme: const AppBarTheme(
                  backgroundColor: Color(0xFF1E1E1E),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  centerTitle: true,
                ),
                cardColor: const Color(0xFF1E1E1E),
              ),
              home: const SplashPage(),
              debugShowCheckedModeBanner: false,
            );
          },
        ),
      ),
    );
  }
}