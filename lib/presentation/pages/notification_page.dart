import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart'; // Tambahkan package intl di pubspec.yaml jika belum ada
import '../bloc/notification_cubit.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  void initState() {
    super.initState();
    context.read<NotificationCubit>().markAsRead();
  }

  List<TextSpan> _buildRichText(String text) {
    final parts = text.split('|');
    List<TextSpan> spans = [];
    for (int i = 0; i < parts.length; i++) {
      if (i % 2 != 0) {
        spans.add(TextSpan(
          text: parts[i],
          style: TextStyle(fontWeight: FontWeight.w700, color: Theme.of(context).textTheme.bodyLarge?.color, fontSize: 14),
        ));
      } else {
        spans.add(TextSpan(
          text: parts[i],
          style: const TextStyle(fontWeight: FontWeight.normal, color: Colors.grey, fontSize: 14),
        ));
      }
    }
    return spans;
  }

  @override
  Widget build(BuildContext context) {
    // Menggunakan warna scaffold dari tema untuk latar belakang
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("Notifikasi", style: TextStyle(fontWeight: FontWeight.w700)),
      ),
      body: BlocBuilder<NotificationCubit, NotificationState>(
        builder: (context, state) {
          if (state.items.isEmpty) {
            return const Center(child: Text("Belum ada riwayat notifikasi.", style: TextStyle(color: Colors.grey)));
          }
          return ListView.builder(
            padding: const EdgeInsets.only(top: 16.0, bottom: 24.0),
            itemCount: state.items.length,
            itemBuilder: (context, index) {
              final item = state.items[index];
              final isDeleteAction = item.message.contains("Menghapus");
              final formattedTime = DateFormat('HH:mm').format(item.timestamp);
              
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 16.0, offset: const Offset(0, 8)),
                  ],
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: isDeleteAction ? Colors.red.shade50 : Colors.blue.shade50,
                      radius: 24,
                      child: Icon(isDeleteAction ? Icons.favorite_border : Icons.favorite, color: isDeleteAction ? Colors.redAccent : Colors.blueAccent, size: 20),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(text: TextSpan(children: _buildRichText(item.message))),
                          const SizedBox(height: 4),
                          Text(formattedTime, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}