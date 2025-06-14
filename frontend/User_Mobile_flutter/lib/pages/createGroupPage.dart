import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:login_menu/data/data_store.dart';
import 'package:login_menu/models/createFamilugroup.dart';

class CreateGroupPage extends StatefulWidget {
  final int userId; // ID của người tạo (bạn cần truyền vào từ Register/Login)
  final String token;
  const CreateGroupPage({super.key, required this.userId, required this.token});

  @override
  State<CreateGroupPage> createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroupPage> {
  final TextEditingController groupNameController = TextEditingController();
  bool isLoading = false;
  late Createfamilugroup createfamilugroup;
  Future<void> createGroup() async {
    final groupName = groupNameController.text.trim();
    print(widget.token);
    print(widget.userId);
    print(DataStore().url);
    if (groupName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tên nhóm không được để trống')),
      );
      return;
    }

    setState(() => isLoading = true);

    createfamilugroup = Createfamilugroup(
        groupName: groupName,
        createdBy: widget.userId,
        members: [widget.userId]);
    try {
      final response = await http.post(
        Uri.parse('${DataStore().url}/family_group'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.token}',
        },
        body: jsonEncode(createfamilugroup.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Tạo nhóm thành công")),
        );
        final decodedBody = jsonDecode(response.body);
        DataStore().groupcreatID = decodedBody['result']['id'];
        Navigator.pop(context,true); // Hoặc chuyển đến trang chính nếu cần
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Tạo nhóm thất bại: ${response.body}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lỗi kết nối: $e")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tạo nhóm mới"),
        backgroundColor: Colors.blueGrey,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          children: [
            const Icon(Icons.group, size: 80, color: Colors.blueGrey),
            const SizedBox(height: 20),
            TextField(
              controller: groupNameController,
              decoration: InputDecoration(
                labelText: "Tên nhóm",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            const SizedBox(height: 30),
            isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text("Tạo nhóm"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueGrey,
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: createGroup,
                  ),
          ],
        ),
      ),
    );
  }
}
