import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:login_menu/data/data_store.dart';
import 'package:login_menu/models/ShoppingListEditRequest.dart';
import 'package:login_menu/models/foodCatalogResponse.dart';
import 'package:login_menu/models/shopping_list_model.dart.dart';
import 'package:login_menu/models/unitResponse.dart';
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
  late TextEditingController _nameController;
  late DateTime _selectedDate;
  List<ShoppingItem> list1 = [];
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.list.listName);
    _selectedDate = widget.list.date;
    list1 = widget.list.items;
    if (DataStore().categories.isEmpty ||
        DataStore().foodCatalogs.isEmpty ||
        DataStore().units.isEmpty) {
      _loadData();
    }
    // for (var i in widget.list.items) {
    //   print('${i.name}-${i.quantity}-${i.unit}-${i.category}');
    // }
  }

  Future<void> _loadData() async {
    try {
      final categories = await widget.authService.getCatalog();
      final foodCatalogs = categories
          .expand((c) => c.foodCatalogResponses ?? [])
          .cast<FoodCatalogResponse>()//ep kieu
          .toList();

      final units = categories
          .expand((c) => c.unitResponses ?? [])
          .cast<UnitResponse>()//ep kieu
          .toList();
      DataStore().categories = categories;
      DataStore().foodCatalogs = foodCatalogs;
      DataStore().units = units;
    } catch (e) {
      print('error loading data: $e');
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

  Future<void> _saveChanges() async {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter list name')),
      );
      return;
    }

    setState(() => _isLoading = true);

    final request = Shoppinglisteditrequest(
      ShoppingListID: widget.list.listId,
      name: _nameController.text,
      date: _selectedDate,
      shoppinglistitem: list1, // Giữ nguyên danh sách item
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
            const Spacer(),
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
