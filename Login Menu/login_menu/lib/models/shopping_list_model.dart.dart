import 'package:login_menu/tabs/shoppinglist_tab.dart';

class ShoppingListModel {
  final DateTime date;
  final String listName;
  final List<ShoppingItem> items;
  final int? listId;
  ShoppingListModel(
      {required this.date,
      required this.listName,
      required this.items,
      required this.listId});

  int get completedCount => items.where((item) => item.checked).length;
}
