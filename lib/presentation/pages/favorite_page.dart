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
                const Text("👏🏻", style: TextStyle(fontSize: 50)),
                const SizedBox(height: 10),
                const Text(
                  "Yeay, Data Favorit Kosong",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.cyan),
                ),
                const Text("Silahkan Refresh Page untuk memperbarui data", style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () {}, // Sesuai mockup gambar, hanya memicu ui refresh state
                  child: const Text("Refresh"),
                )
              ],
            ),
          );
        }

        return ListView.builder(
          itemCount: state.favoriteUsers.length,
          itemBuilder: (context, index) {
            return UserCardWidget(user: state.favoriteUsers[index]);
          },
        );
      },
    );
  }
}