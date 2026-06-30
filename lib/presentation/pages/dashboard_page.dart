import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/user_bloc.dart';
import '../bloc/user_event.dart';
import '../bloc/user_state.dart';
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
    // Memicu fetch data pertama kali saat halaman dibuka
    context.read<UserBloc>().add(FetchUserListEvent());
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    // Lazy load / Pagination: trigger fetch saat scroll menyentuh ujung bawah
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
          title: const Text("Github Apps Demo"),
          actions: [
            IconButton(
              icon: const Icon(Icons.info_outline),
              onPressed: () {},
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.people), text: "Popular"),
              Tab(icon: Icon(Icons.favorite), text: "Favorite"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // ==================== TAB POPULAR ====================
            BlocBuilder<UserBloc, UserState>(
              builder: (context, state) {
                // Kondisi 1: Loading di awal saat data masih kosong
                if (state.isUsersLoading && state.users.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                // Kondisi 2: Error Handling saat fetch gagal dan data kosong (Wajib ada Retry Button)
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

                // Kondisi 3: Data Kosong dari API
                if (state.users.isEmpty) {
                  return const Center(child: Text("Tidak ada data user."));
                }

                // Kondisi 4: Sukses Menampilkan Data + Pull to Refresh + Lazy Loading
                return RefreshIndicator(
                  onRefresh: () async {
                    context.read<UserBloc>().add(FetchUserListEvent(isRefresh: true));
                  },
                  child: ListView.builder(
                    controller: _scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: state.hasReachedMax ? state.users.length : state.users.length + 1,
                    itemBuilder: (context, index) {
                      if (index >= state.users.length) {
                        // Indikator loading tambahan di bawah list saat lazy load berjalan
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                      return UserCardWidget(user: state.users[index]);
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