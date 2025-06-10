import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:login_menu/data/data_store.dart';
import 'package:login_menu/models/ShoppingListEditRequest.dart';
import 'package:login_menu/models/consumptionTrend.dart';
import 'package:login_menu/models/createMealPlan.dart';
import 'package:login_menu/models/createUser.dart';
import 'package:login_menu/models/foodCategoryResponse.dart';
import 'package:login_menu/models/foodItemsResponse.dart';
import 'package:login_menu/models/getMealPlan.dart';
import 'package:login_menu/models/getmissingIngredient.dart';
import 'package:login_menu/models/recipeInput.dart';
import 'package:login_menu/models/recipesResponse.dart';
import 'package:login_menu/models/shoppinglist_request.dart';
import 'package:login_menu/models/updateItemRequest.dart';
import 'package:login_menu/models/ItemsForStatistics.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class AuthService {
  static const String apiUrl = "http://192.168.100.3:8082/ITSS_BE";
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

  Future<List<dynamic>> fetchShoppingListsByUserId(int userId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    final response = await http.get(
      Uri.parse('$apiUrl/ShoppingList/user/$userId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final decodedBody = utf8.decode(response.bodyBytes);
      final data = jsonDecode(decodedBody);
      return data['result'] ?? [];
    } else {
      print('Lỗi lấy danh sách theo userId: ${response.statusCode}');
      throw Exception('Error: ${response.body}');
    }
  }

  Future<List<dynamic>> fetchShoppingListsByGroupId(int groupId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    final response = await http.get(
      Uri.parse('$apiUrl/ShoppingList/group/$groupId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final decodedBody = utf8.decode(response.bodyBytes);
      final data = jsonDecode(decodedBody);
      return data['result'] ?? [];
    } else {
      print('Lỗi lấy danh sách theo groupId: ${response.statusCode}');
      throw Exception('Error: ${response.body}');
    }
  }

  Future<List<Recipesresponse>> fetchRecipesByUser() async {
    final url = Uri.parse('$apiUrl/Recipe');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final decodedBody = utf8.decode(response.bodyBytes);
      final jsonResponse = jsonDecode(decodedBody);

      if (jsonResponse['code'] == 0) {
        final List<dynamic> resultList = jsonResponse['result'];

        return resultList
            .map((json) => Recipesresponse.fromJson(json))
            .toList();
      } else {
        throw Exception('API trả về lỗi: code != 0');
      }
    } else {
      throw Exception('Lỗi kết nối: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> addShoppingList(
      ShoppingListCreateRequest request) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    print(
        '${request.listName} - ${request.createdBy} - ${request.startDate}-${request.endDate} - ${request.group_id}');

    final dateFormat = DateFormat('yyyy-MM-dd');

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
        'startDate': request.startDate != null
            ? dateFormat.format(request.startDate!)
            : null,
        'endDate': request.endDate != null
            ? dateFormat.format(request.endDate!)
            : null,
        'status': request.status,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final listId = data['result']?['id'];
      print('Tạo danh sách thành công, list_id: $listId');
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

  Future<int> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) throw Exception('Token không tồn tại');

    final decodedToken = JwtDecoder.decode(token);
    final userId =
        decodedToken['userId']; // hoặc 'id' nếu backend dùng key khác
    if (userId == null) throw Exception('Không tìm thấy userId trong token');
    DataStore().userId = userId; // Lưu userId vào DataStore
    return userId;
  }

  Future<String> getUserbyId(int userId) async {
    //lay ten nguoi ban userId nhan duoc
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null || token.isEmpty) {
      throw Exception('Token không tồn tại. Vui lòng đăng nhập lại.');
    }
    final url = Uri.parse('$apiUrl/users/$userId');
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String username = data['result']['username'];
        if (username.isEmpty) {
          throw Exception('Không tìm thấy username cho userId $userId');
        }
        return username;
      } else {
        throw Exception(
            'Không thể lấy dữ liệu groupId: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Lỗi kết nối: $e');
    }
  }

  Future<int> getGroupIdByUserId(int userId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null || token.isEmpty) {
      throw Exception('Token không tồn tại. Vui lòng đăng nhập lại.');
    }

    // URL API để lấy groupId theo userId
    final url = Uri.parse('$apiUrl/family_group/user/$userId');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final groupId = data['result']['id']; // Lấy groupId từ phản hồi
        if (groupId == null) {
          throw Exception('Không tìm thấy groupId cho userId $userId');
        }
        return groupId;
      } else {
        throw Exception(
            'Không thể lấy dữ liệu groupId: ${response.statusCode}');
      }
    } catch (e) {
      print("Lỗi khi lấy groupId: $e");
      throw Exception('Lỗi kết nối: $e');
    }
  }

  Future<void> deleteShoppingList(int listId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token'); // Lấy token từ SharedPreferences

    if (token == null || token.isEmpty) {
      throw Exception('Token không tồn tại. Vui lòng đăng nhập lại.');
    }

    final response = await http.delete(
      Uri.parse('$apiUrl/ShoppingList/$listId'), // API DELETE với listId
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
        'Authorization': 'Bearer $token', // Thêm token vào header
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Không thể xóa danh sách. Lỗi: ${response.body}');
    }

    print('Danh sách với listId $listId đã được xóa khỏi MySQL');
  }

  Future<void> ediShoppingList(Shoppinglisteditrequest list) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token'); // Lấy token từ SharedPreferences

    if (token == null || token.isEmpty) {
      throw Exception('Token không tồn tại. Vui lòng đăng nhập lại.');
    }

    final response = await http.patch(
      Uri.parse('$apiUrl/ShoppingList/1'), // API DELETE với listId
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
        'Authorization': 'Bearer $token', // Thêm token vào header
      },
      body: jsonEncode({
        'shoppingListId': list.ShoppingListID,
        'shoppingListName': list.name,
        'startDate': list.date?.toIso8601String(),
        'shoppingListItemRequests':
            list.shoppinglistitem.map((item) => item.toJson()).toList(),
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Không thể cập nhật danh sách. Lỗi: ${response.body}');
    }

    print('Danh sách đã được chỉnh sửa');
  }

  Future<void> markItemAsPurchased(int itemId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    final url = Uri.parse('$apiUrl/ShoppingList/purchased/$itemId');

    try {
      final response = await http.patch(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update item status');
      } else {
        print('Item status updated successfully');
      }
    } catch (e) {
      print('Error in markItemAsPurchased: $e');
      throw Exception('Failed to update item status');
    }
  }

  Future<Map<String, dynamic>?> markShoppingListAsPurchased(int listId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    final url = Uri.parse('$apiUrl/ShoppingList/FinishList/$listId');
    final response = await http.patch(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    print('Status code: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final body = jsonDecode(utf8.decode(response.bodyBytes));
      if (body['code'] == 0) {
        return body; // <-- Trả về cả body
      } else {
        print('API trả về code != 0');
      }
    } else {
      print('API trả về lỗi status: ${response.statusCode}');
    }
    return null;
  }

  Future<Map<String, dynamic>> fetchGroupData(int groupId) async {
    final url = '$apiUrl/family_group/$groupId';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // Parse dữ liệu JSON và trả về
        return jsonDecode(response.body);
      } else {
        throw Exception('Lỗi khi lấy dữ liệu nhóm');
      }
    } catch (e) {
      throw Exception('Lỗi kết nối: $e');
    }
  }

  Future<List<foodCategory>> fetchFoodItemsByGroup(int groupId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    final url = Uri.parse('$apiUrl/FoodItems/group/$groupId');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      // Sửa dòng này:
      final body = jsonDecode(utf8.decode(response.bodyBytes));
      final List<dynamic> result = body['result'];
      return result.map((e) => foodCategory.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load food items');
    }
  }

  Future<List<String>> getStorageLocations() async {
    print('[DEBUG] Bắt đầu gọi API lấy storage locations');
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    final url = Uri.parse('$apiUrl/FoodItems/Storage');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print('[DEBUG] Status code: ${response.statusCode}');
      print('[DEBUG] Response body: ${utf8.decode(response.bodyBytes)}');

      if (response.statusCode == 200) {
        final body = jsonDecode(utf8.decode(response.bodyBytes));
        List<dynamic> results = body['result'];
        print('[DEBUG] Results trả về: $results');
        return results.cast<String>();
      } else {
        print('[ERROR] Failed to fetch storage locations: ${response.body}');
        throw Exception('Failed to fetch storage locations');
      }
    } catch (e, stack) {
      print('[ERROR] Exception khi lấy storage locations: $e');
      print('[ERROR] Stacktrace: $stack');
      rethrow;
    }
  }

  Future<void> updateFoodItem(UpdateItemRequest request) async {
    final url = Uri.parse('$apiUrl/FoodItems');
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    print('[DEBUG] Body gửi lên backend: ${request.toJson()}');
    print(
        '[DEBUG] Body gửi lên backend (json): ${jsonEncode(request.toJson())}');
    final response = await http.patch(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode != 200) {
      print('[DEBUG] updateFoodItem FAILED status: ${response.statusCode}');
      print('[DEBUG] updateFoodItem FAILED body: ${response.body}');
      throw Exception('Cập nhật thất bại');
    }
  }

  Future<bool> addMealPlan(Createmealplan items) async {
    //tao meal plan
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    final response = await http.post(Uri.parse('$apiUrl/mealplans'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(items.toJson()));
    if (response.statusCode == 200 || response.statusCode == 201) {
      print("Tạo Meal Plan thành công");
      return true;
    } else {
      print("Lỗi khi tạo Meal Plan: ${response.statusCode}");
      print("Body: ${response.body}");
      return false;
    }
  }

  Future<void> deleteMealPlanbyId(int planId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token'); // Lấy token từ SharedPreferences

    if (token == null || token.isEmpty) {
      throw Exception('Token không tồn tại. Vui lòng đăng nhập lại.');
    }

    final response = await http.delete(
      Uri.parse('$apiUrl/mealplans/$planId'), // API DELETE với listId
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
        'Authorization': 'Bearer $token', // Thêm token vào header
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Không thể xóa danh sách. Lỗi: ${response.body}');
    }

    print('Danh sách với listId $planId đã được xóa khỏi MySQL');
  }

  Future<List<MealPlanResponse>> fetchMealPlansByGroupId(int GroupID) async {
    //lay mealplan
    final response = await http.get(
      Uri.parse('$apiUrl/mealplans/group/$GroupID'),
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
        'Authorization': 'Bearer $token', // Thêm token vào header
      },
    );

    if (response.statusCode == 200) {
      final decodedBody = utf8.decode(response.bodyBytes);
      final jsonData = json.decode(decodedBody);
      final List<dynamic> plansJson = jsonData['result'];
      return plansJson.map((e) => MealPlanResponse.fromJson(e)).toList();
    } else {
      throw Exception(
        'Failed to load meal plans',
      );
    }
  }

  Future<List<Recipesresponse>> fetchRecipesSuggest(int groupID) async {
    final url = Uri.parse('$apiUrl/Recipe/suggestRecipe/$groupID');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final decodedBody = utf8.decode(response.bodyBytes);
      final jsonResponse = jsonDecode(decodedBody);

      if (jsonResponse['code'] == 200) {
        final List<dynamic> resultList = jsonResponse['result'];

        return resultList
            .map((json) => Recipesresponse.fromJson(json))
            .toList();
      } else {
        throw Exception('API trả về lỗi: code != 0');
      }
    } else {
      throw Exception('Lỗi kết nối: ${response.statusCode}');
    }
  }

  Future<List<Getmissingingredient>> fetchSingleRecipeMissing(
      // Hàm gọi API cho một RecipeInput
      RecipeInput input) async {
    final url = Uri.parse(
        '$apiUrl/Recipe/missingIngredient/${input.recipeId}/${input.groupId}');
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        final decodedBody = utf8.decode(response.bodyBytes);
        final jsonResponse = jsonDecode(decodedBody);

        if (jsonResponse['code'] == 200) {
          final List<dynamic> resultList = jsonResponse['result'];

          return resultList
              .map((json) => Getmissingingredient.fromJson(json))
              .toList();
        } else {
          throw Exception('API trả về lỗi: code != 200');
        }
      } else {
        throw Exception('Failed to fetch recipe items: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching recipe items: $e');
    }
  }

  Future<List<Getmissingingredient>> getRecipeItems(
      // Hàm gọi API cho danh sách RecipeInput
      List<RecipeInput> input) async {
    try {
      final futures =
          input.map((input) => fetchSingleRecipeMissing(input)).toList();
      final result = await Future.wait(futures, eagerError: true);
      return result.expand((itemList) => itemList).toList();
    } catch (e) {
      throw Exception('Error fetching recipe items: $e');
    }
  }

}
