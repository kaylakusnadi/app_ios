import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

// Updated: 2026-07-01 by Kayla
// Change: Menambahkan fungsi parsing teks dengan RichText
// Reason: Mengidentifikasi bagian teks yang diapit delimiter '|' untuk diberikan font bold
  List<TextSpan> _buildRichText(String text) {
    final parts = text.split('|');
    List<TextSpan> spans = [];
    for (int i = 0; i < parts.length; i++) {
      if (i % 2 != 0) {
        // Teks di antara delimiter | (Username)
        spans.add(TextSpan(
          text: parts[i],
          style: const TextStyle(fontWeight: FontWeight.w700, color: Colors.black87, fontSize: 14),
        ));
      } else {
        // Teks biasa
        spans.add(TextSpan(
          text: parts[i],
          style: const TextStyle(fontWeight: FontWeight.normal, color: Colors.black54, fontSize: 14),
        ));
      }
    }
    return spans;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
// Updated: 2026-07-01 by Kayla
// Change: Mengubah background color dan desain list
// Reason: Menyelaraskan dengan tema 3D Clear Bubble pada halaman Dashboard
      backgroundColor: const Color(0xFFF8F9FA), 
      appBar: AppBar(
        title: const Text("Notifikasi", style: TextStyle(fontWeight: FontWeight.w700)),
      ),
      body: BlocBuilder<NotificationCubit, NotificationState>(
        builder: (context, state) {
          if (state.messages.isEmpty) {
            return const Center(
              child: Text(
                "Belum ada riwayat notifikasi.",
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.only(top: 16.0, bottom: 24.0),
            itemCount: state.messages.length,
            itemBuilder: (context, index) {
              final rawMessage = state.messages[index];
              final isDeleteAction = rawMessage.contains("Menghapus");
              
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.0),
                  border: Border.all(color: Colors.white, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 16.0,
                      spreadRadius: 0.0,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: isDeleteAction ? Colors.red.shade50 : Colors.blue.shade50,
                      radius: 24,
                      child: Icon(
                        isDeleteAction ? Icons.favorite_border : Icons.favorite, 
                        color: isDeleteAction ? Colors.redAccent : Colors.blueAccent, 
                        size: 20
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              children: _buildRichText(rawMessage),
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            "Baru saja", 
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
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