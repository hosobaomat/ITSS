import 'package:flutter/material.dart';
import 'package:login_menu/models/fooditem.dart';
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

  @override
  void initState() {
    super.initState();
    for (var item in widget.items) {
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
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Lưu thông tin thành công!')),
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
