import '../../data/models/user_model.dart';
import '../../data/models/user_detail_model.dart';

class UserState {
  final List<UserModel> users;
  final List<UserModel> favoriteUsers;
  final List<UserModel>? searchResult;
// Updated: 2026-07-01 by Kayla
// Change: Menambahkan field searchQuery
// Reason: Untuk menyimpan text pencarian dari UI agar dapat digunakan memfilter data di tab Favorite
  final String searchQuery;
  final bool isUsersLoading;
  final bool isDetailLoading;
  final String? usersError;
  final String? detailError;
  final int currentPage;
  final bool hasReachedMax;
  final UserDetailModel? detailUser;

  UserState({
    this.users = const [],
    this.favoriteUsers = const [],
    this.searchResult,
    this.searchQuery = "",
    this.isUsersLoading = false,
    this.isDetailLoading = false,
    this.usersError,
    this.detailError,
    this.currentPage = 1,
    this.hasReachedMax = false,
    this.detailUser,
  });

  UserState copyWith({
    List<UserModel>? users,
    List<UserModel>? favoriteUsers,
    List<UserModel>? searchResult,
    String? searchQuery,
    bool? isUsersLoading,
    bool? isDetailLoading,
    String? usersError,
    String? detailError,
    int? currentPage,
    bool? hasReachedMax,
    UserDetailModel? detailUser,
  }) {
    return UserState(
      users: users ?? this.users,
      favoriteUsers: favoriteUsers ?? this.favoriteUsers,
      searchResult: searchResult, 
      searchQuery: searchQuery ?? this.searchQuery,
      isUsersLoading: isUsersLoading ?? this.isUsersLoading,
      isDetailLoading: isDetailLoading ?? this.isDetailLoading,
      usersError: usersError ?? this.usersError,
      detailError: detailError ?? this.detailError,
      currentPage: currentPage ?? this.currentPage,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      detailUser: detailUser ?? this.detailUser,
    );
  }
}