import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationItem {
  final String message;
  final DateTime timestamp;

  NotificationItem({required this.message, required this.timestamp});
}

class NotificationState {
  final List<NotificationItem> items;
  final int unreadCount;

  NotificationState({required this.items, required this.unreadCount});

  NotificationState copyWith({List<NotificationItem>? items, int? unreadCount}) {
    return NotificationState(
      items: items ?? this.items,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }
}

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit() : super(NotificationState(items: [], unreadCount: 0));

  void addNotification(String message) {
    final newItem = NotificationItem(message: message, timestamp: DateTime.now());
    final updatedItems = List<NotificationItem>.from(state.items)..insert(0, newItem);
    emit(state.copyWith(
      items: updatedItems,
      unreadCount: state.unreadCount + 1,
    ));
  }

  void markAsRead() {
    emit(state.copyWith(unreadCount: 0));
  }
}