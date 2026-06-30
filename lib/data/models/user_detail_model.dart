class UserDetailModel {
  final String login;
  final String avatarUrl;
  final String name;
  final String email;
  final String location;
  final String company;
  final int followers;

  UserDetailModel({
    required this.login,
    required this.avatarUrl,
    required this.name,
    required this.email,
    required this.location,
    required this.company,
    required this.followers,
  });

  factory UserDetailModel.fromJson(Map<String, dynamic> json) {
    return UserDetailModel(
      login: json['login'] ?? '',
      avatarUrl: json['avatar_url'] ?? '',
      name: json['name'] ?? '-',
      email: json['email'] ?? '-',
      location: json['location'] ?? '-',
      company: json['company'] ?? '-',
      followers: json['followers'] ?? 0,
    );
  }
}