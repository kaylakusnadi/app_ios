import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/user_bloc.dart';
import '../bloc/user_event.dart';
import '../bloc/user_state.dart';

class UserDetailPage extends StatefulWidget {
  final String username;
  const UserDetailPage({Key? key, required this.username}) : super(key: key);

  @override
  State<UserDetailPage> createState() => _UserDetailPageState();
}

class _UserDetailPageState extends State<UserDetailPage> {
  @override
  void initState() {
    super.initState();
    context.read<UserBloc>().add(FetchUserDetailEvent(widget.username));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail User"),
        actions: [
          BlocBuilder<UserBloc, UserState>(
            builder: (context, state) {
              if (state.detailUser == null) return const SizedBox();
              final isFav = state.favoriteUsers.any((element) => element.login == state.detailUser!.login);
              return IconButton(
                icon: Icon(isFav ? Icons.favorite : Icons.favorite_border, color: Colors.red),
                onPressed: () {
                  context.read<UserBloc>().add(ToggleFavoriteEvent(state.detailUser!));
                },
              );
            },
          )
        ],
      ),
      body: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state.isDetailLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.detailError != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Gagal memuat detail: ${state.detailError}"),
                  ElevatedButton(
                    onPressed: () => context.read<UserBloc>().add(FetchUserDetailEvent(widget.username)),
                    child: const Text("Retry"),
                  )
                ],
              ),
            );
          }
          if (state.detailUser == null) return const SizedBox();

          final user = state.detailUser!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(radius: 50, backgroundImage: NetworkImage(user.avatarUrl)),
                const SizedBox(height: 10),
                Text(user.login, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                _buildDetailTile("Name", user.name),
                _buildDetailTile("E-Mail", user.email),
                _buildDetailTile("Location", user.location),
                _buildDetailTile("Company", user.company),
                _buildDetailTile("Followers", user.followers.toString()),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailTile(String title, String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.grey, fontSize: 14)),
          const SizedBox(height: 2),
          Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          const Divider(),
        ],
      ),
    );
  }
}