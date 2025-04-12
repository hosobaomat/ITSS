import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static const String apiUrl =
      "http://192.168.0.104:5000"; // Đổi IP backend của bạn

  Future<bool> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse("$apiUrl/login"),
        body: jsonEncode({'username': username, 'password': password}),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
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
}
