import 'package:flutter/material.dart';
import 'package:login_menu/Components/create_button.dart';
import 'package:login_menu/data/data_store.dart';
import 'package:login_menu/models/createUser.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:login_menu/pages/join_group.dart';
import 'package:login_menu/service/auth_service.dart';

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
  final AuthService authService = AuthService();
  String? errorUsername;
String? errorEmail;
String? errorFullName;
String? errorPassword;
String? errorConfirmPassword;

  // role mặc định
  String selectedRole = 'user';

  Future<void> signUpUser() async {
  setState(() {
    errorUsername = usernameController.text.trim().isEmpty ? 'Vui lòng nhập username' : null;
    errorEmail = emailController.text.trim().isEmpty ? 'Vui lòng nhập email' : null;
    errorFullName = fullNameController.text.trim().isEmpty ? 'Vui lòng nhập họ tên' : null;
    errorPassword = passwordController.text.trim().isEmpty ? 'Vui lòng nhập mật khẩu' : null;
    errorConfirmPassword = confirmPasswordController.text.trim().isEmpty ? 'Vui lòng xác nhận mật khẩu' : null;

    if (passwordController.text != confirmPasswordController.text) {
      errorConfirmPassword = 'Mật khẩu xác nhận không khớp';
    }
  });

  if (errorUsername != null ||
      errorEmail != null ||
      errorFullName != null ||
      errorPassword != null ||
      errorConfirmPassword != null) {
    return; // Dừng nếu có lỗi
  }

  // Dưới đây giữ nguyên logic cũ
  final user = User(
    username: usernameController.text.trim(),
    password: passwordController.text.trim(),
    email: emailController.text.trim(),
    fullName: fullNameController.text.trim(),
    role: selectedRole,
  );

  try {
    final response = await http.post(
      Uri.parse('${DataStore().url}/users'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(user.toJson()),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      final decodedBody = jsonDecode(response.body);
      DataStore().userCreateID = decodedBody['result']['userid'];
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đăng ký thành công')),
      );
      bool success = await authService.login(
        emailController.text.trim(),
        passwordController.text.trim(),
      );
      String? token;
      if (success) {
        token = authService.token;
      }
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => JoinGroupPage(token: token ?? '')),
      );
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

                _buildTextField("Username", usernameController, errorText: errorUsername),
                const SizedBox(height: 10),
                _buildTextField("Email", emailController, errorText: errorEmail),
                const SizedBox(height: 10),
                _buildTextField("Full Name", fullNameController, errorText: errorFullName),
                const SizedBox(height: 10),
                _buildTextField("Password", passwordController,
                    isPassword: true, errorText: errorPassword),
                const SizedBox(height: 10),
                _buildTextField("Confirm Password", confirmPasswordController,
                    isPassword: true, errorText: errorConfirmPassword),
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
      {bool isPassword = false, String? errorText}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          labelText: label,
          errorText: errorText,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: Colors.grey),
          ),
        ),
      ),
    );
  }
}
