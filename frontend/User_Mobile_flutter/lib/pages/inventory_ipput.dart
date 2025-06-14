import 'package:flutter/material.dart';
import 'package:login_menu/models/foodItemsResponse.dart';
import 'package:intl/intl.dart';
import 'package:login_menu/service/auth_service.dart';

class InventoryItemInputWidget extends StatefulWidget {
  final List<FoodItemResponse> items;
  final int listId;

  const InventoryItemInputWidget(
      {super.key, required this.items, required this.listId});

  @override
  State<InventoryItemInputWidget> createState() =>
      _InventoryItemInputWidgetState();
}

class _InventoryItemInputWidgetState extends State<InventoryItemInputWidget> {
  final Map<String, TextEditingController> _locationControllers = {};
  final Map<String, DateTime?> _expiryDates = {};
  List<String> _storageLocations = [];
  bool _loadingLocations = true;

  @override
  void initState() {
    super.initState();
    _fetchStorageLocations();
  }

  void _initializeControllers() {
    _locationControllers.clear();
    _expiryDates.clear();
    for (var item in widget.items) {
      final loc = item.storageLocation;
      _locationControllers[item.foodname] = TextEditingController(
        text: (loc.isEmpty || !_storageLocations.contains(loc))
            ? (_storageLocations.isNotEmpty ? _storageLocations.first : '')
            : loc,
      );
      _expiryDates[item.foodname] = item.expiryDate;
    }
  }

  Future<void> _fetchStorageLocations() async {
    try {
      final locations = await AuthService().getStorageLocations();
      final filtered =
          locations.where((location) => location.isNotEmpty).toList();
      setState(() {
        _storageLocations = filtered;
        _loadingLocations = false;
      });
      _initializeControllers();
    } catch (e) {
      print('[DEBUG] Lỗi lấy storage location: $e');
      setState(() {
        _storageLocations = [];
        _loadingLocations = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi tải vị trí lưu trữ')),
      );
    }
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
  void dispose() {
    for (var controller in _locationControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: _loadingLocations
          ? const Center(child: CircularProgressIndicator())
          : Column(children: [
              Expanded(
                child: ListView.builder(
                  itemCount: widget.items.length,
                  itemBuilder: (_, index) {
                    final item = widget.items[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const SizedBox(width: 10),
                                Text(item.foodname,
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                            const SizedBox(height: 12),
                            DropdownButtonFormField<String>(
                              value: () {
                                final text =
                                    _locationControllers[item.foodname]?.text;
                                if (text == null ||
                                    text.isEmpty ||
                                    text == 'null') return null;
                                if (_storageLocations.contains(text))
                                  return text;
                                return null;
                              }(),
                              items: _storageLocations
                                  .map((location) => DropdownMenuItem<String>(
                                        value: location,
                                        child: Text(location),
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  _locationControllers[item.foodname]?.text =
                                      value ?? '';
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
                                  _expiryDates[item.foodname] != null
                                      ? '${_expiryDates[item.foodname]!.day}/${_expiryDates[item.foodname]!.month}/${_expiryDates[item.foodname]!.year}'
                                      : 'Chưa chọn',
                                ),
                                const SizedBox(width: 12),
                                ElevatedButton(
                                  onPressed: () =>
                                      _selectDate(context, item.foodname),
                                  child: const Text('Chọn ngày'),
                                ),
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
                  onPressed: () async {
                    // Validate dữ liệu inventory
                    bool ok = true;
                    for (var item in widget.items) {
                      final location =
                          _locationControllers[item.foodname]?.text ?? '';
                      final expiry = _expiryDates[item.foodname];
                      if (location.isEmpty || expiry == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(
                                  'Vui lòng nhập đầy đủ vị trí và ngày hết hạn cho ${item.foodname}')),
                        );
                        ok = false;
                        break;
                      }
                      item.storageLocation = location;
                      item.expiryDate = expiry; // cập nhật lại object
                      print(
                          '${item.foodname} - Vị trí: $location, Ngày hết hạn: ${expiry.day}/${expiry.month}/${expiry.year}');
                      print('${item.expiryDate}-dit me thang h'); // Debug log
                    }
                    if (ok) {
                      Navigator.pop(context,
                          widget.items); // Trả về danh sách đã nhập inventory
                    }
                  },
                ),
              )
            ]),
    );
  }
}
