import 'package:flutter/material.dart';
import 'package:login_menu/data/data_store.dart';
import 'package:login_menu/models/fooditem.dart';
import 'package:login_menu/models/shopping_list_create_request.dart';
import 'package:login_menu/models/shopping_list_model.dart.dart';
import 'package:login_menu/models/ShoppingListModelShare.dart';
import 'package:login_menu/models/update_item.dart';
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
  List<FoodItem> deletedInventory = [];
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
    try {
      final listData = await widget.authService.fetchShoppingLists();
      print('API Response: $listData');

      final fetchedSharedLists = (listData['shared'] as List).map((item) {
        return ShoppingListModelShare(
          date: DateTime.parse(item['date']),
          title: item['title'],
          sharedBy: item['sharedBy'],
          items: (item['items'] as List).map((i) {
            print('Icon name: ${i['icon']}');
            return ShoppingItem(
<<<<<<< HEAD
              i['name'],
              getIconDataFromString(i['icon'] ?? 'help_outline'),
              i['isDone'],
              quantity: i['quantity'] ?? 1, // Thêm số lượng từ API
              category: i['category'], // Thêm category từ API nếu có
            );
=======
                i['name'],
                getIconDataFromString(i['icon'] ?? 'help_outline'),
                i['isDone'],
                0,
                '');
>>>>>>> 898fbf3be0448210a6a988cf05ee58b1dd345f06
          }).toList(),
        );
      }).toList();

      final fetchedPersonalLists = (listData['personal'] as List).map((item) {
        return ShoppingListModel(
          date: DateTime.parse(item['date']),
          items: (item['items'] as List).map((i) {
            print('Icon name: ${i['icon']}');
            return ShoppingItem(
<<<<<<< HEAD
              i['name'],
              getIconDataFromString(i['icon'] ?? 'help_outline'),
              i['isDone'],
              quantity: i['quantity'] ?? 1, // Thêm số lượng từ API
              category: i['category'], // Thêm category từ API nếu có
            );
=======
                i['name'],
                getIconDataFromString(i['icon'] ?? 'help_outline'),
                i['isDone'],
                0,
                '');
>>>>>>> 898fbf3be0448210a6a988cf05ee58b1dd345f06
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
      default:
        return Icons.help_outline;
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
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (_) => SharingMembersPage()));
                    },
                    icon: const Icon(Icons.edit, color: Colors.blue),
                  ),
                  // IconButton(
                  //   onPressed: () {
                  //     Navigator.push(
                  //         context,
                  //         MaterialPageRoute(
                  //             builder: (_) => SharingMembersPage()));
                  //   },
                  //   icon: const Icon(Icons.share, color: Colors.blue),
                  // ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.edit, color: Colors.blue),
                  ),
                  IconButton(
                    onPressed: () {
                      _removeList(index);
                      for (var item in list.items) {
                        bool alreadyExists =
                            foodInventory.any((food) => food.name == item.name);
                        if (alreadyExists) {
                          final inventoryProvider =
                              Provider.of<FoodInventoryProvider>(context,
                                  listen: false);
                          final originalList = inventoryProvider.originalItems;
                          // Lấy danh sách tất cả các mục trùng tên
                          final matchingItems = inventoryProvider.items
                              .where((food) => food.name == item.name)
                              .toList();
                          final quantity = foodInventory
                              .where((food) => food.name == item.name)
                              .toList();
                          for (int i = 0; i < matchingItems.length; i++) {
                            final currenItem = matchingItems[i];
                            if (currenItem.quantity <= 0 ||
                                currenItem.location == '') {
                              inventoryProvider.removeItem(currenItem);
                            } else {
                              for (int j = 0; j < quantity.length; j++) {
                                if (currenItem.location ==
                                        quantity[j].location &&
                                    currenItem.expiry == quantity[j].expiry &&
                                    currenItem.quantity >
                                        quantity[j].quantity) {
                                  //neu trung vi tri va ngay het han va so luong lon hon thi sua quantity
                                  currenItem.quantity -= quantity[j].quantity;
                                  inventoryProvider.updateItem(currenItem);
                                  print('da cap nhat');
                                } else if (currenItem.location ==
                                        quantity[j].location &&
                                    currenItem.expiry == quantity[j].expiry &&
                                    currenItem.quantity ==
                                        quantity[j].quantity) {
                                  //neu trung vi tri va ngay het han tuy nhien thuc pham bang
                                  inventoryProvider.removeItem(currenItem);
                                  print('da xoa');
                                }
                              }
                            }
                          }
                          final newItem = getFoodItemByName(item.name);
                          ItemisDeleted(newItem!);
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
<<<<<<< HEAD
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => InventoryItemInputWidget(
                      items: foodInventory,
                    ),
=======
            child: TextButton(
                onPressed: () {},
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => InventoryItemInputWidget(
                                  items: foodInventory,
                                ))).then((result) {
                      if (result == null) {
                        
                        final updateItemProvider =
                            Provider.of<UpdateItemProvider>(context,
                                listen: false);
                        for (var updateItem in updateItemProvider.updateItems) {
                          final index = foodInventory.indexWhere(
                              (item) => item.name == updateItem.name);
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
>>>>>>> 898fbf3be0448210a6a988cf05ee58b1dd345f06
                  ),
                );
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
                Text('${item.name} (x${item.quantity})'), // Hiển thị số lượng
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
<<<<<<< HEAD
                      ShoppingItem("Milk", Icons.local_drink, false,
                          quantity: 2),
                      ShoppingItem("Eggs", Icons.egg, false, quantity: 12),
=======
                      ShoppingItem("Milk", Icons.local_drink, false, 0, ''),
                      ShoppingItem("Eggs", Icons.egg, false, 0, ''),
>>>>>>> 898fbf3be0448210a6a988cf05ee58b1dd345f06
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
      return null; // Trả về null nếu name rỗng
    }
    try {
      return foodInventory.firstWhere(
        (food) => food.name == name,
      );
    } catch (e) {
      print('Lỗi khi tìm FoodItem với name "$name": $e');
      return null; // Trả về null nếu có lỗi
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
                              builder: (_) => NewListPage(
                                itemsByCategory: DataStore.itemsByCategory, authService: widget.authService,
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
<<<<<<< HEAD
=======
                                        final updateItemProvider =
                                            Provider.of<UpdateItemProvider>(
                                                context,
                                                listen: false);
                                        // 1. Lấy danh sách item cũ
>>>>>>> 898fbf3be0448210a6a988cf05ee58b1dd345f06
                                        final oldItems = _lists[index].items;
                                        setState(() {
                                          for (var oldItem in oldItems) {
                                            final inventoryProvider = Provider
                                                .of<FoodInventoryProvider>(
                                                    context,
                                                    listen: false);
                                            final originalList =
                                                inventoryProvider.originalItems;
                                            // Lấy danh sách tất cả các mục trùng tên
                                            final matchingItems =
                                                inventoryProvider.items
                                                    .where((food) =>
                                                        food.name ==
                                                        oldItem.name)
                                                    .toList();
                                            final quantity = foodInventory
                                                .where((food) =>
                                                    food.name == oldItem.name)
                                                .toList();
                                            for (int i = 0;
                                                i < matchingItems.length;
                                                i++) {
                                              final currenItem =
                                                  matchingItems[i];
                                              if (currenItem.quantity <= 0 ||
                                                  currenItem.location == '') {
                                                inventoryProvider
                                                    .removeItem(currenItem);
                                              } else {
                                                for (int j = 0;
                                                    j < quantity.length;
                                                    j++) {
                                                  if (currenItem.location ==
                                                          quantity[j]
                                                              .location &&
                                                      currenItem.expiry ==
                                                          quantity[j].expiry &&
                                                      currenItem.quantity >
                                                          quantity[j]
                                                              .quantity) {
                                                    //neu trung vi tri va ngay het han va so luong lon hon thi sua quantity
                                                    currenItem.quantity -=
                                                        quantity[j].quantity;
                                                    inventoryProvider
                                                        .updateItem(currenItem);
                                                    print('da cap nhat');
                                                  } else if (currenItem
                                                              .location ==
                                                          quantity[j]
                                                              .location &&
                                                      currenItem.expiry ==
                                                          quantity[j].expiry &&
                                                      currenItem.quantity ==
                                                          quantity[j]
                                                              .quantity) {
                                                    //neu trung vi tri va ngay het han tuy nhien thuc pham bang
                                                    inventoryProvider
                                                        .removeItem(currenItem);
                                                    print('da xoa');
                                                  }
                                                }
                                              }
                                            }
                                            updateItemProvider
                                                .remove(oldItem.name);
                                            foodInventory.removeWhere((food) =>
                                                food.name == oldItem.name);
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
              Expanded(
                child: ListView(
                  children: [
                    ..._sharedLists
                        .map((shared) => buildSharedListCard(shared)),
                    const SizedBox(height: 24),
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
                    bool alreadyExistsinDeletedItem =
                        deletedInventory.any((food) => food.name == item.name);
                    if (item.checked) {
<<<<<<< HEAD
                      if (!alreadyExists) {
                        final newItem = FoodItem(
                          item.name,
                          item.icon,
                          item.checked,
                          item.quantity, // Sử dụng số lượng từ ShoppingItem
                          '',
                          DateTime.now(),
                        );
=======
                      //them vao invetory neu chua co
                      if (!alreadyExists && !alreadyExistsinDeletedItem) {
                        final newItem = FoodItem(item.name, item.icon,
                            item.checked, 0, '', DateTime.now(), false, false);
>>>>>>> 898fbf3be0448210a6a988cf05ee58b1dd345f06
                        foodInventory.add(newItem);
                      } else if (!alreadyExists && alreadyExistsinDeletedItem) {
                        final newItem = deletedInventory
                            .firstWhere((food) => food.name == item.name);
                        ItemnotDeleted(newItem);
                      }
                    } else {
                      if (alreadyExists) {
                        final inventoryProvider =
                            Provider.of<FoodInventoryProvider>(context,
                                listen: false);
                        final originalList = inventoryProvider.originalItems;
                        // Lấy danh sách tất cả các mục trùng tên
                        final matchingItems = inventoryProvider.items
                            .where((food) => food.name == item.name)
                            .toList();
                        final quantity = foodInventory
                            .where((food) => food.name == item.name)
                            .toList();
                        for (int i = 0; i < matchingItems.length; i++) {
                          final currenItem = matchingItems[i];
                          if (currenItem.quantity <= 0 ||
                              currenItem.location == '') {
                            inventoryProvider.removeItem(currenItem);
                          } else {
                            for (int j = 0; j < quantity.length; j++) {
                              if (currenItem.location == quantity[j].location &&
                                  currenItem.expiry == quantity[j].expiry &&
                                  currenItem.quantity > quantity[j].quantity) {
                                //neu trung vi tri va ngay het han va so luong lon hon thi sua quantity
                                currenItem.quantity -= quantity[j].quantity;
                                inventoryProvider.updateItem(currenItem);
                                print('da cap nhat');
                              } else if (currenItem.location ==
                                      quantity[j].location &&
                                  currenItem.expiry == quantity[j].expiry &&
                                  currenItem.quantity == quantity[j].quantity) {
                                //neu trung vi tri va ngay het han tuy nhien thuc pham bang
                                inventoryProvider.removeItem(currenItem);
                                print('da xoa');
                              }
                            }
                          }
                        }
                        // Provider.of<FoodInventoryProvider>(context,
                        //         listen: false)
                        //     .removeItem(foodInventory
                        //         .firstWhere((food) => food.name == item.name));
                        final newItem = getFoodItemByName(item.name);
                        ItemisDeleted(newItem!);
                        // for (var i in foodInventory) {
                        //   print(
                        //       '${i.name} - ${i.isDeleted}-${i.location}-${i.quantity}-${i.expiry}');
                        // }
                        // for (var i in deletedInventory) {
                        //   print(
                        //       '${i.name} - ${i.isDeleted}-${i.location}-${i.quantity}-${i.expiry}');
                        // }
                        foodInventory
                            .removeWhere((food) => food.name == item.name);
                        for (var i in foodInventory) {
                          print(
                              '${i.name} - ${i.isDeleted}-${i.location}-${i.quantity}-${i.expiry}');
                        }
                        for (var i in deletedInventory) {
                          print(
                              '${i.name} - ${i.isDeleted}-${i.location}-${i.quantity}-${i.expiry}');
                        }
                      }
                    }
                  });
                },
        ),
        Icon(item.icon),
        const SizedBox(width: 8),
<<<<<<< HEAD
        Text(
          '${item.name} (x${item.quantity})', // Hiển thị số lượng
          style: const TextStyle(fontSize: 16),
        ),
=======
        Text('${item.name}-${item.quantity}-${item.unit}',
            style: const TextStyle(fontSize: 16)),
>>>>>>> 898fbf3be0448210a6a988cf05ee58b1dd345f06
      ],
    );
  }
}

class ShoppingItem {
  String name;
  IconData icon;
  bool checked;
<<<<<<< HEAD
  final int quantity;
  final String? category; // Thêm category
  ShoppingItem(this.name, this.icon, this.checked,
      {this.quantity = 1, this.category});
=======
  double quantity;
  String unit;
  ShoppingItem(this.name, this.icon, this.checked, this.quantity, this.unit);
>>>>>>> 898fbf3be0448210a6a988cf05ee58b1dd345f06
}
