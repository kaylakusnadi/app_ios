import 'package:flutter_bloc/flutter_bloc.dart';

// Updated: 2026-07-01 by Kayla
// Change: Membuat ThemeCubit untuk manajemen state Dark/Light Mode
// Reason: Mengelola perubahan tema secara global di seluruh aplikasi menggunakan BLoC
class ThemeCubit extends Cubit<bool> {
  // false = Light Mode, true = Dark Mode
  ThemeCubit() : super(false);

  void toggleTheme() {
    emit(!state);
  }
}