import 'package:flutter/material.dart';
import '../../data/models/user_model.dart';
import '../pages/user_detail_page.dart';

class UserCardWidget extends StatelessWidget {
  final UserModel user;

  const UserCardWidget({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: CircleAvatar(
            radius: 25,
            backgroundImage: NetworkImage(user.avatarUrl),
          ),
          title: Text(user.login, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: const Text("User", style: TextStyle(color: Colors.grey)),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => UserDetailPage(username: user.login)),
            );
          },
        ),
        const Divider(indent: 16, endIndent: 16),
      ],
    );
  }
}