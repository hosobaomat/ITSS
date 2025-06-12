import 'package:flutter/material.dart';
import 'package:login_menu/models/foodItemsResponse.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:login_menu/service/auth_service.dart';
// import các model/service của bạn

class FoodInventoryScreen extends StatefulWidget {
  const FoodInventoryScreen(
      {super.key, required this.authService, required this.items});
  final AuthService authService;
  final List<FoodItemResponse> items;
  @override
  State<FoodInventoryScreen> createState() => _FoodInventoryScreenState();
}

class _FoodInventoryScreenState extends State<FoodInventoryScreen> {
  final TextEditingController searchController = TextEditingController();
  Future<List<foodCategory>>? foodCategoriesFuture;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<int> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) throw Exception('Token không tồn tại');
    final decodedToken = JwtDecoder.decode(token);
    final userId =
        decodedToken['userId']; // hoặc 'id' nếu backend dùng key khác
    if (userId == null) throw Exception('Không tìm thấy userId trong token');
    return userId;
  }

  Future<void> _loadData() async {
    try {
      final userId = await widget.authService.getUserId();
      final groupId = await widget.authService.getGroupIdByUserId(userId);

      setState(() {
        foodCategoriesFuture =
            widget.authService.fetchFoodItemsByGroup(groupId);
      });
    } catch (e) {
      // Bạn có thể show lỗi ở đây nếu muốn
      debugPrint('Lỗi load data: $e');
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  List<FoodItemResponse> filterFoodItems(
      List<foodCategory> categories, String query) {
    if (query.isEmpty) {
      return categories.expand((cat) => cat.foodItemResponses).toList();
    }
    return categories
        .expand((cat) => cat.foodItemResponses)
        .where(
            (item) => item.foodname.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Food Inventory'), actions: [
        IconButton(
          icon: const Icon(Icons.refresh),
          tooltip: 'Tải lại dữ liệu',
          onPressed: () {
            _loadData(); // Gọi lại hàm load
          },
        ),
      ]),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'Tìm kiếm thực phẩm...',
                prefixIcon: const Icon(Icons.search),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: FutureBuilder<List<foodCategory>>(
                future: foodCategoriesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Lỗi: ${snapshot.error}'));
                  }

                  final categories = snapshot.data ?? [];
                  // --- Đặt log ở đây ---
                  debugPrint('Fetched foodCategories:');
                  for (var cat in categories) {
                    debugPrint(
                        'Category: ${cat.categoryName}, items: ${cat.foodItemResponses.length}');
                    for (var item in cat.foodItemResponses) {
                      debugPrint(
                          '  - FoodItem: ${item.foodname}, SL: ${item.quantity}, Nơi: ${item.storageLocation}, HSD: ${item.expiryDate}');
                    }
                  }
                  // --- Kết thúc log ---
                  final query = searchController.text.trim();
                  final filtered = filterFoodItems(categories, query);

                  if (filtered.isEmpty) {
                    return const Center(child: Text('Không có thực phẩm nào.'));
                  }
                  return ListView.separated(
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => const Divider(),
                    itemBuilder: (context, index) {
                      final item = filtered[index];
                      return ListTile(
                        title: Text(item.foodname,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Số lượng: ${item.quantity} ${item.unitName}"),
                            Text("Nơi lưu trữ: ${item.storageLocation}"),
                            Text(
                                "Ngày hết hạn: ${item.expiryDate.day}/${item.expiryDate.month}/${item.expiryDate.year}"),
                            if (item.categoryName.isNotEmpty)
                              Text("Phân loại: ${item.categoryName}"),
                            if (item.storageSuggestion.isNotEmpty)
                              Text("Gợi ý bảo quản: ${item.storageSuggestion}"),
                          ],
                        ),
                        isThreeLine: true,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
