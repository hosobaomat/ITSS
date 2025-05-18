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
  List<dynamic> deletedUsers = [];
  Set<int> selectedUserIds = {};
  List<dynamic> users = [];
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  String? currentUsername;
  String? currentRole;

  @override
  void initState() {
    super.initState();
    widget.authService.loadToken().then((token) {
      if (token != null) {
        fetchCurrentUserInfo();
        fetchUsers();
      }
    });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> fetchCurrentUserInfo() async {
    final token = widget.authService.token;
    if (token == null) return;

    final response = await http.get(
      Uri.parse('http://localhost:8082/user/me'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        currentUsername = data['username'];
        currentRole = data['role'];
      });
    }
  }

  Future<void> fetchUsers() async {
    final token = widget.authService.token;
    if (token == null) return;

    final response = await http.get(
      Uri.parse('http://localhost:8082/admin/users'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        users = data;
        deletedUsers = data.where((u) => u['isDeleted'] == true).toList();
      });
    }
  }

  Future<void> createUser() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();
    final email = _emailController.text.trim();

    if (username.isEmpty || password.isEmpty || email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Vui lòng nhập đầy đủ thông tin.')),
      );
      return;
    }

    final token = widget.authService.token;
    if (token == null) return;

    final response = await http.post(
      Uri.parse('http://localhost:8082/admin/users'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: json.encode({
        'username': username,
        'password': password,
        'email': email,
        'role': 'user',
        'index': 0
      }),
    );

    if (response.statusCode == 201) {
      fetchUsers();
      _usernameController.clear();
      _passwordController.clear();
      _emailController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không thể tạo tài khoản.')),
      );
    }
  }

  Future<void> deleteUser(int id) async {
    final token = widget.authService.token;
    if (token == null) return;

    final response = await http.delete(
      Uri.parse('http://localhost:8082/admin/users/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      fetchUsers();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Xoá tài khoản thất bại: ${response.statusCode} - ${response.body}',
          ),
        ),
      );
    }
  }

  Future<void> restoreUser(int id) async {
    final token = widget.authService.token;
    if (token == null) return;

    final response = await http.patch(
      Uri.parse('http://localhost:8082/admin/users/restore/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      fetchUsers();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Khôi phục thất bại: ${response.statusCode}'),
        ),
      );
    }
  }

  Future<void> updateUser(
      int id, String username, String password, String email) async {
    final token = widget.authService.token;
    if (token == null) return;

    final body = {
      'username': username,
      'email': email,
    };
    if (password.isNotEmpty) {
      body['password'] = password;
    }

    final response = await http.patch(
      Uri.parse('http://localhost:8082/admin/users/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(body),
    );

    if (response.statusCode == 200) {
      fetchUsers();
    }
  }

  void showEditDialog(Map<String, dynamic> user) {
    final TextEditingController usernameController =
        TextEditingController(text: user['username']);
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController emailController =
        TextEditingController(text: user['email'] ?? '');

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
                  user['id'],
                  usernameController.text,
                  passwordController.text,
                  emailController.text,
                );
                Navigator.of(context).pop();
              },
              child: Text('Lưu'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: createUser,
              child: const Text('Tạo tài khoản'),
            ),
            const Divider(height: 32),
            Expanded(
              child: ListView.builder(
                itemCount: users.where((u) => u['isDeleted'] != true).length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  if (user['isDeleted'] == true) return SizedBox.shrink();

                  return ListTile(
                    title: Text(user['username']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Email: ${user['email'] ?? 'Không có'}'),
                        Text('Role: ${user['role']} | Index: ${user['index']}'),
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
                          icon: Icon(
                            user['isDeleted'] == true
                                ? Icons.restore
                                : Icons.delete,
                            color: user['isDeleted'] == true
                                ? Colors.green
                                : Colors.red,
                          ),
                          onPressed: () {
                            if (user['isDeleted'] == true) {
                              restoreUser(user['id']);
                            } else {
                              deleteUser(user['id']);
                            }
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton.icon(
                onPressed: showRestoreDialog,
                icon: const Icon(Icons.restore),
                label: const Text('Khôi phục tài khoản'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showRestoreDialog() {
    selectedUserIds.clear();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Khôi phục tài khoản đã xoá'),
              content: deletedUsers.isEmpty
                  ? Text('Không có tài khoản nào bị xoá.')
                  : SizedBox(
                      height: 300,
                      width: double.maxFinite,
                      child: ListView.builder(
                        itemCount: deletedUsers.length,
                        itemBuilder: (context, index) {
                          final user = deletedUsers[index];
                          final isSelected =
                              selectedUserIds.contains(user['id']);

                          return CheckboxListTile(
                            title: Text(user['username']),
                            value: isSelected,
                            activeColor: Colors.green,
                            onChanged: (bool? selected) {
                              setState(() {
                                if (selected == true) {
                                  selectedUserIds.add(user['id']);
                                } else {
                                  selectedUserIds.remove(user['id']);
                                }
                              });
                            },
                          );
                        },
                      ),
                    ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Hủy'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    for (var id in selectedUserIds) {
                      await restoreUser(id);
                    }
                    Navigator.pop(context);
                  },
                  child: Text('Khôi phục'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
