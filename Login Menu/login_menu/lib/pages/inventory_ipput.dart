import 'package:flutter/material.dart';
import 'package:login_menu/models/fooditem.dart';
import 'package:login_menu/models/update_item.dart';
import 'package:provider/provider.dart';

class InventoryItemInputWidget extends StatefulWidget {
  final List<FoodItem> items;

  const InventoryItemInputWidget({super.key, required this.items});

  @override
  State<InventoryItemInputWidget> createState() =>
      _InventoryItemInputWidgetState();
}

class _InventoryItemInputWidgetState extends State<InventoryItemInputWidget> {
  final Map<String, TextEditingController> _locationControllers = {};
  final Map<String, DateTime?> _expiryDates = {};
  final Set<String> _confirmedItems = {}; // Theo dõi các item đã xác nhận
  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    print(
        'Initializing controllers with items: ${widget.items.map((item) => "Name: ${item.name}, Quantity: ${item.quantity}, Location: ${item.location}, Expiry: ${item.expiry}").toList()}');
    // Xóa các controller cũ
    for (var controller in _quantityControllers.values) {
      controller.dispose();
    }
    for (var controller in _locationControllers.values) {
      controller.dispose();
    }
    _quantityControllers.clear();
    _locationControllers.clear();
    _expiryDates.clear();

    // Khởi tạo controller mới dựa trên widget.items
    for (var item in widget.items) {
<<<<<<< HEAD
      _locationControllers[item.name] = TextEditingController();
      _expiryDates[item.name] = null;
    }
  }

  void _submitData() {
    final inventoryProvider =
        Provider.of<FoodInventoryProvider>(context, listen: false);
    for (var item in widget.items) {
      final name = item.name;
      final location = _locationControllers[name]?.text;
      final expiry = _expiryDates[name];

      if (location == null || location.isEmpty || expiry == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Vui lòng điền đầy đủ thông tin')),
        );
        return;
      }

      item.location = location;
      item.expiry = expiry;
      inventoryProvider.updateItem(item);
=======
      if (item.name.isNotEmpty) {
        _quantityControllers[item.name] = TextEditingController(
          text: item.quantity > 0 ? item.quantity.toString() : '',
        );
        _locationControllers[item.name] = TextEditingController(
          text: item.location ?? '',
        );
        _expiryDates[item.name] = item.expiry;
      }
    }
  }

  @override
  void didUpdateWidget(InventoryItemInputWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.items != oldWidget.items) {
      _initializeControllers();
    }
  }

  void confirmItem(FoodItem item) {
    final inventoryProvider =
        Provider.of<FoodInventoryProvider>(context, listen: false);
    final updatedItems =
        Provider.of<UpdateItemProvider>(context, listen: false);

    final name = item.name;
    final quantity = int.tryParse(_quantityControllers[name]?.text ?? '');
    final location = _locationControllers[name]?.text;
    final expiry = _expiryDates[name];

    if (quantity == null || location == null || expiry == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Vui lòng điền đủ thông tin cho "$name"')),
      );
      return;
    }

    final existingItems =
        inventoryProvider.items.where((i) => i.name == name).toList();
    if (existingItems.isNotEmpty) {
      for (var existingItem in existingItems) {
        // Kiểm tra nếu đã từng update rồi thì hỏi lại
        if (existingItem.isUpdate == true) {
          final itemInupdateItem = updatedItems.findByName(name);
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Đã cập nhật trước đó'),
              content: Text(
                'Món "$name" đã được cập nhật trước đó. Bạn muốn ghi đè thông tin mới hay bỏ qua?',
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Bỏ qua, không làm gì
                  },
                  child: const Text('Bỏ qua'),
                ),
                TextButton(
                  onPressed: () {
                    final updatedItem = FoodItem(
                      name,
                      existingItem.icon,
                      existingItem.isSelected,
                      ((existingItem.quantity) -
                              itemInupdateItem.quantity +
                              quantity)
                          .toInt(),
                      location,
                      expiry,
                      false,
                      true, // isUpdate
                    );
                    final updatedItem1 = FoodItem(
                      name,
                      existingItem.icon,
                      existingItem.isSelected,
                      quantity,
                      location,
                      expiry,
                      false,
                      true, // isUpdate
                    );
                    inventoryProvider.updateItem(updatedItem);
                    updatedItems.update(updatedItem1);
                    _confirmedItems.add(name);
                    Navigator.pop(context);
                    setState(() {});
                  },
                  child: const Text('Ghi đè'),
                ),
              ],
            ),
          );
          return;
        }
        bool hasConflict = existingItem.location != location ||
            (existingItem.expiry != null && expiry != existingItem.expiry);

        if (hasConflict) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Xung đột thông tin'),
              content: Text(
                'Món "$name" đã tồn tại với thông tin khác:\n'
                'Vị trí: ${existingItem.location}\n'
                'HSD: ${existingItem.expiry != null ? "${existingItem.expiry!.day}/${existingItem.expiry!.month}/${existingItem.expiry!.year}" : "Chưa có"}\n'
                'Bạn muốn bỏ qua (thêm mới) hay cập nhật?',
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    final newItem = FoodItem(
                      name,
                      item.icon,
                      item.isSelected,
                      quantity,
                      location,
                      expiry,
                      false,
                      true,
                    );
                    inventoryProvider.addItem(newItem);
                    updatedItems.add(newItem);
                    _confirmedItems.add(name);
                    Navigator.pop(context);
                    setState(() {});
                  },
                  child: const Text('Bỏ qua (Thêm mới)'),
                ),
                TextButton(
                  onPressed: () {
                    final updatedItem = FoodItem(
                      name,
                      existingItem.icon,
                      existingItem.isSelected,
                      (existingItem.quantity) + quantity,
                      location,
                      expiry,
                      false,
                      true,
                    );
                    final updatedItem1 = FoodItem(
                      name,
                      existingItem.icon,
                      existingItem.isSelected,
                      quantity,
                      location,
                      expiry,
                      false,
                      true,
                    );
                    inventoryProvider.updateItem(updatedItem);
                    updatedItems.add(updatedItem1);
                    _confirmedItems.add(name);
                    Navigator.pop(context);
                    setState(() {});
                  },
                  child: const Text('Cập nhật'),
                ),
              ],
            ),
          );
          return;
        } else {
          final updatedItem = FoodItem(
            name,
            existingItem.icon,
            existingItem.isSelected,
            (existingItem.quantity) + quantity,
            location,
            expiry,
            false,
            true,
          );
          inventoryProvider.updateItem(updatedItem);
          updatedItems.add(updatedItem);
          _confirmedItems.add(name);
          setState(() {});
        }
      }
    } else {
      final newItem = FoodItem(
        name,
        item.icon,
        item.isSelected,
        quantity,
        location,
        expiry,
        false,
        true,
      );
      inventoryProvider.addItem(newItem);
      updatedItems.add(newItem);
      _confirmedItems.add(name);
      setState(() {});
>>>>>>> 898fbf3be0448210a6a988cf05ee58b1dd345f06
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Đã xác nhận "$name"')),
    );
  }

  @override
  void dispose() {
    for (var controller in _locationControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, String name) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _expiryDates[name] = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    return Scaffold(
      appBar: AppBar(),
      body: Column(children: [
        Expanded(
          child: ListView.builder(
            itemCount: widget.items.length,
            itemBuilder: (_, index) {
              final item = widget.items[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(item.icon, size: 30),
                          const SizedBox(width: 10),
                          Text(
                            '${item.name} (x${item.quantity})', // Hiển thị số lượng
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        value: _locationControllers[item.name]!.text.isNotEmpty
                            ? _locationControllers[item.name]!.text
                            : null,
                        items: ['Ngăn mát', 'Ngăn đá']
                            .map((location) => DropdownMenuItem(
                                  value: location,
                                  child: Text(location),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _locationControllers[item.name]!.text = value!;
                          });
                        },
                        decoration: const InputDecoration(
                          labelText: 'Vị trí lưu trữ',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Text('Ngày hết hạn: '),
                          Text(
                            _expiryDates[item.name] != null
                                ? '${_expiryDates[item.name]!.day}/${_expiryDates[item.name]!.month}/${_expiryDates[item.name]!.year}'
                                : 'Chưa chọn',
=======
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return false; // Ngăn pop mặc định, xử lý trong _submitData
      },
      child: Scaffold(
        appBar: AppBar(),
        body: Column(children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.items.length,
              itemBuilder: (_, index) {
                final item = widget.items[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(item.icon, size: 30),
                            const SizedBox(width: 10),
                            Text(item.name,
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _quantityControllers[item.name],
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Số lượng',
                            border: OutlineInputBorder(),
>>>>>>> 898fbf3be0448210a6a988cf05ee58b1dd345f06
                          ),
                        ),
                        const SizedBox(height: 12),
                        DropdownButtonFormField<String>(
                          value:
                              _locationControllers[item.name]!.text.isNotEmpty
                                  ? _locationControllers[item.name]!.text
                                  : null,
                          items: ['Ngăn mát', 'Ngăn đá']
                              .map((location) => DropdownMenuItem(
                                    value: location,
                                    child: Text(location),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              _locationControllers[item.name]!.text = value!;
                            });
                          },
                          decoration: const InputDecoration(
                            labelText: 'Vị trí lưu trữ',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const Text('Ngày hết hạn: '),
                            Text(
                              _expiryDates[item.name] != null
                                  ? '${_expiryDates[item.name]!.day}/${_expiryDates[item.name]!.month}/${_expiryDates[item.name]!.year}'
                                  : 'Chưa chọn',
                            ),
                            const SizedBox(width: 12),
                            ElevatedButton(
                              onPressed: () => _selectDate(context, item.name),
                              child: const Text('Chọn ngày'),
                            ),
                            const Spacer(),
                            ElevatedButton(
                              onPressed: () => confirmItem(item),
                              child: const Text('Xác nhận'),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.check),
              label: const Text('Quay lại'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () {
                Navigator.pop(context); // Trả về danh sách đã xác nhận nếu cần
              },
            ),
          )
        ]),
      ),
    );
  }
}
