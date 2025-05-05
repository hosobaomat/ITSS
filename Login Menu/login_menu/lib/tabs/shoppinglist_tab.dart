import 'package:flutter/material.dart';
import 'package:login_menu/data/data_store.dart';
import 'package:login_menu/models/shopping_list_model.dart.dart';
import 'package:login_menu/pages/new_list_page.dart';

class ShoppingListTab extends StatefulWidget {
  const ShoppingListTab({super.key});

  @override
  State<ShoppingListTab> createState() => _ShoppingListTabState();
}

class _ShoppingListTabState extends State<ShoppingListTab> {
  final List<ShoppingListModel> _lists = [];
  final List<String> _weekdayNames = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];
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
              IconButton(
                onPressed: () {
                  _removeList(index);
                },
                icon: const Icon(
                  Icons.delete_outline,
                  color: Colors.red,
                ),
              ),
            ],
          ),
          Text('${list.completedCount} of ${list.items.length} items'),
          const SizedBox(height: 12),
          ...list.items.map((item) => buildItem(item)),
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
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline, size: 30),
                    onPressed: () async {
                      {
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
                                      Navigator.pop(context); // Đóng dialog
                                    },
                                    child: const Text('Không'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        _lists[index] = result;
                                      });
                                      Navigator.pop(context); // Đóng dialog
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
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Card
              Expanded(
                child: ListView.builder(
                  itemCount: _lists.length,
                  itemBuilder: (context, index) {
                    final list = _lists[index];
                    return _buildListCard(list, index);
                  },
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildItem(ShoppingItem item) {
    return Row(
      children: [
        Checkbox(
          value: item.checked,
          onChanged: (val) {
            setState(() {
              item.checked = val ?? false;
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
