import 'package:flutter/material.dart';
import 'package:login_menu/admin/ProductManage.dart';
import 'package:login_menu/admin/Unitmanage.dart';
import 'package:login_menu/admin/recipes.dart';
import 'package:login_menu/admin/settings.dart';
import 'package:login_menu/admin/userManagement.dart';
import 'package:login_menu/service/auth_service.dart';

class Adminhomepage extends StatefulWidget {
  const Adminhomepage({super.key, required this.authService});
  final AuthService authService;
  @override
  State<Adminhomepage> createState() => _AdminhomepageState();
}

class _AdminhomepageState extends State<Adminhomepage> {
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
      ),

      // Các tab ở bottom bar
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          UserManagementScreen(
            authService: widget.authService,
          ),
          Productmanage(),
          UnitManagementScreen(),
          RecipeManagerScreen(),
          Settings(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'User'),
          BottomNavigationBarItem(
              icon: Icon(Icons.category), label: 'Categories'),
          BottomNavigationBarItem(icon: Icon(Icons.category), label: 'Unit'),
          BottomNavigationBarItem(
              icon: Icon(Icons.food_bank), label: 'Recipes'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}
