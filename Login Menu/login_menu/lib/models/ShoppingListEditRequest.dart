import 'package:login_menu/tabs/shoppinglist_tab.dart';

class Shoppinglisteditrequest {
  final int? ShoppingListID;
  final String? name;
  final DateTime? date;
  final List<ShoppingItem> shoppinglistitem;

  Shoppinglisteditrequest({required this.ShoppingListID, required this.name, required this.date, required this.shoppinglistitem,});
}
