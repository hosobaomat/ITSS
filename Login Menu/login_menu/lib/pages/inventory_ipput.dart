import 'package:flutter/material.dart';
import 'package:login_menu/models/fooditem.dart';
import 'package:provider/provider.dart';

class InventoryItemInputWidget extends StatefulWidget {
  final List<FoodItem> items; // Các item đã chọn từ giỏ hàng

  const InventoryItemInputWidget({super.key, required this.items});

  @override
  State<InventoryItemInputWidget> createState() =>
      _InventoryItemInputWidgetState();
}

class _InventoryItemInputWidgetState extends State<InventoryItemInputWidget> {
  final Map<String, TextEditingController> _quantityControllers = {};
  final Map<String, TextEditingController> _locationControllers = {};
  final Map<String, DateTime?> _expiryDates = {};

  @override
  void initState() {
    super.initState();
    for (var item in widget.items) {
      _quantityControllers[item.name] = TextEditingController();
      _locationControllers[item.name] = TextEditingController();
      _expiryDates[item.name] = null;
    }
  }

  void _submitData() {
    final inventoryProvider = Provider.of<FoodInventoryProvider>(context, listen: false);
    for (var item in widget.items) {
      final name = item.name;
      final quantity = int.tryParse(_quantityControllers[name]?.text ?? '');
      final location = _locationControllers[name]?.text;
      final expiry = _expiryDates[name];

      if (quantity == null || location == null || expiry == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Vui lòng điền đầy đủ thông tin')),
        );
        return;
      }
      item.quantity = quantity;
      item.location = location;
      item.expiry = expiry;
      inventoryProvider.updateItem(item);
      // Ví dụ: In ra console - bạn có thể thay bằng thêm vào provider hoặc database
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Lưu thông tin thành công!')),
    );
  }

  @override
  void dispose() {
    for (var controller in _quantityControllers.values) {
      controller.dispose();
    }
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
                        ),
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
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton(
                            onPressed: () => _selectDate(context, item.name),
                            child: const Text('Chọn ngày'),
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
            label: const Text('Xác nhận'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 50),
            ),
            onPressed: _submitData,
          ),
        )
      ]),
    );
  }
}
