import 'package:flutter/material.dart';
import 'package:login_menu/data/data_store.dart';
import 'package:login_menu/pages/createGroupPage.dart';

class JoinGroupPage extends StatelessWidget {
  const JoinGroupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        centerTitle: true,
        title: const Text(
          "Tham gia nhóm",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.group_add,
              size: 100,
              color: Colors.blueGrey,
            ),
            const SizedBox(height: 20),
            const Text(
              "Bạn muốn bắt đầu như thế nào?",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              icon: const Icon(Icons.create_new_folder),
              label: const Text("Tạo nhóm mới"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        CreateGroupPage(userId: DataStore().userCreateID), // truyền ID user thật
                  ),
                );
                // TODO: Chuyển sang màn tạo nhóm
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Đi tới trang Tạo nhóm')),
                );
              },
            ),
            const SizedBox(height: 20),
            OutlinedButton.icon(
              icon: const Icon(Icons.link),
              label: const Text("Tham gia bằng liên kết"),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                side: const BorderSide(color: Colors.blueGrey),
                foregroundColor: Colors.blueGrey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: () {
                // TODO: Chuyển sang màn nhập link
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Đi tới trang Nhập link nhóm')),
                );
              },
            ),
            const SizedBox(height: 40),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Quay về nếu cần
              },
              child: const Text(
                "Quay lại",
                style: TextStyle(color: Colors.grey),
              ),
            )
          ],
        ),
      ),
    );
  }
}
