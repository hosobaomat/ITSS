import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:login_menu/models/shopping_list_create_request.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String apiUrl =
      "http://192.168.100.14:8082/ITSS_BE"; // Đổi IP backend của bạn
  String? _token;
  String? get token => _token;

  Future<void> loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
  }

  // Phương thức để lấy token từ SharedPreferences

  Future<bool> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse("$apiUrl/auth/log-in"),
        body: jsonEncode({'email': username, 'password': password}),
        headers: {"Content-Type": "application/json"},
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final prefs = await SharedPreferences.getInstance();

        await prefs.setString('token', data['result']['token']); // Lưu token
        _token = data['result']['token'];
        // Lưu token vào SharedPreferences hoặc xử lý token nếu cần thiết
        print("Đăng nhập thành công, token: ${data['result']['token']}");
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

  Future<void> addShoppingList(ShoppingListCreateRequest request) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    print('${request.listName} - ${request.createdBy} - ${request.startDate}-${request.endDate} - ${request.group_id}');
    final response = await http.post(
      Uri.parse('$apiUrl/ShoppingList'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'listName': request.listName,
        'createdBy': request.createdBy,
        'group_id': request.group_id,
        'startDate': request.startDate?.toIso8601String(),
        'endDate': request.endDate?.toIso8601String(),
        'status': 'new'
      }),
    );

    if (response.statusCode == 200) {
      print('Tạo giỏ hàng thành công');
    } else {
      print('Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Không thể tạo giỏ hàng');
    }
  }
}
