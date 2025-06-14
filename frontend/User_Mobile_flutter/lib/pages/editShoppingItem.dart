import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:login_menu/data/data_store.dart';
import 'package:login_menu/models/ShoppingListEditRequest.dart';
import 'package:login_menu/models/foodCatalogResponse.dart';
import 'package:login_menu/models/foodCategoryResponse.dart';
import 'package:login_menu/models/selected_item.dart';
import 'package:login_menu/models/shopping_list_model.dart.dart';
import 'package:login_menu/models/unitResponse.dart';
import 'package:login_menu/pages/CategoryDetailScreen.dart';
import 'package:login_menu/service/auth_service.dart';
import 'package:login_menu/tabs/shoppinglist_tab.dart';

class Editshoppingitem extends StatefulWidget {
  final ShoppingListModel list;
  final AuthService authService;
  const Editshoppingitem(
      {super.key, required this.list, required this.authService});

  @override
  State<Editshoppingitem> createState() => _EditshoppingitemState();
}

class _EditshoppingitemState extends State<Editshoppingitem> {
  final Map<String, List<SelectedItem>> _selectedItemsByCategory = {};
  late TextEditingController _nameController;
  late DateTime _selectedDate;
  List<ShoppingItem> list1 = [];
  List<FoodCategoryResponse> _categories = [];
  List<FoodCatalogResponse> _foodCatalogs = [];
  List<UnitResponse> _units = [];
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.list.listName);
    _selectedDate = widget.list.date;
    list1 = widget.list.items.map((item) {
      final foodCatalog = DataStore().foodCatalogs.firstWhere(
        (food) => food.foodCatalogName == item.name,
        orElse: () => FoodCatalogResponse(0, '', ''),
      );
      final unit = DataStore().units.firstWhere(
        (unit) => unit.unitName == item.unit,
        orElse: () => UnitResponse(0, '', ''),
      );
      return ShoppingItem(
        item.id,
        item.name,
        item.icon,
        item.checked,
        item.quantity,
        item.unit,
        unitId: unit.unidId != 0 ? unit.unidId : null,
        foodCatalogId: foodCatalog.foodCatalogId != 0 ? foodCatalog.foodCatalogId : null,
        category: item.category,
      );
    }).toList();
    if (DataStore().categories.isEmpty ||
        DataStore().foodCatalogs.isEmpty ||
        DataStore().units.isEmpty) {
      _loadData();
    } else {
      _categories = DataStore().categories;
      _foodCatalogs = DataStore().foodCatalogs;
      _units = DataStore().units;
    }
    // for (var i in widget.list.items) {
    //   print('${i.name}-${i.quantity}-${i.unit}-${i.category}');
    // }
  }
  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final categories = await widget.authService.getCatalog();
      final foodCatalogs = categories
          .expand((c) => c.foodCatalogResponses ?? [])
          .cast<FoodCatalogResponse>() //ep kieu
          .toList();

      final units = categories
          .expand((c) => c.unitResponses ?? [])
          .cast<UnitResponse>() //ep kieu
          .toList();
      setState(() {
        DataStore().categories = categories;
        DataStore().foodCatalogs = foodCatalogs;
        DataStore().units = units;
        _categories = categories;
        _foodCatalogs = foodCatalogs;
        _units = units;
      });
    } catch (e) {
      print('error loading data: $e');
    }finally {
      setState(() => _isLoading = false);
    }
  }

  void _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
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
                          ?.map((food) => food.foodCatalogName ?? '')
                          .toList() ??
                      [],
                  selectedItems:
                      _selectedItemsByCategory[category.categoryName] ?? [],
                ),
              ),
            );

            if (result != null && result is List<SelectedItem>) {
              setState(() {
                _selectedItemsByCategory[category.categoryName ?? 'Unknown'] =
                    List<SelectedItem>.from(result);
                     // Chuyển đổi SelectedItem thành ShoppingItem
                final newItems = result.map((selectedItem) {
                  final foodCatalog = _foodCatalogs.firstWhere(
                    (food) => food.foodCatalogName == selectedItem.name,
                    orElse: () => FoodCatalogResponse(0, '', ''),
                  );
                  final unit = _units.firstWhere(
                    (unit) => unit.unitName == selectedItem.unit,
                    orElse: () => UnitResponse(0, '', ''),
                  );
                  return ShoppingItem(
                    selectedItem.id,
                    selectedItem.name,
                    Icons.shopping_cart,
                    false,
                    selectedItem.quantity.toDouble(),
                    selectedItem.unit,
                    unitId: unit.unidId != 0 ? unit.unidId : null,
                    foodCatalogId:
                        foodCatalog.foodCatalogId != 0 ? foodCatalog.foodCatalogId : null,
                    category: category.categoryName,
                  );
                }).toList();
                // Thêm hoặc cập nhật vào list1
                for (var newItem in newItems) {
                  final index = list1.indexWhere((item) => item.name == newItem.name);
                  if (index != -1) {
                    list1[index] = newItem;
                  } else {
                    list1.add(newItem);
                  }
                }
              });
            }
          },
        ),
        const Divider(height: 1),
      ],
    );
  }

  Future<void> _saveChanges() async {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter list name')),
      );
      return;
    }

    setState(() => _isLoading = true);
    // Đảm bảo list1 có unitId và foodCatalogId
    final updatedList1 = list1.map((item) {
      final foodCatalog = _foodCatalogs.firstWhere(
        (food) => food.foodCatalogName == item.name,
        orElse: () => FoodCatalogResponse(0, '', ''),
      );
      final unit = _units.firstWhere(
        (unit) => unit.unitName == item.unit,
        orElse: () => UnitResponse(0, '', ''),
      );
      return ShoppingItem(
        item.id,
        item.name,
        item.icon,
        item.checked,
        item.quantity,
        item.unit,
        unitId: unit.unidId != 0 ? unit.unidId : item.unitId,
        foodCatalogId: foodCatalog.foodCatalogId != 0
            ? foodCatalog.foodCatalogId
            : item.foodCatalogId,
        category: item.category,
      );
    }).toList();
    final request = Shoppinglisteditrequest(
      ShoppingListID: widget.list.listId,
      name: _nameController.text,
      date: _selectedDate,
      shoppinglistitem: updatedList1, // Giữ nguyên danh sách item
    );

    try {
      await widget.authService.ediShoppingList(request); // Hàm API PATCH
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('List updated successfully')),
      );
      Navigator.pop(context, true); // Quay lại và báo đã cập nhật thành công
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Update failed: ${e.toString()}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateText = DateFormat('EEE, dd/MM/yyyy').format(_selectedDate);
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
        title: const Text('Edit List Info'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('List Name', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                hintText: 'Enter list name...',
              ),
            ),
            const SizedBox(height: 24),
            const Text('Date', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _pickDate,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                width: double.infinity,
                child: Text(
                  dateText,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
            Expanded(
              child: _isLoading
                  ?  Center(child: LoadingAnimationWidget.threeRotatingDots(
                        color: Colors.pink,
                        size: 50,
                      ))
                  : _categories.isEmpty
                      ? const Center(child: Text('No categories available'))
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
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _saveChanges,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 14),
                        child: Text('Save Changes',
                            style: TextStyle(fontSize: 18)),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
