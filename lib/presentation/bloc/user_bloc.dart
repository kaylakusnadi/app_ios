import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/services/api_service.dart';
import '../../data/models/user_model.dart';
import '../../data/models/user_detail_model.dart';
import 'user_event.dart';
import 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final ApiService apiService;

  UserBloc(this.apiService) : super(UserState()) {
    on<FetchUserListEvent>(_onFetchUserList);
    on<FetchUserDetailEvent>(_onFetchUserDetail);
    on<ToggleFavoriteEvent>(_onToggleFavorite);
    on<SearchUserEvent>(_onSearchUsers);
  }

  void _onSearchUsers(SearchUserEvent event, Emitter<UserState> emit) {
    if (event.query.isEmpty) {
// Updated: 2026-07-01 by Kayla
// Change: Mengembalikan searchQuery menjadi string kosong ("")
// Reason: Agar tab Favorite kembali menampilkan semua data favorit saat text di search bar dihapus
      emit(state.copyWith(searchResult: null, searchQuery: ""));
    } else {
      final filtered = state.users
          .where((user) => user.login.toLowerCase().contains(event.query.toLowerCase()))
          .toList();
// Updated: 2026-07-01 by Kayla
// Change: Menyimpan event.query ke dalam state.searchQuery
// Reason: Untuk mendistribusikan keyword pencarian ke UI (termasuk FavoritePage)
      emit(state.copyWith(searchResult: filtered, searchQuery: event.query));
    }
  }

  Future<void> _onFetchUserList(FetchUserListEvent event, Emitter<UserState> emit) async {
    if (state.hasReachedMax && !event.isRefresh) return;

    try {
      if (event.isRefresh) {
// Updated: 2026-07-01 by Kayla
// Change: Me-reset searchQuery menjadi string kosong saat dilakukan refresh (Pull to Refresh)
// Reason: Mengembalikan daftar menjadi normal dan membatalkan status pencarian aktif
        emit(state.copyWith(isUsersLoading: true, users: [], currentPage: 1, hasReachedMax: false, searchResult: null, searchQuery: ""));
      } else if (state.users.isEmpty) {
        emit(state.copyWith(isUsersLoading: true));
      }

      final newUsers = await apiService.fetchUsers(state.currentPage);
      
      if (newUsers.isEmpty) {
        emit(state.copyWith(isUsersLoading: false, hasReachedMax: true));
      } else {
        emit(state.copyWith(
          isUsersLoading: false,
          users: state.users + newUsers,
          currentPage: state.currentPage + 1,
          hasReachedMax: newUsers.length < 5,
        ));
      }
    } catch (e) {
      emit(state.copyWith(isUsersLoading: false, usersError: e.toString()));
    }
  }

  Future<void> _onFetchUserDetail(FetchUserDetailEvent event, Emitter<UserState> emit) async {
    emit(state.copyWith(isDetailLoading: true));
    try {
      final detail = await apiService.fetchUserDetail(event.username);
      emit(state.copyWith(isDetailLoading: false, detailUser: detail));
    } catch (e) {
      emit(state.copyWith(isDetailLoading: false, detailError: e.toString()));
    }
  }

  void _onToggleFavorite(ToggleFavoriteEvent event, Emitter<UserState> emit) {
    List<UserModel> updatedFavorites = List.from(state.favoriteUsers);
    
    UserModel userToToggle;
    if (event.user is UserDetailModel) {
      userToToggle = UserModel(
        login: event.user.login,
        id: 0, 
        avatarUrl: event.user.avatarUrl,
      );
    } else {
      userToToggle = event.user;
    }

    final isExist = updatedFavorites.any((element) => element.login == userToToggle.login);

    if (isExist) {
      updatedFavorites.removeWhere((element) => element.login == userToToggle.login);
    } else {
      updatedFavorites.add(userToToggle);
    }

    emit(state.copyWith(favoriteUsers: updatedFavorites));
  }
}