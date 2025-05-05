import 'package:flutter/material.dart';
import 'package:login_menu/tabs/shoppinglist_tab.dart';
import 'package:login_menu/tabs/cart_tab.dart';
import 'package:login_menu/tabs/categories_tab.dart';
import 'package:login_menu/tabs/profil_tab.dart';
import 'package:login_menu/tabs/shop_tab.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

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
        actions: _selectedIndex == 2
            ? [
                // chỉ tab Cart mới có nút share
                IconButton(
                  icon: const Icon(Icons.share),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Đã chia sẻ danh sách!')),
                    );
                  },
                ),
              ]
            : null,
      ),

      // Các tab ở bottom bar
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          //tab shopping
          ShoppingListTab(),
          // Tab Shop
          ShopTab(),

          // Tab Categories
          CategoriesTab(),

          // Tab Cart
          CartTab(),

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
          BottomNavigationBarItem(icon: Icon(Icons.shopify), label: 'Shop'),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: 'Cart',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
