import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Userapi {
  static const String apiUrl =
      "http://192.168.1.18:8082/ITSS_BE"; // Đổi IP backend của bạn
  String? _token;
  String? get token => _token;

  static Future<Map<String, dynamic>> getMyInfo() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token == null) {
        throw Exception('Token không tồn tại');
      }
      final response = await http.get(
        Uri.parse("$apiUrl/users/my-info"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("Lấy thông tin user thành công: $data");
        return data['result'];
        ; // Trả về dữ liệu người dùng
      } else {
        print(
            "Lỗi lấy thông tin user: ${response.statusCode}, ${response.body}");
        throw Exception('Không thể lấy thông tin người dùng: ${response.body}');
      }
    } catch (e) {
      print("Lỗi kết nối: $e");
      throw Exception('Lỗi kết nối: $e');
    }
  }
}
