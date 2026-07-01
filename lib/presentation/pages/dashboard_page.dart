import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/user_bloc.dart';
import '../bloc/user_event.dart';
import '../bloc/user_state.dart';
import '../bloc/notification_cubit.dart';
import 'notification_page.dart';
import '../widgets/user_card_widget.dart';
import 'favorite_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<UserBloc>().add(FetchUserListEvent());
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      context.read<UserBloc>().add(FetchUserListEvent());
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "GitHub Explorer",
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
          ),
          actions: [
            BlocBuilder<NotificationCubit, NotificationState>(
              builder: (context, state) {
// Updated: 2026-07-01 by Kayla
// Change: Memperbaiki posisi dan ukuran badge notifikasi
// Reason: Agar badge berbentuk titik rapi dan tidak menutupi area interaksi ikon lonceng utama
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.notifications_none_rounded),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const NotificationPage()),
                        );
                      },
                    ),
                    if (state.unreadCount > 0)
                      Positioned(
                        right: 8,
                        top: 10,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.redAccent,
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 16,
                            minHeight: 16,
                          ),
                          child: Text(
                            '${state.unreadCount}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ],
          bottom: const TabBar(
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.blue,
            indicatorWeight: 3.0,
            tabs: [
              Tab(icon: Icon(Icons.people_outline), text: "Popular"),
              Tab(icon: Icon(Icons.favorite_outline), text: "Favorite"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            BlocBuilder<UserBloc, UserState>(
              builder: (context, state) {
                if (state.isUsersLoading && state.users.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state.usersError != null && state.users.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Gagal memuat data:\n${state.usersError}",
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.red),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            onPressed: () {
                              context.read<UserBloc>().add(FetchUserListEvent(isRefresh: true));
                            },
                            child: const Text("Retry"),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                if (state.users.isEmpty) {
                  return const Center(child: Text("Tidak ada data user."));
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    context.read<UserBloc>().add(FetchUserListEvent(isRefresh: true));
                  },
                  child: ListView.builder(
                    controller: _scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.only(top: 12.0, bottom: 24.0),
                    itemCount: state.hasReachedMax ? state.users.length : state.users.length + 1,
                    itemBuilder: (context, index) {
                      if (index >= state.users.length) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 24.0),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                      final isFav = state.favoriteUsers.any((fav) => fav.login == state.users[index].login);
                      return UserCardWidget(
                        user: state.users[index],
                        isFavorite: isFav,
                      );
                    },
                  ),
                );
              },
            ),
            const FavoritePage(),
          ],
        ),
      ),
    );
  }
}