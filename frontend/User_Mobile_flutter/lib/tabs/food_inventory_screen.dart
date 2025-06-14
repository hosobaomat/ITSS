import 'package:flutter/material.dart';
import 'package:login_menu/data/data_store.dart';
import 'package:login_menu/models/foodItemsResponse.dart';
import 'package:login_menu/pages/addFoodItems_page.dart';
import 'package:login_menu/service/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class FoodInventoryScreen extends StatefulWidget {
  const FoodInventoryScreen({
    super.key,
    required this.authService,
    required this.items,
  });
  final AuthService authService;
  final List<FoodItemResponse> items;

  @override
  State<FoodInventoryScreen> createState() => _FoodInventoryScreenState();
}

class _FoodInventoryScreenState extends State<FoodInventoryScreen> {
  final TextEditingController searchController = TextEditingController();
  List<foodCategory> categories = [];
  List<FoodItemResponse> filteredItems = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadData();
    searchController.addListener(_filterItems);
  }

  Future<int> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) throw Exception('Token không tồn tại');
    final decodedToken = JwtDecoder.decode(token);
    final userId =
        decodedToken['userId']; // Hoặc 'id' nếu backend dùng key khác
    if (userId == null) throw Exception('Không tìm thấy userId trong token');
    return userId;
  }

  Future<void> _loadData() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      final userId = await widget.authService.getUserId();
      final groupId = await widget.authService.getGroupIdByUserId(userId);
      final fetchedCategories =
          await widget.authService.fetchFoodItemsByGroup(groupId);

      setState(() {
        categories = fetchedCategories;
        filteredItems =
            categories.expand((cat) => cat.foodItemResponses).toList();
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Lỗi tải dữ liệu: $e';
        isLoading = false;
      });
      debugPrint('Lỗi load data: $e');
    }
  }

  void _filterItems() {
    final query = searchController.text.trim().toLowerCase();
    setState(() {
      if (query.isEmpty) {
        filteredItems =
            categories.expand((cat) => cat.foodItemResponses).toList();
      } else {
        filteredItems = categories
            .expand((cat) => cat.foodItemResponses)
            .where((item) =>
                item.foodname != null &&
                item.foodname.toLowerCase().contains(query))
            .toList();
      }
    });
  }

  @override
  void dispose() {
    searchController.removeListener(_filterItems);
    searchController.dispose();
    super.dispose();
  }

  Map<String, List<FoodItemResponse>> _groupItemsByCategory() {
    final groupedItems = <String, List<FoodItemResponse>>{};
    for (var cat in categories) {
      final categoryName = cat.categoryName ?? 'Uncategorized';
      groupedItems[categoryName] = cat.foodItemResponses
          .where((item) => filteredItems.contains(item))
          .toList();
    }
    // Loại bỏ các danh mục rỗng
    groupedItems.removeWhere((key, value) => value.isEmpty);
    return groupedItems;
  }

  @override
  Widget build(BuildContext context) {
    final query = searchController.text.trim();
    final groupedItems = _groupItemsByCategory();

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
              decoration: InputDecoration(
                hintText: 'Tìm kiếm thực phẩm...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : errorMessage != null
                      ? Center(child: Text(errorMessage!))
                      : filteredItems.isEmpty
                          ? const Center(child: Text('Không có thực phẩm nào.'))
                          : query.isEmpty
                              ? ListView.builder(
                                  itemCount: groupedItems.keys.length,
                                  itemBuilder: (context, index) {
                                    final categoryName =
                                        groupedItems.keys.elementAt(index);
                                    final itemsInCategory =
                                        groupedItems[categoryName]!;

                                    return ExpansionTile(
                                      title: Text(
                                        categoryName,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      children: itemsInCategory.map((item) {
                                        return ListTile(
                                          title: Text(item.foodname),
                                          subtitle: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  'Số lượng: ${item.quantity} ${item.unitName}'),
                                              Text(
                                                  'Nơi lưu trữ: ${item.storageLocation}'),
                                              Text(
                                                'Ngày hết hạn: ${item.expiryDate.day}/${item.expiryDate.month}/${item.expiryDate.year}',
                                              ),
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                    );
                                  },
                                )
                              : ListView.builder(
                                  itemCount: filteredItems.length,
                                  itemBuilder: (context, index) {
                                    final item = filteredItems[index];
                                    return ListTile(
                                      title: Text(item.foodname),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              'Số lượng: ${item.quantity} ${item.unitName}'),
                                          Text(
                                              'Nơi lưu trữ: ${item.storageLocation}'),
                                          Text(
                                            'Ngày hết hạn: ${item.expiryDate.day}/${item.expiryDate.month}/${item.expiryDate.year}',
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AddNewFoodItemScreen(
                    authService: widget.authService,
                    userId: DataStore().userId,
                    groupId: DataStore().GroupID)),
          ).then((_) {
            // Làm mới dữ liệu sau khi thêm thực phẩm mới
            _loadData();
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
