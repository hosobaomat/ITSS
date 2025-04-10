import 'package:flutter/material.dart';

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
        actions: _selectedIndex == 3
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
          // Tab profile
          const Center(child: Text('Profile')),

          // Tab Shop
          Center(
            child: Column(
              children: [
                // Thanh tìm kiếm
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Tìm kiếm sản phẩm...',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(color: Colors.green),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Tab Categories
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tiêu đề "All Categories"
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'All Categories',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                // Danh sách các category
                Expanded(
                  child: ListView(
                    children: const [
                      ListTile(
                        title: Text('Category 1'),
                        leading: Icon(Icons.category),
                      ),
                      ListTile(
                        title: Text('Category 2'),
                        leading: Icon(Icons.category),
                      ),
                      ListTile(
                        title: Text('Category 3'),
                        leading: Icon(Icons.category),
                      ),
                      ListTile(
                        title: Text('Category 4'),
                        leading: Icon(Icons.category),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Tab Cart
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Tiêu đề "My Cart"
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'My Cart',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                // Nút chọn danh sách theo ngày
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // Logic để chọn ngày
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 24,
                          ),
                          textStyle: TextStyle(fontSize: 16),
                        ),
                        child: const Text(
                          'Chọn ngày',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      SizedBox(height: 16),
                    ],
                  ),
                ),
                // Danh sách các mặt hàng
                Expanded(
                  child: Center(
                    child: Text(
                      'Giỏ hàng của bạn trống!',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(icon: Icon(Icons.shopify), label: 'Shop'),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: 'Cart',
          ),
        ],
      ),
    );
  }
}
