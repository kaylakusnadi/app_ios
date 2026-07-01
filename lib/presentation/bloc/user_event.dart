// Updated: 2026-07-01 by Kayla
// Change: Menambahkan SearchUserEvent
// Reason: Untuk memicu proses pencarian user di API GitHub secara terpisah dari list popular
import '../../data/models/user_model.dart';

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
  final dynamic user;
  ToggleFavoriteEvent(this.user);
}

// Event baru
class SearchUserEvent extends UserEvent {
  final String query;
  SearchUserEvent(this.query);
}