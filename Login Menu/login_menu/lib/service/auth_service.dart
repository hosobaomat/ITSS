import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String apiUrl =
      "http://192.168.1.18:5000"; // Đổi IP backend của bạn

  Future<bool> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse("$apiUrl/login"),
        body: jsonEncode({'username': username, 'password': password}),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', data['token']); // Lưu token
        // Lưu token vào SharedPreferences hoặc xử lý token nếu cần thiết
        print("Đăng nhập thành công, token: ${data['token']}");
        return true;
      } else {
        print("Lỗi đăng nhập: ${response.statusCode}, ${response.body}");
        return false;
      }
    } catch (e) {
      print("Lỗi kết nối: $e");
      return false;
    }
  }

  Future<Map<String, dynamic>> fetchShoppingLists() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');

  if (token == null) {
    throw Exception('Token không tồn tại. Vui lòng đăng nhập lại.');
  }

  final response = await http.get(
    Uri.parse('$apiUrl/shopping-lists'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Lỗi: ${response.statusCode} - ${response.body}');
  }
}
  Future<void> addShoppingList(
      String title, List<Map<String, dynamic>> items) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    final response = await http.post(
      Uri.parse('$apiUrl/shopping-lists'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'title': title,
        'items': items,
      }),
    );

    if (response.statusCode == 201) {
      print('Tạo giỏ hàng thành công');
    } else {
      throw Exception('Không thể tạo giỏ hàng');
    }
  }
}
