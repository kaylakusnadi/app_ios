import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/user_bloc.dart';
import '../bloc/user_event.dart';
import '../bloc/user_state.dart';
import '../bloc/notification_cubit.dart';

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
                  context.read<UserBloc>().add(ToggleFavoriteEvent(state.detailUser as dynamic));
                  
// Updated: 2026-07-01 by Kayla
// Change: Memodifikasi format string dengan menambahkan karakter delimiter '|'
// Reason: Agar halaman notifikasi dapat memisahkan dan menebalkan teks username secara presisi
                  final rawMessage = isFav 
                      ? "Menghapus |${state.detailUser!.login}| dari favorit" 
                      : "Berhasil menambahkan |${state.detailUser!.login}| ke favorit";
                      
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(rawMessage.replaceAll('|', '')),
                      duration: const Duration(seconds: 2),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                  
                  context.read<NotificationCubit>().addNotification(rawMessage);
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
                  const SizedBox(height: 16),
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
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Hero(
                  tag: user.login,
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.grey.shade200,
                    backgroundImage: NetworkImage(user.avatarUrl),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  user.login,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 32),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 20.0,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _buildDetailTile(Icons.person_outline, "Name", user.name),
                      const Divider(height: 24),
                      _buildDetailTile(Icons.email_outlined, "E-Mail", user.email),
                      const Divider(height: 24),
                      _buildDetailTile(Icons.location_on_outlined, "Location", user.location),
                      const Divider(height: 24),
                      _buildDetailTile(Icons.business_outlined, "Company", user.company),
                      const Divider(height: 24),
                      _buildDetailTile(Icons.people_alt_outlined, "Followers", user.followers.toString()),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailTile(IconData icon, String title, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.blue.shade300, size: 24),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Colors.grey, fontSize: 13)),
              const SizedBox(height: 4),
              Text(
                value.isNotEmpty ? value : "-",
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87),
              ),
            ],
          ),
        ),
      ],
    );
  }
}