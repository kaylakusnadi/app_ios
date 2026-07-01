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
        // Kondisi 1: Daftar favorit memang benar-benar kosong dari awal
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

// Updated: 2026-07-01 by Kayla
// Change: Melakukan filtering pada daftar favorit jika searchQuery di state tidak kosong
// Reason: Agar tab Favorite bereaksi terhadap input pengguna pada Search Bar di Dashboard
        final listToShow = state.searchQuery.isEmpty 
            ? state.favoriteUsers 
            : state.favoriteUsers.where((u) => u.login.toLowerCase().contains(state.searchQuery.toLowerCase())).toList();

// Updated: 2026-07-01 by Kayla
// Change: Menambahkan empty state spesifik saat pencarian tidak cocok dengan list favorit mana pun
// Reason: Memberikan umpan balik UX yang membedakan antara "Favorit Kosong" dan "Pencarian Tidak Ditemukan"
        if (listToShow.isEmpty) {
          return const Center(
            child: Text(
              "Tidak ada hasil pencarian di Favorit.",
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          );
        }

        // Menampilkan data favorit yang sudah difilter
        return ListView.builder(
          padding: const EdgeInsets.only(top: 12.0, bottom: 24.0),
          itemCount: listToShow.length,
          itemBuilder: (context, index) {
            return UserCardWidget(
              user: listToShow[index],
              isFavorite: true,
            );
          },
        );
      },
    );
  }
}