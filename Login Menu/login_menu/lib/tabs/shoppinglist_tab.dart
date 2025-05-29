import 'package:flutter/material.dart';
import 'package:login_menu/models/fooditem.dart';
import 'package:login_menu/models/shoppinglist_request.dart';
import 'package:login_menu/models/shopping_list_model.dart.dart';
import 'package:login_menu/models/ShoppingListModelShare.dart';
import 'package:login_menu/models/update_item.dart';
import 'package:login_menu/pages/inventory_ipput.dart';
import 'package:login_menu/pages/new_list_info_page.dart';
import 'package:login_menu/pages/share_member_page.dart';
import 'package:login_menu/service/auth_service.dart';
import 'package:provider/provider.dart';

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
  List<FoodItem> foodInventory = [];
  List<FoodItem> deletedInventory = [];
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

  Future<void> fetchShoppingList() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final listData = await widget.authService.fetchShoppingLists();
      print('API Response: $listData');

      final fetchedSharedLists =
          (listData['shared'] as List? ?? []).map((item) {
        return ShoppingListModelShare(
          date: DateTime.parse(item['date'] ?? DateTime.now().toString()),
          title: item['title']?.toString() ?? 'Untitled',
          sharedBy: item['sharedBy']?.toString() ?? 'Unknown',
          items: (item['items'] as List? ?? []).map((i) {
            return ShoppingItem(
              i['name']?.toString() ?? 'Unknown',
              getIconDataFromString(i['icon']?.toString() ?? 'help_outline'),
              i['isDone'] ?? false,
              (i['quantity'] as num?)?.toDouble() ?? 1.0,
              i['unit']?.toString() ?? '',
              category: i['category']?.toString(),
            );
          }).toList(),
        );
      }).toList();

      final fetchedPersonalLists =
          (listData['personal'] as List? ?? []).map((item) {
        return ShoppingListModel(
          date: DateTime.parse(item['date'] ?? DateTime.now().toString()),
          items: (item['items'] as List? ?? []).map((i) {
            return ShoppingItem(
              i['name']?.toString() ?? 'Unknown',
              getIconDataFromString(i['icon']?.toString() ?? 'help_outline'),
              i['isDone'] ?? false,
              (i['quantity'] as num?)?.toDouble() ?? 1.0,
              i['unit']?.toString() ?? '',
              category: i['category']?.toString(),
            );
          }).toList(),
        );
      }).toList();

      setState(() {
        _sharedLists = List<ShoppingListModelShare>.from(fetchedSharedLists);
        _lists = List<ShoppingListModel>.from(fetchedPersonalLists);
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
        return Icons.help_outline;
    }
  }

  void _removeList(int index) {
    final list = _lists[index];
    setState(() {
      _lists.removeAt(index);
    });

    // Cập nhật inventory khi xóa danh sách
    for (var item in list.items) {
      _updateInventoryOnRemove(item);
    }
  }

  void _updateInventoryOnRemove(ShoppingItem item) {
    final inventoryProvider =
        Provider.of<FoodInventoryProvider>(context, listen: false);
    final matchingItems =
        foodInventory.where((food) => food.name == item.name).toList();

    if (matchingItems.isEmpty) return;

    for (var inventoryItem in matchingItems) {
      final providerItems = inventoryProvider.items
          .where((food) => food.name == item.name)
          .toList();
      for (var providerItem in providerItems) {
        if (providerItem.quantity <= 0 || providerItem.location == '') {
          inventoryProvider.removeItem(providerItem);
        } else if (providerItem.location == inventoryItem.location &&
            providerItem.expiry == inventoryItem.expiry) {
          if (providerItem.quantity > inventoryItem.quantity) {
            providerItem.quantity -= inventoryItem.quantity;
            inventoryProvider.updateItem(providerItem);
            print(
                'Đã cập nhật số lượng: ${providerItem.name} - ${providerItem.quantity}');
          } else if (providerItem.quantity == inventoryItem.quantity) {
            inventoryProvider.removeItem(providerItem);
            print('Đã xóa: ${providerItem.name}');
          }
        }
      }

      final foodItem = getFoodItemByName(item.name);
      if (foodItem != null) {
        ItemisDeleted(foodItem);
        foodInventory.removeWhere((food) => food.name == item.name);
      }
    }
  }

  Widget _buildListCard(ShoppingListModel list, int index) {
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
              Text(
                '${_weekdayNames[list.date.weekday - 1]}, ${list.date.day.toString().padLeft(2, '0')}/${list.date.month.toString().padLeft(2, '0')}',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SharingMembersPage(),
                        ),
                      );
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
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => InventoryItemInputWidget(
                      items: foodInventory,
                    ),
                  ),
                ).then((result) {
                  if (result == null) {
                    final updateItemProvider =
                        Provider.of<UpdateItemProvider>(context, listen: false);
                    for (var updateItem in updateItemProvider.updateItems) {
                      final index = foodInventory
                          .indexWhere((item) => item.name == updateItem.name);
                      if (index != -1) {
                        foodInventory[index] = updateItem;
                      }
                    }
                  }
                });
              },
              label: const Text('Add Inventory'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              icon: const Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSharedListCard(ShoppingListModelShare list) {
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
                '${_weekdayNames[list.date.weekday - 1]}, '
                '${list.date.day.toString().padLeft(2, '0')}/${list.date.month.toString().padLeft(2, '0')}',
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
          Text(
              '${list.completedCount} of ${list.items.length} items completed'),
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
          TextButton(
            onPressed: () {
              setState(() {
                _sharedLists.add(
                  ShoppingListModelShare(
                    date: DateTime.now(),
                    title: 'Weekend Grocery',
                    sharedBy: invite['from'],
                    items: [
                      ShoppingItem("Milk", Icons.local_drink, false, 1, ''),
                      ShoppingItem("Eggs", Icons.egg, false, 1, ''),
                    ],
                  ),
                );
                _shareInvitations.remove(invite);
                _hasUnreadInvites = _shareInvitations.isNotEmpty;
              });
              Navigator.pop(context);
            },
            child: const Text('Đồng ý'),
          ),
        ],
      ),
    );
  }

  void ItemisDeleted(FoodItem item) {
    item.isDeleted = true;
    item.isUpdate = false;
    deletedInventory.add(item);
  }

  void ItemnotDeleted(FoodItem item) {
    item.isDeleted = false;
    deletedInventory.removeWhere((food) => food.name == item.name);
    foodInventory.add(item);
  }

  FoodItem? getFoodItemByName(String name) {
    if (name.isEmpty) {
      return null;
    }
    try {
      return foodInventory.firstWhere((food) => food.name == name);
    } catch (e) {
      print('Lỗi khi tìm FoodItem với name "$name": $e');
      return null;
    }
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

                          if (result is ShoppingListModel) {
                            final index = _lists.indexWhere((list) =>
                                list.date.year == result.date.year &&
                                list.date.month == result.date.month &&
                                list.date.day == result.date.day);

                            if (index != -1) {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Trùng ngày'),
                                  content: const Text(
                                      'Ngày này đã có danh sách rồi. Bạn có muốn thay thế không?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Không'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        final oldList = _lists[index];
                                        for (var oldItem in oldList.items) {
                                          _updateInventoryOnRemove(oldItem);
                                        }
                                        setState(() {
                                          _lists[index] = result;
                                        });
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Có'),
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              setState(() {
                                _lists.add(result);
                              });
                            }
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
                    final alreadyExists =
                        foodInventory.any((food) => food.name == item.name);
                    final alreadyExistsInDeleted =
                        deletedInventory.any((food) => food.name == item.name);

                    if (item.checked) {
                      if (!alreadyExists && !alreadyExistsInDeleted) {
                        final newItem = FoodItem(
                          item.name,
                          item.icon,
                          item.checked,
                          0,
                          '',
                          DateTime.now(),
                          false,
                          false,
                        );
                        foodInventory.add(newItem);
                      } else if (!alreadyExists && alreadyExistsInDeleted) {
                        final newItem = deletedInventory
                            .firstWhere((food) => food.name == item.name);
                        ItemnotDeleted(newItem);
                      }
                    } else {
                      if (alreadyExists) {
                        _updateInventoryOnRemove(item);
                      }
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
  String name;
  IconData icon;
  bool checked;
  double quantity;
  String unit;
  String? category;

  ShoppingItem(this.name, this.icon, this.checked, this.quantity, this.unit,
      {this.category});
}
