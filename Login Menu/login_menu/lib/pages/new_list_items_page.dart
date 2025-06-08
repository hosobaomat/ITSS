import 'package:flutter/material.dart';
import 'package:login_menu/data/data_store.dart';
import 'package:login_menu/models/selected_item.dart';
import 'package:login_menu/models/shoppinglist_request.dart';
import 'package:login_menu/pages/CategoryDetailScreen.dart';
import 'package:login_menu/service/UserAPI.dart' as UserAPI;
import 'package:login_menu/service/auth_service.dart';
import 'package:login_menu/models/shopping_list_model.dart.dart';
import 'package:login_menu/models/foodCatalogResponse.dart';
import 'package:login_menu/models/unitResponse.dart';
import 'package:login_menu/models/foodCategoryResponse.dart';
import 'package:login_menu/tabs/shoppinglist_tab.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewListItemsPage extends StatefulWidget {
  const NewListItemsPage({
    super.key,
    required this.authService,
    required this.listName,
    required this.selectedDate,
    this.userId,
    this.listId,
  });

  final AuthService authService;
  final String listName;
  final DateTime selectedDate;
  final int? userId;
  final int? listId;

  @override
  State<NewListItemsPage> createState() => _NewListItemsPageState();
}

class _NewListItemsPageState extends State<NewListItemsPage> {
  final Map<String, List<SelectedItem>> _selectedItemsByCategory = {};
  int? _userId;
  int? _listId;
  List<FoodCategoryResponse> _categories = [];
  List<FoodCatalogResponse> _foodCatalogs = [];
  List<UnitResponse> _units = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    print(
        'DEBUG: selectedDate received = ${widget.selectedDate}'); // Log ngày nhận
    _userId = widget.userId;
    _listId = widget.listId;
    if (_userId == null) {
      _loadUserId();
    }
    _loadData();
  }

  Future<void> _loadUserId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      print('Token in NewListItemsPage: $token');
      if (token == null || token.isEmpty) {
        throw Exception('Token không tồn tại. Vui lòng đăng nhập lại.');
      }

      final userInfo = await UserAPI.Userapi.getMyInfo();
      print('User info in NewListItemsPage: $userInfo');

      final userId = userInfo['userid'] as int?;
      if (userId != null) {
        await prefs.setInt('user_id', userId);
      }

      setState(() {
        _userId = userId;
      });
    } catch (e) {
      print('Error loading user info in NewListItemsPage: $e');
      setState(() {
        _userId = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text('Không thể tải thông tin người dùng. Vui lòng thử lại.')),
      );
    }
  }

  Future<void> _loadData() async {
    if (DataStore().categories.isEmpty ||
        DataStore().foodCatalogs.isEmpty ||
        DataStore().units.isEmpty) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Gọi API FoodCatalog để lấy danh sách danh mục
        final categories = await widget.authService.getCatalog();
        print('Raw categories from getCatalog: $categories');

        // Gán _categories ngay lập tức để đảm bảo danh mục hiển thị
        setState(() {
          _categories = categories;
        });

        // Kiểm tra và debug từng category
        for (var category in categories) {
          print('Category: ${category.categoryName}');
          print(
              'FoodCatalogResponses: ${category.foodCatalogResponses.map((f) => f.foodCatalogName).toList()}');
          print(
              'UnitResponses: ${category.unitResponses?.map((u) => u.toString()).toList()}');
        }

        // Tạo danh sách phẳng cho foodCatalogs và units
        final foodCatalogs = categories
            .expand((category) => category.foodCatalogResponses)
            .toList();
        print(
            'FoodCatalogs: ${foodCatalogs.map((f) => f.foodCatalogName).toList()}');

        final units = categories
            .expand((category) => category.unitResponses ?? [])
            .map((e) => e as UnitResponse)
            .toList();
        print('Units: ${units.map((u) => u.unitName).toList()}');
        final dataStore = DataStore();
        setState(() {
          _foodCatalogs = foodCatalogs;
          _units = units;
          _isLoading = false;
          // Lưu vào DataStore để dùng toàn app
          dataStore.categories = categories;
          dataStore.foodCatalogs = foodCatalogs;
          dataStore.units = units;
        });
      } catch (e) {
        print('Error loading data: $e');
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Không thể tải dữ liệu: $e')),
        );
      }
    } else {
      _categories = DataStore().categories;
      _foodCatalogs = DataStore().foodCatalogs;
      _units = DataStore().units;
      _isLoading = false;
    }
  }

  Widget _buildCategoryItem(IconData icon, FoodCategoryResponse category) {
    final isSelected =
        _selectedItemsByCategory[category.categoryName]?.isNotEmpty == true;

    return Column(
      children: [
        ListTile(
          leading: Icon(icon, size: 28),
          title: Text(category.categoryName ?? 'Unknown',
              style: const TextStyle(fontSize: 18)),
          trailing: isSelected
              ? const Icon(Icons.check_circle, color: Colors.green)
              : null,
          onTap: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => CategoryDetailScreen(
                  categoryName: category.categoryName ?? 'Unknown',
                  items: category.foodCatalogResponses
                      .map((food) => food.foodCatalogName ?? '')
                      .toList(),
                  selectedItems:
                      _selectedItemsByCategory[category.categoryName] ?? [],
                ),
              ),
            );

            if (result != null && result is List<SelectedItem>) {
              setState(() {
                _selectedItemsByCategory[category.categoryName ?? 'Unknown'] =
                    List<SelectedItem>.from(result);
              });
            }
          },
        ),
        const Divider(height: 1),
      ],
    );
  }

  Future<void> _handleCreateList() async {
    if (_userId == null) {
      await _loadUserId();
      if (_userId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Không tìm thấy User ID. Vui lòng đăng nhập lại.')),
        );
        return;
      }
    }

    if (_listId == null) {
      final request = ShoppingListCreateRequest(
        widget.listName,
        _userId!,
        _userId!,
        widget.selectedDate,
        widget.selectedDate.add(const Duration(days: 1)),
        'DRAFT',
      );
      print(
          'DEBUG: Creating ShoppingList with startDate=${request.startDate} endDate=${request.endDate}');
      try {
        final listResponse = await widget.authService.addShoppingList(request);
        _listId = listResponse['listid'] as int?;
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi khi tạo danh sách: ${e.toString()}')),
        );
        return;
      }
    }

    if (_listId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không thể lấy list_id')),
      );
      return;
    }

    try {
      if (_foodCatalogs.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Danh sách sản phẩm trống. Vui lòng thử lại sau.')),
        );
        return;
      }

      final itemsToSave = <Map<String, dynamic>>[];
      for (final entry in _selectedItemsByCategory.entries) {
        for (final selectedItem in entry.value) {
          print(
              'Selected item: ${selectedItem.name}, Quantity: ${selectedItem.quantity}, Unit: ${selectedItem.unit}');
          final foodCatalog = _foodCatalogs.firstWhere(
            (food) => food.foodCatalogName == selectedItem.name,
            orElse: () {
              print(
                  'Food catalog not found for: ${selectedItem.name}, Available: ${_foodCatalogs.map((f) => f.foodCatalogName).toList()}');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(
                        'Không tìm thấy sản phẩm ${selectedItem.name}. Vui lòng chọn lại.')),
              );
              return FoodCatalogResponse(0, '', ''); // Giá trị mặc định
            },
          );

          // Bỏ qua nếu foodCatalog không hợp lệ
          if (foodCatalog.foodCatalogId == 0) continue;

          final unit = _units.firstWhere(
            (unit) => unit.unitName == selectedItem.unit,
            orElse: () {
              print(
                  'Unit not found for: ${selectedItem.unit}, Available: ${_units.map((u) => u.unitName).toList()}');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(
                        'Không tìm thấy đơn vị ${selectedItem.unit}. Vui lòng chọn lại.')),
              );
              return UnitResponse(0, '', ''); // Giá trị mặc định
            },
          );

          // Bỏ qua nếu unit không hợp lệ
          if (unit.unidId == null || unit.unidId == 0) continue;

          itemsToSave.add({
            'name': selectedItem.name,
            'quantity': selectedItem.quantity.toDouble(),
            'unitId': unit.unidId,
            'foodCatalogId': foodCatalog.foodCatalogId,
          });
        }
      }

      if (itemsToSave.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
                  'Không có sản phẩm hợp lệ để lưu. Vui lòng kiểm tra lại.')),
        );
        return;
      }

      await widget.authService.addShoppingListItems(_listId!, itemsToSave);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tạo danh sách thành công')),
      );

      final items = _selectedItemsByCategory.entries
          .expand((entry) => entry.value.map(
                (selectedItem) => ShoppingItem(
                  selectedItem.id,
                  selectedItem.name,
                  Icons.shopping_cart,
                  false,
                  selectedItem.quantity.toDouble(),
                  selectedItem.unit,
                  category: entry.key,
                ),
              ))
          .toList();

      final newList = ShoppingListModel(
        listName: widget.listName,
        date: widget.selectedDate,
        items: items,
        listId: _listId,
      );
      print('DEBUG: Navigating to ShoppingListTab with date: ${newList.date}');
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => ShoppingListTab(
            authService: widget.authService,
          ),
        ),
        (route) =>
            false, // Xoá hết các màn hình trước và về lại ShoppingListTab
      );
    } catch (e) {
      print('Error in _handleCreateList: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<IconData> icons = [
      Icons.eco_outlined,
      Icons.set_meal_outlined,
      Icons.rice_bowl_outlined,
      Icons.local_fire_department_outlined,
      Icons.local_drink_outlined,
      Icons.cake_outlined,
      Icons.icecream_outlined,
      Icons.ac_unit_outlined,
    ];

    return Scaffold(
      appBar: AppBar(
        leading: TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('X', style: TextStyle(fontSize: 20)),
        ),
        title: const Text('Chọn sản phẩm', style: TextStyle(fontSize: 22)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Chọn sản phẩm', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _categories.isEmpty
                      ? const Center(child: Text('Không có danh mục nào'))
                      : ListView.builder(
                          itemCount: _categories.length,
                          itemBuilder: (context, index) {
                            final category = _categories[index];
                            final icon = icons[index % icons.length];
                            return _buildCategoryItem(icon, category);
                          },
                        ),
            ),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: _isLoading ? null : _handleCreateList,
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 14),
                  child: Text('Create', style: TextStyle(fontSize: 18)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
