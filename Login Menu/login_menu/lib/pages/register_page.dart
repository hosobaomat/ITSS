import 'package:flutter/material.dart';
import 'package:login_menu/Components/create_button.dart';
import 'package:login_menu/data/data_store.dart';
import 'package:login_menu/models/createUser.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:login_menu/pages/join_group.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Controllers cho các trường nhập
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();

  // role mặc định
  String selectedRole = 'user';

  // Gọi API đăng ký
  Future<void> signUpUser() async {
    final username = usernameController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();
    final email = emailController.text.trim();
    final fullName = fullNameController.text.trim();

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Password không khớp')),
      );
      return;
    }

    final user = User(
      username: username,
      password: password,
      email: email,
      fullName: fullName,
      role: selectedRole,
    );

    try {
      final response = await http.post(
        Uri.parse(DataStore().url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(user.toJson()),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final decodedBody = jsonDecode(response.body);
        DataStore().userCreateID = decodedBody['result']['userid'];
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Đăng ký thành công')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const JoinGroupPage()),
        ); // quay lại màn hình login (nếu có)
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Đăng ký thất bại: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi kết nối: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.grey,
        centerTitle: true,
        title: const Text(
          'Register Page',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.lock, size: 100),
                const SizedBox(height: 20),

                _buildTextField("Username", usernameController),
                const SizedBox(height: 10),
                _buildTextField("Email", emailController),
                const SizedBox(height: 10),
                _buildTextField("Full Name", fullNameController),
                const SizedBox(height: 10),
                _buildTextField("Password", passwordController,
                    isPassword: true),
                const SizedBox(height: 10),
                _buildTextField("Confirm Password", confirmPasswordController,
                    isPassword: true),
                const SizedBox(height: 10),

                // Role dropdown
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: DropdownButtonFormField<String>(
                    value: selectedRole,
                    decoration: InputDecoration(
                      labelText: "Role",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                    items: ['user']
                        .map((role) =>
                            DropdownMenuItem(value: role, child: Text(role)))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedRole = value!;
                      });
                    },
                  ),
                ),

                const SizedBox(height: 40),
                CreateButton(onTap: signUpUser),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Hàm tạo ô nhập liệu
  Widget _buildTextField(String label, TextEditingController controller,
      {bool isPassword = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          labelText: label,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: Colors.grey),
          ),
        ),
      ),
    );
  }
}
