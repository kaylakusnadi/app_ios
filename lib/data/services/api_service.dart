import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';
import '../models/user_detail_model.dart';

class ApiService {
  final String baseUrl = "https://api.github.com";

  Future<List<UserModel>> fetchUsers(int page) async {
    final response = await http.get(Uri.parse(
        "$baseUrl/search/users?q=followers%3A%3E%3D1000&ref=searchresults&s=followers&type=Users&page=$page&per_page=10"));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List items = data['items'];
      return items.map((json) => UserModel.fromJson(json)).toList();
    } else {
      throw Exception("Gagal memuat data user github");
    }
  }

  Future<UserDetailModel> fetchUserDetail(String username) async {
    final response = await http.get(Uri.parse("$baseUrl/users/$username"));

    if (response.statusCode == 200) {
      return UserDetailModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Gagal memuat detail user");
    }
  }
}