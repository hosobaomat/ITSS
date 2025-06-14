import 'package:login_menu/tabs/shoppinglist_tab.dart';

class ShoppingListModelShare {
  final int listId;
  final String sharedBy;
  final String title;
  final DateTime date;
  final List<ShoppingItem> items;

  ShoppingListModelShare({
    required this.listId,
    required this.sharedBy,
    required this.title,
    required this.date,
    required this.items,
  });

  int get completedCount => items.where((item) => item.checked).length;
}
