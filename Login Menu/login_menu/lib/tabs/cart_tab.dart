import 'package:flutter/material.dart';

class CartTab extends StatelessWidget {
  const CartTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
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
    );
  }
}
