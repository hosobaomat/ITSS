import 'package:flutter/material.dart';
import 'package:login_menu/models/getGroupMember.dart';

class GroupMemberListPage extends StatelessWidget {
  final List<GroupMember> members;
  final int groupId;
  final String groupName;
  final String createdBy;
  final DateTime createdAt;
  const GroupMemberListPage({super.key, required this.members, required this.groupId, required this.groupName, required this.createdBy, required this.createdAt});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Thành viên trong nhóm"),
        backgroundColor: Colors.blueGrey,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: members.isEmpty
          ? const Center(child: Text("Không có thành viên nào"))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: members.length,
              itemBuilder: (context, index) {
                final member = members[index];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blueGrey,
                      child: Text(
                        member.username.substring(0, 1).toUpperCase(),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(member.fullName,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Username: ${member.username}"),
                        Text("Email: ${member.email}"),
                        Text("Vai trò: ${member.role}"),
                      ],
                    ),
                    trailing: const Icon(Icons.person),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                );
              },
            ),
    );
  }
}