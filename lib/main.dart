import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'data/services/api_service.dart';
import 'presentation/bloc/user_bloc.dart';
// Updated: 2026-07-01 by Kayla
// Change: Mengimpor NotificationCubit
// Reason: Agar cubit notifikasi dikenali oleh sistem
import 'presentation/bloc/notification_cubit.dart';
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
// Updated: 2026-07-01 by Kayla
// Change: Mengubah BlocProvider tunggal menjadi MultiBlocProvider dan mendaftarkan NotificationCubit
// Reason: Mendukung manajemen state notifikasi secara global tanpa merusak UserBloc
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => UserBloc(context.read<ApiService>()),
          ),
          BlocProvider(
            create: (context) => NotificationCubit(),
          ),
        ],
        child: MaterialApp(
          title: 'GitHub Mini App',
          theme: ThemeData(
// Updated: 2026-07-01 by Kayla
// Change: Mengatur konfigurasi ColorScheme Material 3, splashColor, dan progressIndicatorTheme
// Reason: Menimpa warna bawaan Material 3 (ungu) agar efek hover TabBar dan indikator loading konsisten berwarna biru.
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.blue,
              primary: Colors.blue,
            ),
            splashColor: Colors.blue.withOpacity(0.1),
            highlightColor: Colors.transparent,
            progressIndicatorTheme: const ProgressIndicatorThemeData(
              color: Colors.blue,
            ),
            primarySwatch: Colors.blue,
            scaffoldBackgroundColor: const Color(0xFFF8F9FA),
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black87,
              elevation: 0,
              centerTitle: true,
            ),
          ),
          home: const SplashPage(),
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}