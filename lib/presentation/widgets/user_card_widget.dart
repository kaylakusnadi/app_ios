import 'package:flutter/material.dart';
import '../../data/models/user_model.dart';
import '../pages/user_detail_page.dart';

class UserCardWidget extends StatelessWidget {
  final UserModel user;
// Updated: 2026-07-01 by Kayla
// Change: Menambahkan parameter isFavorite dengan nilai default false
// Reason: Untuk memberikan indikator visual khusus jika user tersebut sudah berada di daftar favorit
  final bool isFavorite;

  const UserCardWidget({
    Key? key, 
    required this.user, 
    this.isFavorite = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => UserDetailPage(username: user.login)),
        );
      },
      child: Container(
// Updated: 2026-07-01 by Kayla
// Change: Mempersempit lebar card dengan mengubah horizontal margin dari 16.0 menjadi 24.0
// Reason: Menyesuaikan estetika UI agar tidak terlalu melebar (stretched) dan lebih nyaman dipandang
        margin: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24.0),
          border: Border.all(color: Colors.white, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
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
              backgroundColor: Colors.grey.shade100,
              backgroundImage: NetworkImage(user.avatarUrl),
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.login,
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.3,
                      color: Colors.black87,
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
// Updated: 2026-07-01 by Kayla
// Change: Menambahkan indikator ikon love kecil jika isFavorite bernilai true
// Reason: Memberikan pembeda visual antara data biasa dengan data yang sudah di-favorit-kan di halaman Dashboard
            if (isFavorite)
              const Padding(
                padding: EdgeInsets.only(right: 8.0),
                child: Icon(Icons.favorite, color: Colors.redAccent, size: 20.0),
              ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16.0,
              color: Colors.black26,
            ),
          ],
        ),
      ),
    );
  }
}