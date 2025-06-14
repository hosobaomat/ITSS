import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:login_menu/service/auth_service.dart';

class SharingMembersPage extends StatefulWidget {
  const SharingMembersPage({super.key});

  @override
  State<SharingMembersPage> createState() => _SharingMembersPageState();
}

class _SharingMembersPageState extends State<SharingMembersPage> {
  List<String> selectedUsers = [];
  List<String> members = [];
  List<String> filteredMembers = [];
  final TextEditingController searchController = TextEditingController();

  // Hàm gọi fetchGroupData từ AuthService để lấy danh sách thành viên
  Future<void> fetchGroupData(int groupId) async {
    final authService = Provider.of<AuthService>(context, listen: false);

    try {
      final groupData = await authService
          .fetchGroupData(groupId); // Gọi fetchGroupData từ AuthService
      setState(() {
        members = List<String>.from(groupData['members'] ?? []);
        members.sort(); // Sắp xếp theo thứ tự A-Z
        filteredMembers = List.from(members);
      });
    } catch (e) {
      print('Lỗi khi lấy dữ liệu nhóm: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi lấy dữ liệu nhóm: $e')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    fetchGroupData(
        1); // Gọi API với groupId là 1 (hoặc thay thế bằng ID nhóm thực tế)
  }

  void _addMemberDialog() {
    String newMember = '';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Member'),
        content: TextField(
          onChanged: (value) {
            newMember = value;
          },
          decoration: const InputDecoration(hintText: 'Enter member email'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (newMember.isNotEmpty) {
                setState(() {
                  members.add(newMember);
                  members.sort(); // Sắp xếp lại
                  _filterMembers(
                      searchController.text); // Cập nhật danh sách hiển thị
                });
              }
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _deleteMember(int index) {
    final memberName = filteredMembers[index];
    setState(() {
      selectedUsers.remove(memberName);
      members.remove(memberName);
      _filterMembers(searchController.text);
    });
  }

  void _toggleSelection(String name) {
    setState(() {
      if (selectedUsers.contains(name)) {
        selectedUsers.remove(name);
      } else {
        selectedUsers.add(name);
      }
    });
  }

  void _selectAllMembers() {
    setState(() {
      if (selectedUsers.length == members.length) {
        selectedUsers.clear();
      } else {
        selectedUsers = List.from(members);
      }
    });
  }

  void _filterMembers(String keyword) {
    setState(() {
      filteredMembers = members
          .where(
              (member) => member.toLowerCase().contains(keyword.toLowerCase()))
          .toList();
    });
  }

  void _deleteSelectedMembers() {
    setState(() {
      members.removeWhere((member) => selectedUsers.contains(member));
      selectedUsers.clear();
      members.sort(); // Giữ thứ tự bảng chữ cái
      _filterMembers(searchController.text); // Cập nhật danh sách lọc
    });
  }

  void _shareSelectedMembers() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sharing Members'),
        content: Text('You are sharing with:\n\n${selectedUsers.join('\n')}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sharing & Members'),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
        actions: [
          IconButton(
            onPressed: _selectAllMembers,
            icon: const Icon(Icons.group_add),
            tooltip: 'Select All',
          ),
          IconButton(
            onPressed: _deleteSelectedMembers,
            icon: const Icon(Icons.delete_forever),
            tooltip: 'Delete Selected',
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              onChanged: _filterMembers,
              decoration: InputDecoration(
                hintText: 'Search members...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          // Danh sách thành viên
          Expanded(
            child: ListView.builder(
              itemCount: filteredMembers.length,
              itemBuilder: (context, index) {
                final name = filteredMembers[index];
                final isSelected = selectedUsers.contains(name);
                return ListTile(
                  leading: Checkbox(
                    value: isSelected,
                    onChanged: (_) => _toggleSelection(name),
                  ),
                  title: Text(name),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteMember(index),
                  ),
                  onTap: () => _toggleSelection(name),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addMemberDialog,
        child: const Icon(Icons.person_add),
      ),
      bottomNavigationBar: selectedUsers.isNotEmpty
          ? BottomAppBar(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${selectedUsers.length} selected',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: _shareSelectedMembers,
                      label: const Text('Share'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            )
          : null,
    );
  }
}
