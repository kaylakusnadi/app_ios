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
// Updated: 2026-07-01 by Kayla
// Change: Menyimpan status tema (gelap/terang) ke dalam variabel isDark
// Reason: Untuk menyesuaikan warna latar, border, dan bayangan kartu detail agar responsif terhadap tema
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
                    backgroundColor: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
                    backgroundImage: NetworkImage(user.avatarUrl),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  user.login,
                  style: TextStyle(
                    fontSize: 24, 
                    fontWeight: FontWeight.bold,
// Updated: 2026-07-01 by Kayla
// Change: Mengubah warna teks judul agar responsif terhadap tema
// Reason: Agar teks tetap terbaca saat Dark Mode aktif
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
                const SizedBox(height: 32),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
// Updated: 2026-07-01 by Kayla
// Change: Mengubah warna background container menjadi dinamis dan menambahkan border transparan
// Reason: Menerapkan konsep 3D Clear Bubble yang menyesuaikan dengan Dark/Light mode
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(24.0),
                    border: Border.all(
                      color: isDark ? Colors.white12 : Colors.white, 
                      width: 1.5
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: isDark ? Colors.black.withOpacity(0.3) : Colors.black.withOpacity(0.04),
                        blurRadius: 20.0,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _buildDetailTile(context, Icons.person_outline, "Name", user.name),
                      const Divider(height: 24),
                      _buildDetailTile(context, Icons.email_outlined, "E-Mail", user.email),
                      const Divider(height: 24),
                      _buildDetailTile(context, Icons.location_on_outlined, "Location", user.location),
                      const Divider(height: 24),
                      _buildDetailTile(context, Icons.business_outlined, "Company", user.company),
                      const Divider(height: 24),
                      _buildDetailTile(context, Icons.people_alt_outlined, "Followers", user.followers.toString()),
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

// Updated: 2026-07-01 by Kayla
// Change: Menambahkan parameter BuildContext ke _buildDetailTile
// Reason: Agar fungsi ini dapat mengakses konteks tema untuk warna teks yang dinamis
  Widget _buildDetailTile(BuildContext context, IconData icon, String title, String value) {
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
                style: TextStyle(
                  fontSize: 16, 
                  fontWeight: FontWeight.w600, 
// Updated: 2026-07-01 by Kayla
// Change: Mengubah warna teks detail (value) agar mengikuti tema
// Reason: Menghindari teks hitam yang tidak terlihat pada latar belakang gelap
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}