import 'package:login_menu/tabs/ShoppingList.dart';

class ShoppingListModel {
  final DateTime date;
  final List<ShoppingItem> items;

  ShoppingListModel({required this.date, required this.items});

  int get completedCount => items.where((item) => item.checked).length;
}
