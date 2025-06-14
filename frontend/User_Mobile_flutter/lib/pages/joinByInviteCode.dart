import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:login_menu/data/data_store.dart';

class JoinGroupPageByInviteCode extends StatefulWidget {
  final int userId;
  final String token;

  const JoinGroupPageByInviteCode({super.key, required this.userId, required this.token});

  @override
  State<JoinGroupPageByInviteCode> createState() => _JoinGroupPageState();
}

class _JoinGroupPageState extends State<JoinGroupPageByInviteCode> {
  final TextEditingController codeController = TextEditingController();
  bool isLoading = false;

  Future<void> joinGroup() async {
    final code = codeController.text.trim();

    if (code.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vui lòng nhập mã nhóm")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      // Gửi request POST để tham gia nhóm bằng mã
      final response = await http.post(
        Uri.parse('${DataStore().url}/family_group/join/${code}'), // 👈 Thay đổi URL theo API thực tế
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.token}',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Tham gia nhóm thành công!")),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Lỗi: ${response.body}")),
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
        title: const Text("Tham gia nhóm"),
        backgroundColor: Colors.blueGrey,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          children: [
            const Icon(Icons.group_add, size: 80, color: Colors.blueGrey),
            const SizedBox(height: 20),
            TextField(
              controller: codeController,
              decoration: InputDecoration(
                labelText: "Nhập mã nhóm",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            const SizedBox(height: 30),
            isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton.icon(
                    icon: const Icon(Icons.input),
                    label: const Text("Tham gia nhóm"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueGrey,
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: joinGroup,
                  ),
          ],
        ),
      ),
    );
  }
}
