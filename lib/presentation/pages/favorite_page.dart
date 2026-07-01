import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/user_bloc.dart';
import '../bloc/user_state.dart';
import '../widgets/user_card_widget.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state.favoriteUsers.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "👏",
                  style: TextStyle(fontSize: 48),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Yeay, Data Favorit Kosong",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Silahkan Refresh Page untuk memperbarui data",
                  style: TextStyle(
                    color: Colors.grey, 
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 28),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    elevation: 4,
                    shadowColor: Colors.blue.withOpacity(0.4),
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
// Updated: 2026-07-01 by Kayla
// Change: Mengubah perilaku tombol Refresh untuk memunculkan SnackBar
// Reason: Agar tidak otomatis kembali ke halaman Popular dan memberikan feedback lokal sesuai dengan best practice UX
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Sistem telah direfresh. Belum ada data yang difavoritkan.'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  child: const Text(
                    "Refresh",
                    style: TextStyle(
                      fontSize: 15, 
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.only(top: 12.0, bottom: 24.0),
          itemCount: state.favoriteUsers.length,
          itemBuilder: (context, index) {
// Updated: 2026-07-01 by Kayla
// Change: Mengirim isFavorite: true pada UserCardWidget
// Reason: Karena ini halaman Favorite, semua card otomatis menampilkan indikator heart icon
            return UserCardWidget(
              user: state.favoriteUsers[index],
              isFavorite: true,
            );
          },
        );
      },
    );
  }
}