import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:login_menu/models/foodCategoryResponse.dart';
import 'package:login_menu/models/shoppinglist_request.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String apiUrl = "http://192.168.1.18:8082/ITSS_BE";
  String? _token;
  String? get token => _token;

  Future<void> loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
  }

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

        await prefs.setString('token', data['result']['token']);
        _token = data['result']['token'];
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

  Future<Map<String, dynamic>> addShoppingList(
      ShoppingListCreateRequest request) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    print(
        '${request.listName} - ${request.createdBy} - ${request.startDate}-${request.endDate} - ${request.group_id}');

    final response = await http.post(
      Uri.parse('$apiUrl/ShoppingList'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'listName': request.listName,
        'createdBy': request.createdBy.toString(),
        'group_id': request.group_id.toString(),
        'startDate': request.startDate?.toIso8601String(),
        'endDate': request.endDate?.toIso8601String(),
        'status': request.status ?? 'DRAFT',
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('Tạo danh sách thành công, list_id: ${data['list_id']}');
      return data;
    } else {
      print('Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Không thể tạo danh sách: ${response.body}');
    }
  }

  Future<void> addShoppingListItems(
      int listId, List<Map<String, dynamic>> items) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    print('Adding items for listid: $listId, items: $items');

    final response = await http.post(
      Uri.parse('$apiUrl/ShoppingList/addItem'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'listId': listId,
        'shoppingListItemRequests': items,
      }),
    );

    if (response.statusCode != 200) {
      print('Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      print(jsonEncode({
        'listId': listId,
        'shoppingListItemRequests': items,
      }));

      throw Exception('Không thể lưu danh sách mục: ${response.body}');
    }
  }

  Future<List<FoodCategoryResponse>> getCatalog() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token == null) {
        throw Exception('Token không tồn tại');
      }
      final response = await http.get(
        Uri.parse("$apiUrl/ShoppingList/FoodCatalog"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );
      if (response.statusCode == 200) {
        // Giải mã dữ liệu với UTF-8 trước khi jsonDecode
        final decodedBody = utf8.decode(response.bodyBytes);
        final data = jsonDecode(decodedBody);
        print("Raw data from FoodCatalog: $data");

        if (data['result'] is List) {
          return (data['result'] as List)
              .map((json) => FoodCategoryResponse.fromJson(json))
              .toList();
        } else {
          throw Exception('Dữ liệu result không phải là danh sách');
        }
      } else {
        print(
            "Lỗi lấy dữ liệu FoodCatalog: ${response.statusCode}, ${response.body}");
        throw Exception('Không thể lấy dữ liệu FoodCatalog: ${response.body}');
      }
    } catch (e) {
      print("Lỗi kết nối hoặc ánh xạ: $e");
      throw Exception('Lỗi kết nối: $e');
    }
  }
}
