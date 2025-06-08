import 'package:flutter/material.dart';
import 'package:login_menu/data/data_store.dart';
import 'package:login_menu/models/foodItemsResponse.dart';
import 'package:login_menu/models/shopping_list_model.dart.dart';
import 'package:login_menu/models/ShoppingListModelShare.dart';
import 'package:login_menu/models/updateItemRequest.dart';

import 'package:login_menu/pages/editShoppingItem.dart';
import 'package:login_menu/pages/inventory_ipput.dart';

import 'package:login_menu/pages/new_list_info_page.dart';
import 'package:login_menu/pages/share_member_page.dart';
import 'package:login_menu/service/auth_service.dart';

class ShoppingListTab extends StatefulWidget {
  const ShoppingListTab({super.key, required this.authService});
  final AuthService authService;

  @override
  State<ShoppingListTab> createState() => _ShoppingListTabState();
}

class _ShoppingListTabState extends State<ShoppingListTab> {
  List<ShoppingListModel> _lists = [];
  List<Map<String, dynamic>> _shareInvitations = [];
  List<ShoppingListModelShare> _sharedLists = [];
  bool _hasUnreadInvites = false;
  List<FoodItemResponse> foodInventory = [];
  List<FoodItemResponse> deletedInventory = [];
  bool _isLoading = true;
  final List<String> _weekdayNames = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  @override
  void initState() {
    super.initState();
    _checkForInvitations();
    fetchShoppingList();
  }

  DateTime _parseDate(dynamic rawDate) {
    if (rawDate == null) return DateTime.now();
    if (rawDate is int) {
      return DateTime.fromMillisecondsSinceEpoch(rawDate).toLocal();
    } else if (rawDate is String) {
      try {
        // Lấy đúng phần yyyy-MM-dd, bỏ giờ phút giây và timezone để tránh lệch ngày
        String dateOnly =
            rawDate.length >= 10 ? rawDate.substring(0, 10) : rawDate;
        final parts = dateOnly.split('-');
        if (parts.length == 3) {
          return DateTime(
            int.parse(parts[0]),
            int.parse(parts[1]),
            int.parse(parts[2]),
          );
        }
        // Nếu không thể tách, fallback parse bình thường rồi convert về local
        return DateTime.parse(rawDate).toLocal();
      } catch (_) {
        return DateTime.now();
      }
    }
    return DateTime.now();
  }

  Future<void> fetchShoppingList() async {
    setState(() {
      _isLoading = true;
    });

    try {
       final userId = await widget.authService.getUserId();
       DataStore().UserID = userId;
      final groupId = await widget.authService.getGroupIdByUserId(DataStore().UserID);
      DataStore().GroupID = groupId;
      final userLists =
          await widget.authService.fetchShoppingListsByUserId(DataStore().UserID);
      final sharedLists =
          await widget.authService.fetchShoppingListsByGroupId(groupId);
      print('Fetched User Lists: $userLists');
      // Danh sách cá nhân
      final fetchedPersonalLists = userLists.map((item) {
        final items = (item['items'] as List? ?? []).map((i) {
          return ShoppingItem(
            i['id'] as int? ?? 0,
            i['name']?.toString() ?? 'Unknown',
            getIconDataFromString(i['icon']?.toString() ?? 'help_outline'),
            i['status'] == 'PURCHASED',
            (i['quantity'] as num?)?.toDouble() ?? 1.0,
            i['unitName']?.toString() ?? '',
            category: null,
          );
        }).toList();

        return ShoppingListModel(
          listName: item['listName']?.toString() ?? 'Untitled',
          date: _parseDate(item['startDate']),
          items: items,
          listId: item['id'] as int?,
          purchasedBy: DataStore().userId,
        );
      }).toList();

      // Danh sách chia sẻ theo group
      final fetchedSharedLists = sharedLists.map((item) {
        final items = (item['items'] as List? ?? []).map((i) {
          return ShoppingItem(
            i['id'] as int? ?? 0,
            i['name']?.toString() ?? 'Unknown',
            getIconDataFromString(i['icon']?.toString() ?? 'help_outline'),
            i['status'] == 'PURCHASED',
            (i['quantity'] as num?)?.toDouble() ?? 1.0,
            i['unit']?.toString() ?? '',
            category: i['category']?.toString(),
          );
        }).toList();

        return ShoppingListModelShare(
          date: _parseDate(item['startDate']),
          title: item['listName'] ?? 'Untitled',
          sharedBy: item['sharedBy'] ?? 'Unknown',
          items: items,
        );
      }).toList();

      setState(() {
        _lists = List<ShoppingListModel>.from(fetchedPersonalLists);
        _sharedLists = List<ShoppingListModelShare>.from(fetchedSharedLists);
        _isLoading = false;
      });
    } catch (e) {
      print('Lỗi khi lấy danh sách: $e');
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi lấy danh sách: $e')),
      );
    }
  }

  IconData getIconDataFromString(String iconName) {
    switch (iconName) {
      case 'local_drink':
        return Icons.local_drink;
      case 'egg':
        return Icons.egg;
      case 'shopping_cart':
        return Icons.shopping_cart;
      case 'restaurant':
        return Icons.restaurant;
      default:
        return Icons.shopping_cart_outlined; // Mặc định nếu không tìm thấy
    }
  }

  void _removeList(int index) async {
    final list = _lists[index];

    try {
      // Gọi phương thức deleteShoppingList để xóa danh sách khỏi MySQL qua API
      await widget.authService.deleteShoppingList(list.listId!);

      // Sau khi xóa thành công, cập nhật lại giao diện người dùng
      setState(() {
        _lists.removeAt(index);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('Danh sách "${list.listName}" đã được xóa thành công')),
      );
    } catch (e) {
      print('Lỗi khi xóa danh sách: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi xóa danh sách: $e')),
      );
    }
  }

  Widget _buildListCard(ShoppingListModel list, int index) {
    // Kiểm tra xem tất cả items trong list đã được tick chưa
    bool allItemsChecked = list.items.every((item) => item.checked);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black54),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  list.listName,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () async {
                      final list = _lists[index];
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => Editshoppingitem(
                              list: list, authService: widget.authService),
                        ),
                      );
                      if (result == true) {
                        fetchShoppingList();
                      }
                    },
                    icon: const Icon(Icons.edit, color: Colors.blue),
                  ),
                  IconButton(
                    onPressed: () => _removeList(index),
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                  ),
                ],
              ),
            ],
          ),
          Text('${list.completedCount} of ${list.items.length} items'),
          const SizedBox(height: 12),
          ...list.items.map((item) => buildItem(item, list.date)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: () async {
                  // Xử lý khi người dùng nhấn nút "Done"
                  if (allItemsChecked) {
                    final response = await widget.authService
                        .markShoppingListAsPurchased(list.listId!);

                    //Parse ra danh sách foodItemResponses
                    final List<FoodItemResponse> inventoryItems =
                        (response?['result']['foodItemResponses'] as List)
                            .map((item) => FoodItemResponse.fromJson(item))
                            .toList();

                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => InventoryItemInputWidget(
                          items: inventoryItems,
                          listId: list.listId!,
                        ),
                      ),
                    );
                    if (result is List<FoodItemResponse>) {
                      // Update từng item
                      for (final food in result) {
                        print('hehehe: ${food.expiryDate}');
                        print('hehehe: ${food.storageLocation}');
                        await widget.authService
                            .updateFoodItem(UpdateItemRequest(
                          id: food.id,
                          storageLocation: food.storageLocation,
                          expireDate: food.expiryDate,
                        ));
                      }

                      fetchShoppingList();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Đã mua hết sản phẩm!')),
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Chưa mua hết sản phẩm!')),
                    );
                  }
                },
                child: const Text("Done"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildSharedListCard(ShoppingListModelShare list) {
    final dateOnly = DateTime(list.date.year, list.date.month, list.date.day);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.green),
        borderRadius: BorderRadius.circular(12),
        color: Colors.green.shade50,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${_weekdayNames[dateOnly.weekday - 1]}, '
                '${dateOnly.day.toString().padLeft(2, '0')}/${dateOnly.month.toString().padLeft(2, '0')}',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                'Shared by: ${list.sharedBy}',
                style:
                    const TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            list.title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
          Text('${list.completedCount} of ${list.items.length} items'),
          const SizedBox(height: 12),
          ...list.items.map((item) {
            return Row(
              children: [
                Checkbox(
                  value: item.checked,
                  onChanged: null,
                ),
                Icon(item.icon),
                const SizedBox(width: 8),
                Text('${item.name} (x${item.quantity})'),
              ],
            );
          }),
        ],
      ),
    );
  }

  void _checkForInvitations() {
    setState(() {
      _shareInvitations = [
        {
          'from': 'Alice',
          'listName': 'Weekend Grocery',
          'listId': 'abc123',
        },
      ];
      _hasUnreadInvites = true;
    });
  }

  void _showInvitationDialog(Map<String, dynamic> invite) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Lời mời chia sẻ'),
        content: Text(
          '${invite['from']} đã chia sẻ danh sách "${invite['listName']}" với bạn. Bạn có muốn chấp nhận không?',
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _shareInvitations.remove(invite);
                _hasUnreadInvites = _shareInvitations.isNotEmpty;
              });
              Navigator.pop(context);
            },
            child: const Text('Từ chối'),
          ),
          // TextButton(
          //   onPressed: () {
          //     setState(() {
          //       _sharedLists.add(
          //         ShoppingListModelShare(
          //           date: DateTime.now(),
          //           title: 'Weekend Grocery',
          //           sharedBy: invite['from'],
          //           items: [
          //             ShoppingItem(0, "Milk", Icons.local_drink, false, 1, ''),
          //             ShoppingItem(1, "Eggs", Icons.egg, false, 1, ''),
          //           ],
          //         ),
          //       );
          //       _shareInvitations.remove(invite);
          //       _hasUnreadInvites = _shareInvitations.isNotEmpty;
          //     });
          //     Navigator.pop(context);
          //   },
          //   child: const Text('Đồng ý'),
          // ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(Icons.shopping_cart_outlined, size: 30),
                  const Text(
                    'Shopping Lists',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.share,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  const SharingMembersPage(), // Navigate to the SharingMembersPage
                            ),
                          );
                        },
                      ),
                      Stack(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.mail_outline, size: 28),
                            onPressed: () {
                              if (_shareInvitations.isNotEmpty) {
                                _showInvitationDialog(_shareInvitations[0]);
                              }
                            },
                          ),
                          if (_hasUnreadInvites)
                            Positioned(
                              right: 6,
                              top: 6,
                              child: Container(
                                width: 10,
                                height: 10,
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline, size: 30),
                        onPressed: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => NewListInfoPage(
                                authService: widget.authService,
                              ),
                            ),
                          );

                          if (result == true) {
                            fetchShoppingList();
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : (_lists.isEmpty && _sharedLists.isEmpty)
                        ? const Center(
                            child: Text('No shopping lists available'))
                        : ListView(
                            children: [
                              ..._sharedLists
                                  .map((shared) => buildSharedListCard(shared)),
                              const SizedBox(height: 24),
                              ..._lists.asMap().entries.map(
                                    (entry) =>
                                        _buildListCard(entry.value, entry.key),
                                  ),
                            ],
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildItem(ShoppingItem item, DateTime selectedDate) {
    final bool isDisable = selectedDate.isAfter(DateTime.now());
    return Row(
      children: [
        Checkbox(
          value: item.checked,
          onChanged: isDisable
              ? null
              : (val) {
                  setState(() {
                    item.checked = val ?? false;

                    try {
                      widget.authService.markItemAsPurchased(item.id);
                    } catch (e) {
                      setState(() {
                        item.checked = !item.checked; // Rollback lại UI
                      });
                    }
                  });
                },
        ),
        Icon(item.icon),
        const SizedBox(width: 8),
        Text(
          '${item.name} - ${item.quantity} - ${item.unit}',
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}

class ShoppingItem {
  final int id;
  String name;
  IconData icon;
  bool checked;
  double quantity;
  String unit;
  String? category;
  int? unitId; // Thêm trường unitId
  int? foodCatalogId; // Thêm trường foodCatalogId
  ShoppingItem(this.id,this.name, this.icon, this.checked, this.quantity, this.unit,
      {this.unitId, this.foodCatalogId, this.category});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity.toInt(),
      'unitId': unitId ?? 1,
      'foodCatalogId': foodCatalogId ?? 1
    };
  }
}
