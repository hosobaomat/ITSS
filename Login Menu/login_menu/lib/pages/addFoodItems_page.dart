import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:login_menu/models/foodCategoryResponse.dart';
import 'package:login_menu/models/foodCatalogResponse.dart';
import 'package:login_menu/models/unitResponse.dart';
import 'package:login_menu/service/auth_service.dart';

class AddNewFoodItemScreen extends StatefulWidget {
  final AuthService authService;
  final int? userId;
  final int? groupId;
  const AddNewFoodItemScreen({
    super.key,
    required this.authService,
    this.userId,
    this.groupId,
  });

  @override
  State<AddNewFoodItemScreen> createState() => _AddNewFoodItemScreenState();
}

class _AddNewFoodItemScreenState extends State<AddNewFoodItemScreen> {
  final _formKey = GlobalKey<FormState>();
  FoodCatalogResponse? _selectedProduct;
  UnitResponse? _selectedUnit;
  String? _selectedStorage;
  final TextEditingController _quantityController = TextEditingController();
  DateTime? _expiryDate;

  List<FoodCatalogResponse> _allProducts = [];
  List<UnitResponse> _availableUnits = [];
  List<String> _storageLocations = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchInitialData();
  }

  Future<void> _fetchInitialData() async {
    setState(() => _loading = true);
    // 1. Lấy toàn bộ catalog (danh mục và món ăn, đơn vị)
    List<FoodCategoryResponse> categories =
        await widget.authService.getCatalog();
    // 2. Trích ra tất cả món ăn
    Set<FoodCatalogResponse> allProductsSet = {};
    for (var c in categories) {
      allProductsSet.addAll(c.foodCatalogResponses);
    }
    List<FoodCatalogResponse> allProducts = allProductsSet.toList();
    allProducts.sort((a, b) => a.foodCatalogName.compareTo(b.foodCatalogName));

    // 3. Lấy nơi lưu trữ
    List<String> storageLocations =
        await widget.authService.getStorageLocations();

    setState(() {
      _allProducts = allProducts;
      _storageLocations = storageLocations;
      _loading = false;
    });
  }

  void _onProductChanged(FoodCatalogResponse? product) async {
    setState(() {
      _selectedProduct = product;
      _selectedUnit = null;
      _availableUnits = [];
    });
    if (product == null) return;
    List<FoodCategoryResponse> categories =
        await widget.authService.getCatalog();
    // Tìm category chứa món này
    for (var cat in categories) {
      if (cat.foodCatalogResponses
          .any((item) => item.foodCatalogId == product.foodCatalogId)) {
        setState(() {
          _availableUnits = cat.unitResponses?.toList() ?? [];
        });
        return;
      }
    }
    setState(() => _availableUnits = []);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Thêm sản phẩm mới')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    DropdownButtonFormField<FoodCatalogResponse>(
                      value: _selectedProduct,
                      items: _allProducts.map((item) {
                        return DropdownMenuItem(
                          value: item,
                          child: Text(item.foodCatalogName),
                        );
                      }).toList(),
                      decoration:
                          const InputDecoration(labelText: 'Tên sản phẩm'),
                      onChanged: _onProductChanged,
                      validator: (v) => v == null ? 'Chọn sản phẩm' : null,
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<UnitResponse>(
                      value: _selectedUnit,
                      items: _availableUnits.map((unit) {
                        return DropdownMenuItem(
                          value: unit,
                          child: Text(unit.unitName),
                        );
                      }).toList(),
                      decoration: const InputDecoration(labelText: 'Đơn vị'),
                      onChanged: (v) => setState(() => _selectedUnit = v),
                      validator: (v) => v == null ? 'Chọn đơn vị' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _quantityController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Số lượng'),
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Nhập số lượng' : null,
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: _selectedStorage,
                      items: _storageLocations.map((loc) {
                        return DropdownMenuItem(
                          value: loc,
                          child: Text(loc),
                        );
                      }).toList(),
                      decoration:
                          const InputDecoration(labelText: 'Nơi lưu trữ'),
                      onChanged: (v) => setState(() => _selectedStorage = v),
                      validator: (v) => v == null ? 'Chọn nơi lưu trữ' : null,
                    ),
                    const SizedBox(height: 12),
                    InkWell(
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now()
                              .add(const Duration(days: 365 * 10)),
                        );
                        if (picked != null) {
                          setState(() => _expiryDate = picked);
                        }
                      },
                      child: InputDecorator(
                        decoration:
                            const InputDecoration(labelText: 'Ngày hết hạn'),
                        child: Text(_expiryDate != null
                            ? DateFormat('dd/MM/yyyy').format(_expiryDate!)
                            : 'Chọn ngày'),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Center(
                      child: ElevatedButton(
                        onPressed: _onAddPressed,
                        child: const Text('Thêm mới'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  void _onAddPressed() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedProduct == null ||
        _selectedUnit == null ||
        _selectedStorage == null ||
        _expiryDate == null) return;

    // Tạo đúng map gửi lên backend
    final newFoodItem = {
      "foodCatalogId": _selectedProduct!.foodCatalogId,
      "foodName": _selectedProduct!.foodCatalogName,
      "quantity": int.tryParse(_quantityController.text) ?? 1,
      "unitId": _selectedUnit!.unidId,
      "expiryDate": _expiryDate!.toIso8601String(),
      "storageLocation": _selectedStorage!,
    };

    try {
      await widget.authService.addFoodItems(
        [newFoodItem],
        userId: widget.userId!,
        groupId: widget.groupId!,
      );
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Thêm thành công!')));
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Lỗi khi thêm: $e')));
      }
    }
  }
}
