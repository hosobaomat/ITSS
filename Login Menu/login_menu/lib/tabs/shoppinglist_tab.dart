import 'package:flutter/material.dart';
import 'package:login_menu/data/data_store.dart';
import 'package:login_menu/models/fooditem.dart';
import 'package:login_menu/models/shopping_list_model.dart.dart';
import 'package:login_menu/models/ShoppingListModelShare.dart';
import 'package:login_menu/pages/inventory_ipput.dart';
import 'package:login_menu/pages/new_list_page.dart';
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
    fetchShoppingList(); // Gọi khi mở app
  }

  Future<void> fetchShoppingList() async {
    try {
      final listData = await widget.authService.fetchShoppingLists();
      print('API Response: $listData'); // Debug

      // Xử lý danh sách shared
      final fetchedSharedLists = (listData['shared'] as List).map((item) {
        return ShoppingListModelShare(
          date: DateTime.parse(item['date']),
          title: item['title'],
          sharedBy: item['sharedBy'],
          items: (item['items'] as List).map((i) {
            print('Icon name: ${i['icon']}'); // Debug
            return ShoppingItem(
              i['name'],
              getIconDataFromString(i['icon'] ?? 'help_outline'),
              i['isDone'],
            );
          }).toList(),
        );
      }).toList();

      // Xử lý danh sách personal
      final fetchedPersonalLists = (listData['personal'] as List).map((item) {
        return ShoppingListModel(
          date: DateTime.parse(item['date']),
          items: (item['items'] as List).map((i) {
            print('Icon name: ${i['icon']}'); // Debug
            return ShoppingItem(
              i['name'],
              getIconDataFromString(i['icon'] ?? 'help_outline'),
              i['isDone'],
            );
          }).toList(),
        );
      }).toList();

      setState(() {
        _sharedLists = List<ShoppingListModelShare>.from(fetchedSharedLists);
        _lists = List<ShoppingListModel>.from(fetchedPersonalLists);
      });
    } catch (e) {
      print('Lỗi khi lấy danh sách: $e');
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
      // Thêm các icon khác nếu cần
      default:
        return Icons.help_outline; // Icon mặc định nếu không tìm thấy
    }
  }

  void _removeList(int index) {
    setState(() {
      _lists.removeAt(index);
    });
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
                              builder: (_) => SharingMembersPage()));
                    },
                    icon: const Icon(Icons.share, color: Colors.blue),
                  ),
                  IconButton(
                    onPressed: () {
                      _removeList(index);
                      for (var item in list.items) {
                        bool alreadyExists =
                            foodInventory.any((food) => food.name == item.name);
                        if (alreadyExists) {
                          Provider.of<FoodInventoryProvider>(context,
                                  listen: false)
                              .removeItem(foodInventory.firstWhere(
                                  (food) => food.name == item.name));
                          foodInventory
                              .removeWhere((food) => food.name == item.name);
                        }
                      }
                    },
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                  ),
                ],
              )
            ],
          ),
          Text('${list.completedCount} of ${list.items.length} items'),
          const SizedBox(height: 12),
          ...list.items.map((item) => buildItem(item, list.date)),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
                onPressed: () {},
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => InventoryItemInputWidget(
                                  items: foodInventory,
                                )));
                  },
                  label: const Text('Add Inventory'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                )),
          ),
        ],
      ),
    );
  }

  Widget buildSharedListCard(ShoppingListModelShare list) {
    final weekdayNames = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];

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
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${weekdayNames[list.date.weekday - 1]}, '
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

          // Title
          Text(
            list.title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),

          // Progress info
          const SizedBox(height: 6),
          Text(
              '${list.completedCount} of ${list.items.length} items completed'),

          const SizedBox(height: 12),

          // Item list
          ...list.items.map((item) {
            return Row(
              children: [
                Checkbox(
                  value: item.checked,
                  onChanged:
                      null, // Không cho phép chỉnh sửa nếu là danh sách chia sẻ
                ),
                Icon(item.icon),
                const SizedBox(width: 8),
                Text(item.name),
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
              // Giả lập thêm danh sách chia sẻ vào _lists
              setState(() {
                _sharedLists.add(
                  ShoppingListModelShare(
                    date: DateTime.now(),
                    title: 'Weekend Grocery',
                    sharedBy: invite['from'],
                    items: [
                      ShoppingItem("Milk", Icons.local_drink, false),
                      ShoppingItem("Eggs", Icons.egg, false),
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
              // Header
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
                              builder: (_) => NewListPage(
                                itemsByCategory: DataStore.itemsByCategory,
                              ),
                            ),
                          );

                          if (result is ShoppingListModel) {
                            final index = _lists.indexWhere((list) =>
                                list.date.year == result.date.year &&
                                list.date.month == result.date.month &&
                                list.date.day == result.date.day);

                            if (index != -1) {
                              // Ngày trùng => hỏi người dùng
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
                                        // 1. Lấy danh sách item cũ
                                        final oldItems = _lists[index].items;
                                        setState(() {
                                          // 2. Xóa khỏi foodInventory
                                          for (var oldItem in oldItems) {
                                            Provider.of<FoodInventoryProvider>(
                                                    context,
                                                    listen: false)
                                                .removeItem(foodInventory
                                                    .firstWhere((food) =>
                                                        food.name ==
                                                        oldItem.name));
                                            foodInventory.removeWhere((inv) =>
                                                inv.name == oldItem.name);
                                          }
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

              // Card
              Expanded(
                child: ListView(
                  children: [
                    // Danh sách chia sẻ hiển thị trước
                    ..._sharedLists
                        .map((shared) => buildSharedListCard(shared)),

                    const SizedBox(height: 24),

                    // Danh sách cá nhân người dùng
                    ..._lists.asMap().entries.map(
                          (entry) => _buildListCard(entry.value, entry.key),
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
                    bool alreadyExists =
                        foodInventory.any((food) => food.name == item.name);
                    if (item.checked) {
                      //them vao invetory neu chua co
                      if (!alreadyExists) {
                        final newItem = FoodItem(item.name, item.icon,
                            item.checked, 0, '', DateTime.now());
                        foodInventory.add(newItem);
                        Provider.of<FoodInventoryProvider>(context,
                                listen: false)
                            .addItem(newItem);
                      }
                    } else {
                      // Nếu bỏ check: xóa khỏi inventory nếu đang có
                      if (alreadyExists) {
                        Provider.of<FoodInventoryProvider>(context,
                                listen: false)
                            .removeItem(foodInventory
                                .firstWhere((food) => food.name == item.name));
                        foodInventory
                            .removeWhere((food) => food.name == item.name);
                      }
                    }
                  });
                },
        ),
        Icon(item.icon),
        const SizedBox(width: 8),
        Text(item.name, style: const TextStyle(fontSize: 16)),
      ],
    );
  }
}

class ShoppingItem {
  String name;
  IconData icon;
  bool checked;

  ShoppingItem(this.name, this.icon, this.checked);
}
