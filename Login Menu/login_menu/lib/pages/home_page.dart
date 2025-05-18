import 'package:flutter/material.dart';
import 'package:login_menu/service/auth_service.dart';
import 'package:login_menu/tabs/recipes_Screen_tab.dart';
import 'package:login_menu/tabs/shoppinglist_tab.dart';
import 'package:login_menu/tabs/categories_tab.dart';
import 'package:login_menu/tabs/profil_tab.dart';
import 'package:login_menu/tabs/food_inventory_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.authService});
  final AuthService authService;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.green,
        // actions: _selectedIndex == 2
        //     ? [
        //         // chỉ tab Cart mới có nút share
        //         IconButton(
        //           icon: const Icon(Icons.share),
        //           onPressed: () {
        //             ScaffoldMessenger.of(context).showSnackBar(
        //               const SnackBar(content: Text('Đã chia sẻ danh sách!')),
        //             );
        //           },
        //         ),
        //       ]
        //     : null,
      ),

      // Các tab ở bottom bar
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          //tab shopping
          ShoppingListTab(authService: widget.authService),

          // Tab Categories
          CategoriesTab(),

          // Tab Cart
          FoodInventoryScreen(inventoryItems: [],),

          //recipes Tab
          RecipesScreen(inventoryItems: [],),

          // Tab profile
          ProfilTab(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: 'Food Inventory',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt),
            label: 'Recipes',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
