import 'package:flutter/material.dart';
import '../../data/models/user_model.dart';
import '../pages/user_detail_page.dart';

class UserCardWidget extends StatelessWidget {
  final UserModel user;
  final bool isFavorite;

  const UserCardWidget({
    Key? key, 
    required this.user, 
    this.isFavorite = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
// Updated: 2026-07-01 by Kayla
// Change: Mengambil properti warna dinamis dari konteks tema
// Reason: Agar komponen 3D Bubble Card bisa beradaptasi otomatis saat Dark Mode aktif
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => UserDetailPage(username: user.login)),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(24.0),
          border: Border.all(
            color: isDark ? Colors.white12 : Colors.white, 
            width: 1.5
          ),
          boxShadow: [
            BoxShadow(
              color: isDark ? Colors.black.withOpacity(0.3) : Colors.black.withOpacity(0.06),
              blurRadius: 24.0,
              spreadRadius: 0.0,
              offset: const Offset(0, 12),
            ),
            BoxShadow(
              color: Colors.blue.withOpacity(0.03),
              blurRadius: 10.0,
              spreadRadius: 2.0,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28.0,
              backgroundColor: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
              backgroundImage: NetworkImage(user.avatarUrl),
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.login,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.3,
                      // Warna teks mengikuti tema (putih saat dark mode, hitam saat light mode)
                      color: Theme.of(context).textTheme.bodyLarge?.color, 
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  const Text(
                    "GitHub User",
                    style: TextStyle(
                      fontSize: 13.0,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            if (isFavorite)
              const Padding(
                padding: EdgeInsets.only(right: 8.0),
                child: Icon(Icons.favorite, color: Colors.redAccent, size: 20.0),
              ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16.0,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}