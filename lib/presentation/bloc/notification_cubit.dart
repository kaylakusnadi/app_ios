import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationState {
  final List<String> messages;
  final int unreadCount;

  NotificationState({required this.messages, required this.unreadCount});

  NotificationState copyWith({List<String>? messages, int? unreadCount}) {
    return NotificationState(
      messages: messages ?? this.messages,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }
}

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit() : super(NotificationState(messages: [], unreadCount: 0));

  void addNotification(String message) {
    final updatedMessages = List<String>.from(state.messages)..insert(0, message);
    emit(state.copyWith(
      messages: updatedMessages,
      unreadCount: state.unreadCount + 1,
    ));
  }

  void markAsRead() {
    emit(state.copyWith(unreadCount: 0));
  }
}