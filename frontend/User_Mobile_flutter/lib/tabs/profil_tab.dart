import 'package:flutter/material.dart';
import 'package:login_menu/models/fooditem.dart';
import 'package:login_menu/models/getGroupMember.dart';
import 'package:login_menu/models/mealPlan.dart';
import 'package:login_menu/pages/groupMemberpage.dart';
import 'package:login_menu/pages/login_page.dart';
import 'package:login_menu/pages/profile_page.dart';
import 'package:login_menu/data/data_store.dart';

import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilTab extends StatefulWidget {
  const ProfilTab({super.key});

  @override
  State<ProfilTab> createState() => _ProfilTabState();
}

class _ProfilTabState extends State<ProfilTab> {
  File? _avatarImage;
  String _name = '';
  String _email = '';
  FamilyGroup? familyGroup1 = FamilyGroup(
      id: 0,
      groupName: '',
      createdBy: '',
      createdAt: DateTime.now(),
      members: []);
  @override
  void initState() {
    super.initState();
    _loadAvatar();
    _loadProfileInfo();
    _getInforFamilyGroup();
  }

  Future<void> _loadProfileInfo() async {
    String email = DataStore().email;
    String name = DataStore().username;
    print('Loaded profile info: $name, $email');
    if (email.isEmpty || name.isEmpty) {
      print('emtyyyy');
    } else {
      setState(() {
        _name = DataStore().username;
        _email = DataStore().email;
      });
    }
  }

  Future<void> _loadAvatar() async {
    final prefs = await SharedPreferences.getInstance();
    final path = prefs.getString('avatar_path');
    if (path != null && File(path).existsSync()) {
      setState(() {
        _avatarImage = File(path);
      });
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _avatarImage = File(pickedFile.path);
      });

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('avatar_path', pickedFile.path);
    }
  }

  Future<void> _getInforFamilyGroup() async {
    try {
      FamilyGroup? Group = await DataStore()
          .authService
          .fetchFamilyGroupbyId(DataStore().GroupID);
      if (Group != null) {
        setState(() {
          familyGroup1 = Group;
        });
      } else {
        print('khong thay thong tin nhom');
        print(DataStore().GroupID);
      }
    } catch (e) {
      print('Lỗi khi lấy thông tin nhóm: $e');
    }
  }

  Future<void> _handleLogout() async {
    try {
      // Lấy FoodInventoryProvider
      final foodProvider =
          Provider.of<FoodInventoryProvider>(context, listen: false);
      final mealPlanProvider =
          Provider.of<MealPlanProvider>(context, listen: false);
      // // Lưu hồ sơ người dùng vào backend
      // await ApiService.saveUserProfile(
      //   name: _name,
      //   email: _email,
      //   phone: '', // Thêm số điện thoại nếu có
      // );
      // print('Đã lưu hồ sơ người dùng vào backend');

      // // Lưu danh sách FoodItem vào backend
      // await ApiService.saveFoodItems(foodProvider.items);
      // print('Đã lưu danh sách FoodItems vào backend');

      // Xóa dữ liệu cục bộ
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('user_name');
      await prefs.remove('user_email');
      await prefs.remove('avatar_path');
      foodProvider.clearItems();
      mealPlanProvider.clearPlans();
      DataStore().clearAll();
      print(DataStore().GroupID);
      print('Đã xóa dữ liệu cục bộ');

      // Điều hướng về màn hình đăng nhập
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
        (route) => false,
      );
    } catch (e) {
      print('Lỗi khi đăng xuất: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi đăng xuất: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () async {
              await _getInforFamilyGroup();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Đã làm mới thông tin nhóm')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.grey[300],
                      backgroundImage: _avatarImage != null
                          ? FileImage(_avatarImage!)
                          : null,
                      child: _avatarImage == null
                          ? const Icon(Icons.person,
                              color: Colors.white, size: 30)
                          : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_name,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      Text(_email,
                          style: TextStyle(fontSize: 13, color: Colors.grey)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Divider(),
            const _ProfileMenuItem(
                icon: Icons.shopping_bag_outlined, title: 'Orders'),
            const _ProfileMenuItem(icon: Icons.credit_card, title: 'Profile'),
            _ProfileMenuItem(
              icon: Icons.family_restroom,
              title: 'Group Member',
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => GroupMemberListPage(
                              members: familyGroup1?.members ?? [],
                              groupId: familyGroup1?.id ?? 0,
                              groupName: familyGroup1?.groupName ?? '',
                              createdBy: familyGroup1?.createdBy ?? '',
                              createdAt:
                                  familyGroup1?.createdAt ?? DateTime.now(), currentUser: DataStore().username,
                            )));
              },
            ),
            const _ProfileMenuItem(icon: Icons.info_outline, title: 'About'),
            const SizedBox(height: 30),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ElevatedButton(
                  onPressed: _handleLogout,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.red,
                    backgroundColor: Colors.white,
                    side: const BorderSide(color: Colors.red),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 32),
                  ),
                  child: const Text('Log Out'),
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

class _ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;
  const _ProfileMenuItem({
    required this.icon,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap ??
          () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Bạn vừa chọn "$title"')),
            );
          },
    );
  }
}
