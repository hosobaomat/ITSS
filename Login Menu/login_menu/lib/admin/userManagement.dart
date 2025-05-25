import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:login_menu/service/auth_service.dart';

class UserManagementScreen extends StatefulWidget {
  final AuthService authService;

  const UserManagementScreen({super.key, required this.authService});

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  List<dynamic> users = [];
  String searchQuery = ''; // Lưu từ khóa tìm kiếm
  static const String apiUrl = "http://192.168.0.100:8082/ITSS_BE";

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> fetchUsers() async {
    final token = widget.authService.token;
    if (token == null) {
      print('Token is null');
      return;
    }

    final response = await http.get(
      Uri.parse('$apiUrl/users'),
      headers: {'Authorization': 'Bearer $token'},
    );

    print('Fetch Users - Status Code: ${response.statusCode}');
    print('Fetch Users - Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data is Map && data.containsKey('result') && data['result'] is List) {
        setState(() {
          users = data['result'];
          print('Users updated: $users');
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Dữ liệu không phải danh sách hợp lệ')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi: ${response.statusCode} - ${response.body}'),
        ),
      );
    }
  }

  Future<void> createUser(
      String username, String password, String email, String fullName) async {
    final token = widget.authService.token;
    if (token == null) {
      print("Token is null");
      return;
    }

    if (username.isEmpty ||
        password.isEmpty ||
        email.isEmpty ||
        fullName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Vui lòng nhập đầy đủ thông tin.')),
      );
      return;
    }

    final url = Uri.parse('$apiUrl/users');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: json.encode({
          'username': username,
          'password': password,
          'email': email,
          'fullName': fullName,
          'role': 'user',
        }),
      );

      print('Create User - Status: ${response.statusCode}');
      print('Create User - Body: ${response.body}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        fetchUsers();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Không thể tạo tài khoản. Mã lỗi: ${response.statusCode}, Nội dung: ${response.body}',
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đã xảy ra lỗi: $e')),
      );
    }
  }

  Future<void> updateUser(
      int userId, String newUsername, String password, String email) async {
    final token = widget.authService.token;
    if (token == null) return;

    final body = {
      'username': newUsername,
      'email': email,
      'fullName': users.firstWhere((u) => u['userId'] == userId,
              orElse: () => {})['fullName'] ??
          'Unknown',
      'birthDate': '2000-01-01',
      'roles': users.firstWhere((u) => u['userId'] == userId,
              orElse: () => {})['role'] ??
          'user',
      if (password.isNotEmpty) 'password': password,
    };

    final response = await http.put(
      Uri.parse('$apiUrl/users/$userId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(body),
    );

    print('Update User - Status: ${response.statusCode}');
    print('Update User - Response Body: ${response.body}');

    if (response.statusCode == 200) {
      fetchUsers();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Cập nhật thất bại: ${response.statusCode} - ${response.body}'),
        ),
      );
    }
  }

  Future<void> deleteUser(int userId) async {
    final token = widget.authService.token;
    if (token == null) {
      print("Token is null");
      return;
    }

    try {
      final response = await http.delete(
        Uri.parse('$apiUrl/users/$userId'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      print('Delete User - Status: ${response.statusCode}');
      print('Delete User - Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 204) {
        fetchUsers(); // Làm mới danh sách sau khi xóa
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Xóa tài khoản thành công')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Xóa thất bại: ${response.statusCode} - ${response.body}',
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đã xảy ra lỗi: $e')),
      );
    }
  }

  void showCreateUserDialog() {
    final TextEditingController usernameController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController fullNameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Tạo tài khoản mới'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: usernameController,
                decoration: InputDecoration(labelText: 'Username'),
              ),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
              ),
              TextField(
                controller: fullNameController,
                decoration: InputDecoration(labelText: 'Full Name'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () {
                createUser(
                  usernameController.text.trim(),
                  passwordController.text.trim(),
                  emailController.text.trim(),
                  fullNameController.text.trim(),
                );
                Navigator.of(context).pop();
              },
              child: Text('Tạo'),
            ),
          ],
        );
      },
    ).then((_) {
      usernameController.dispose();
      passwordController.dispose();
      emailController.dispose();
      fullNameController.dispose();
    });
  }

  void showEditDialog(Map<String, dynamic> user) {
    final TextEditingController usernameController =
        TextEditingController(text: user['username']);
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController emailController =
        TextEditingController(text: user['email'] ?? '');
    final TextEditingController fullNameController =
        TextEditingController(text: user['fullName'] ?? '');

    final userId = user['userId'] ?? user['id'];
    if (userId == null) {
      print('Error: userId not found in user data: $user');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không thể chỉnh sửa: userId không hợp lệ')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Chỉnh sửa tài khoản'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: usernameController,
                decoration: InputDecoration(labelText: 'Username'),
              ),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(labelText: 'Password mới'),
                obscureText: true,
              ),
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
              ),
              TextField(
                controller: fullNameController,
                decoration: InputDecoration(labelText: 'Full Name'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () {
                updateUser(
                  int.tryParse(userId.toString()) ?? 0,
                  usernameController.text.trim(),
                  passwordController.text.trim(),
                  emailController.text.trim(),
                );
                Navigator.of(context).pop();
              },
              child: Text('Lưu'),
            ),
          ],
        );
      },
    ).then((_) {
      usernameController.dispose();
      passwordController.dispose();
      emailController.dispose();
      fullNameController.dispose();
    });
  }

  void showDeleteConfirmationDialog(Map<String, dynamic> user) {
    final userId = user['userId'] ?? user['id'];
    if (userId == null) {
      print('Error: userId not found in user data: $user');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không thể xóa: userId không hợp lệ')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Xác nhận xóa'),
          content: Text(
              'Bạn có chắc chắn muốn xóa tài khoản "${user['username']}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () {
                deleteUser(int.tryParse(userId.toString()) ?? 0);
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
              child: Text('Xóa'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredUsers = users.where((user) {
      final username = user['username']?.toString().toLowerCase() ?? '';
      final email = user['email']?.toString().toLowerCase() ?? '';
      final fullName = user['fullName']?.toString().toLowerCase() ?? '';
      final query = searchQuery.toLowerCase();
      return user['role'] == 'user' &&
          (username.contains(query) ||
              email.contains(query) ||
              fullName.contains(query));
    }).toList();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('User'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Tìm kiếm',
                hintText: 'Nhập username, email hoặc full name',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value; // Cập nhật từ khóa tìm kiếm
                });
              },
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: showCreateUserDialog,
                  child: const Text('Tạo tài khoản'),
                ),
              ],
            ),
            const Divider(height: 32),
            Expanded(
              child: ListView.builder(
                itemCount: filteredUsers.length,
                itemBuilder: (context, index) {
                  final user = filteredUsers[index];
                  return ListTile(
                    title: Text(user['username'] ?? 'Không có tên'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Email: ${user['email'] ?? 'Không có'}'),
                        Text('Role: ${user['role'] ?? 'Không có'}'),
                        Text('Full Name: ${user['fullName'] ?? 'Không có'}'),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => showEditDialog(user),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => showDeleteConfirmationDialog(user),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
