abstract class UserEvent {}

class FetchUserListEvent extends UserEvent {
  final bool isRefresh;
  FetchUserListEvent({this.isRefresh = false});
}

class FetchUserDetailEvent extends UserEvent {
  final String username;
  FetchUserDetailEvent(this.username);
}

class ToggleFavoriteEvent extends UserEvent {
  final dynamic user; // Bisa UserModel atau UserDetailModel
  ToggleFavoriteEvent(this.user);
}