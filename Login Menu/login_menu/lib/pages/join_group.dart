import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:login_menu/data/data_store.dart';
import 'package:login_menu/pages/createGroupPage.dart';
import 'package:http/http.dart' as http;
import 'package:login_menu/pages/joinByInviteCode.dart';

class JoinGroupPage extends StatelessWidget {
  String token;
  JoinGroupPage({super.key, required this.token});
  Future<void> addUsertoGroup() async {
    try {
      final response = await http.post(
          Uri.parse(
              '${DataStore().url}/family_group/${DataStore().groupcreatID}/members'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({
            'userIds': [DataStore().userCreateID]
          }));
      if (response.statusCode == 200 || response.statusCode == 201) {
        print('them vao nhom ${DataStore().groupcreatID}thanh cong');
      } else {
        print('${response.statusCode} - ${response.body} - ${DataStore().groupcreatID}');
        print('tao nhom that bai');
      }
    } catch (e) {
      print('loi $e');
    }
  }

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
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreateGroupPage(
                      userId: DataStore().userCreateID,
                      token: token,
                    ), // truyền ID user thật
                  ),
                );
                if (result == true) {
                }
                // TODO: Chuyển sang màn tạo nhóm
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
              onPressed: () {Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => JoinGroupPageByInviteCode(token: token, userId: DataStore().userCreateID,) // truyền ID user thật
                  ),
                );
                // TODO: Chuyển sang màn nhập link
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
