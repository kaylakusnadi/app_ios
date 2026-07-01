import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/user_bloc.dart';
import '../bloc/user_event.dart';
import '../bloc/user_state.dart';
import '../bloc/notification_cubit.dart';
// Updated: 2026-07-01 by Kayla
// Change: Mengimpor ThemeCubit
// Reason: Untuk mengakses aksi ubah tema dari tombol AppBar
import '../bloc/theme_cubit.dart';
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
// Updated: 2026-07-01 by Kayla
// Change: Menambahkan tombol toggle tema (Light/Dark) di sebelah notifikasi
// Reason: Praktik UX modern yang memudahkan pengguna mengganti tema tanpa masuk ke menu tersembunyi
            BlocBuilder<ThemeCubit, bool>(
              builder: (context, isDarkMode) {
                return IconButton(
                  icon: Icon(isDarkMode ? Icons.light_mode_rounded : Icons.dark_mode_rounded),
                  onPressed: () {
                    context.read<ThemeCubit>().toggleTheme();
                  },
                );
              },
            ),
            BlocBuilder<NotificationCubit, NotificationState>(
              builder: (context, state) {
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
                          constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
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
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                onChanged: (value) => context.read<UserBloc>().add(SearchUserEvent(value)),
                decoration: InputDecoration(
                  hintText: "Cari user...",
                  prefixIcon: const Icon(Icons.search, color: Colors.blue),
                  filled: true,
// Updated: 2026-07-01 by Kayla
// Change: Mengubah fillColor TextField menjadi responsif terhadap tema
// Reason: Menghindari kotak putih mencolok saat aplikasi dalam mode gelap
                  fillColor: Theme.of(context).cardColor,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(color: Colors.blue, width: 2),
                  ),
                ),
              ),
            ),
            const TabBar(
              labelColor: Colors.blue,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.blue,
              indicatorWeight: 3.0,
              tabs: [
                Tab(icon: Icon(Icons.people_outline), text: "Popular"),
                Tab(icon: Icon(Icons.favorite_outline), text: "Favorite"),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  BlocBuilder<UserBloc, UserState>(
                    builder: (context, state) {
                      final listToShow = state.searchResult ?? state.users;
                      
                      if (state.isUsersLoading && state.users.isEmpty) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (listToShow.isEmpty) {
                        return const Center(
                          child: Text(
                            "Tidak ada hasil pencarian di Popular.",
                            style: TextStyle(color: Colors.grey, fontSize: 16),
                          ),
                        );
                      }

                      return RefreshIndicator(
                        onRefresh: () async {
                          context.read<UserBloc>().add(FetchUserListEvent(isRefresh: true));
                        },
                        child: ListView.builder(
                          controller: _scrollController,
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.only(top: 12.0, bottom: 24.0),
                          itemCount: (state.searchResult != null || state.hasReachedMax) 
                              ? listToShow.length 
                              : listToShow.length + 1,
                          itemBuilder: (context, index) {
                            if (index >= listToShow.length) {
                              return const Padding(
                                padding: EdgeInsets.symmetric(vertical: 24.0),
                                child: Center(child: CircularProgressIndicator()),
                              );
                            }
                            final isFav = state.favoriteUsers.any((fav) => fav.login == listToShow[index].login);
                            return UserCardWidget(
                              user: listToShow[index],
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
          ],
        ),
      ),
    );
  }
}