import '../../data/models/user_model.dart';
import '../../data/models/user_detail_model.dart';

class UserState {
  // List Users (Popular)
  final List<UserModel> users;
  final bool isUsersLoading;
  final String? usersError;
  final int currentPage;
  final bool hasReachedMax;

  // Detail User
  final UserDetailModel? detailUser;
  final bool isDetailLoading;
  final String? detailError;

  // Favorite In-Memory
  final List<UserModel> favoriteUsers;

  UserState({
    this.users = const [],
    this.isUsersLoading = false,
    this.usersError,
    this.currentPage = 1,
    this.hasReachedMax = false,
    this.detailUser,
    this.isDetailLoading = false,
    this.detailError,
    this.favoriteUsers = const [],
  });

  UserState copyWith({
    List<UserModel>? users,
    bool? isUsersLoading,
    String? usersError,
    int? currentPage,
    bool? hasReachedMax,
    UserDetailModel? detailUser,
    bool? isDetailLoading,
    String? detailError,
    List<UserModel>? favoriteUsers,
  }) {
    return UserState(
      users: users ?? this.users,
      isUsersLoading: isUsersLoading ?? this.isUsersLoading,
      usersError: usersError,
      currentPage: currentPage ?? this.currentPage,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      detailUser: detailUser ?? this.detailUser,
      isDetailLoading: isDetailLoading ?? this.isDetailLoading,
      detailError: detailError,
      favoriteUsers: favoriteUsers ?? this.favoriteUsers,
    );
  }
}