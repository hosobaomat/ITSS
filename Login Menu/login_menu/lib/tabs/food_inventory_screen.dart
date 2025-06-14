import 'package:flutter/material.dart';
import 'package:login_menu/models/fooditem.dart';
import 'package:provider/provider.dart';

class FoodInventoryScreen extends StatefulWidget {
  const FoodInventoryScreen({super.key, required this.inventoryItems});
  final List<FoodItem> inventoryItems;

  @override
  _FoodInventoryScreenState createState() => _FoodInventoryScreenState();
}

class _FoodInventoryScreenState extends State<FoodInventoryScreen> {
  List<FoodItem> filteredItems = [];
  List<FoodItem> expiringItems = []; // Lưu trữ món sắp hết hạn
  bool _isDialogShowing = false;
  FoodInventoryProvider? _provider; // Lưu trữ tham chiếu đến provider

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Lưu tham chiếu đến FoodInventoryProvider
    _provider = Provider.of<FoodInventoryProvider>(context, listen: false);
  }

  void _showExpiringItemsDialogIfNeeded() {
    if (!mounted) return;
    if (expiringItems.isNotEmpty && !_isDialogShowing) {
      _isDialogShowing = true;
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('⚠️ Cảnh báo thực phẩm sắp hết hạn'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: expiringItems.length,
              itemBuilder: (context, index) {
                final item = expiringItems[index];
                return ListTile(
                  leading: Icon(item.icon),
                  title: Text(item.name),
                  subtitle: Text(
                      'HSD: ${item.expiry!.day}/${item.expiry!.month}/${item.expiry!.year}'),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                _isDialogShowing = false;
                print('[ShowExpiringItemsDialogIfNeeded] Người dùng đóng dialog');
                Navigator.pop(context);
              },
              child: const Text('Đóng'),
            ),
          ],
        ),
      );
    } else {
      print('[ShowExpiringItemsDialogIfNeeded] Không có món hết hạn hoặc dialog đang hiển thị');
    }
  }

  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final merged = mergeItems(widget.inventoryItems,
        Provider.of<FoodInventoryProvider>(context, listen: false).items);
    final provider = Provider.of<FoodInventoryProvider>(context, listen: false);
    for (var item in merged) {
      if (!provider.items.any((e) => e.name == item.name)) {
        provider.addItem(item);
      }
    }
    filteredItems = List.from(provider.items);
    provider.addListener(_onProviderChanged);
    // Lần đầu cập nhật expiringItems và hiện dialog sau khi frame build xong
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _updateExpiringItems();
      _showExpiringItemsDialogIfNeeded();
    });
  }

  @override
  void dispose() {
    // Sử dụng _provider thay vì Provider.of(context)
    _provider?.removeListener(_onProviderChanged);
    searchController.dispose();
    super.dispose();
  }

  void _onProviderChanged() {
    // Khi provider thay đổi, chỉ update expiringItems, không hiện dialog
    _updateExpiringItems();
  }

  Future<void> _updateExpiringItems() async {
    final now = DateTime.now();
    final threeDaysLater = now.add(const Duration(days: 3));

    final provider = Provider.of<FoodInventoryProvider>(context, listen: false);
    final newExpiring = provider.items.where((item) {
      final expiry = item.expiry;
      return expiry != null &&
          expiry.isAfter(now) &&
          expiry.isBefore(threeDaysLater);
    }).toList();

    setState(() {
      expiringItems = newExpiring;
    });
    print('[UpdateExpiringItems] Có ${expiringItems.length} món sắp hết hạn:');
  }

  void updateSearch(String query) {
    final inventory =
        Provider.of<FoodInventoryProvider>(context, listen: false).items;
    setState(() {
      filteredItems = inventory.where((item) {
        return item.name.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  List<FoodItem> mergeItems(List<FoodItem> base, List<FoodItem> updated) {
    final Map<String, FoodItem> itemMap = {
      for (var item in base) item.name: item,
    };

    for (var item in updated) {
      itemMap[item.name] = item; // Ghi đè nếu đã có
    }

    return itemMap.values.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12.0),
            child: Text(
              'Food Inventory',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: TextField(
              controller: searchController,
              onChanged: updateSearch,
              decoration: InputDecoration(
                hintText: 'Search items',
                prefixIcon: const Icon(Icons.search),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Selector<FoodInventoryProvider, List<FoodItem>>(
              selector: (_, provider) => provider.items,
              builder: (context, inventory, _) {
                final query = searchController.text.trim().toLowerCase();
                final results = query.isEmpty
                    ? inventory
                    : inventory
                        .where(
                            (item) => item.name.toLowerCase().contains(query))
                        .toList();

                return results.isEmpty
                    ? const Center(child: Text('No items found.'))
                    : ListView.builder(
                        itemCount: results.length,
                        itemBuilder: (context, index) {
                          final item = results[index];
                          return ListTile(
                            title: Text(item.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            trailing: Text('${item.quantity}/${item.location}'),
                            subtitle: Text(
                                '${item.expiry!.day}/${item.expiry!.month}/${item.expiry!.year}'),
                          );
                        },
                      );
              },
            ),
          )
        ],
      ),
    );
  }
}