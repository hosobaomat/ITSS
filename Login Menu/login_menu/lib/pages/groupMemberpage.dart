import 'package:flutter/material.dart';
import 'package:login_menu/data/data_store.dart';
import 'package:login_menu/models/getGroupMember.dart';

class GroupMemberListPage extends StatefulWidget {
  final List<GroupMember> members;
  final int groupId;
  final String groupName;
  final String createdBy;
  final DateTime createdAt;
  final String currentUser;
  const GroupMemberListPage(
      {super.key,
      required this.members,
      required this.groupId,
      required this.groupName,
      required this.createdBy,
      required this.createdAt,
      required this.currentUser});

  @override
  State<GroupMemberListPage> createState() => _GroupMemberListPageState();
}

class _GroupMemberListPageState extends State<GroupMemberListPage> {
  String? inviteCode;
  bool showInviteCode = false;
  bool isLoadingInviteCode = false;

  Future<void> fetchInviteCode() async {
    setState(() {
      isLoadingInviteCode = true;
    });

    try {
      print(DataStore().GroupID);
      final response =
          await DataStore().authService.fetchGroupCode(DataStore().GroupID);
      if (response != null) {
        setState(() {
          inviteCode = response.result;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Không thể lấy mã mời.")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lỗi khi lấy mã mời.")),
      );
    } finally {
      setState(() {
        isLoadingInviteCode = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Thành viên trong nhóm"),
        backgroundColor: Colors.blueGrey,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            color: Colors.blueGrey.shade100,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Nhóm: ${widget.groupName}",
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  "Ngày tạo: ${widget.createdAt.day}/${widget.createdAt.month}/${widget.createdAt.year}",
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: () async {
                    if (!showInviteCode) {
                      if (inviteCode == null) {
                        await fetchInviteCode();
                      }
                      setState(() {
                        showInviteCode = true;
                      });
                    } else {
                      setState(() {
                        showInviteCode = false;
                      });
                    }
                  },
                  icon: const Icon(Icons.qr_code),
                  label: Text(showInviteCode ? "Ẩn mã mời" : "Hiển thị mã mời"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                if (showInviteCode)
                  isLoadingInviteCode
                      ? const Text("Đang tải mã mời...",
                          style: TextStyle(fontStyle: FontStyle.italic))
                      : inviteCode != null
                          ? Row(
                              children: [
                                const Text("Mã mời: ",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                SelectableText(inviteCode!,
                                    style: const TextStyle(color: Colors.blue)),
                              ],
                            )
                          : const Text("Không thể lấy mã mời.",
                              style: TextStyle(color: Colors.red)),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: () {
                    if (widget.currentUser != widget.createdBy) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text(
                                "Bạn không có quyền xóa nhóm này vì bạn không phải là người tạo.")),
                      );
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text("Xác nhận xóa nhóm"),
                          content: const Text(
                              "Bạn có chắc chắn muốn xóa nhóm này không? Hành động này không thể hoàn tác."),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("Hủy"),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                deleteGroup();
                              },
                              child: const Text("Xóa",
                                  style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.delete),
                  label: const Text("Xóa nhóm"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: widget.members.isEmpty
                ? const Center(child: Text("Không có thành viên nào"))
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: widget.members.length,
                    itemBuilder: (context, index) {
                      final member = widget.members[index];
                      final isCreator = member.username == widget.createdBy;
                      return Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
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
                          title: Text(
                            member.fullName,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Username: ${member.username}"),
                              Text("Email: ${member.email}"),
                              Text(
                                  "Vai trò: ${isCreator ? "Người tạo" : "Thành viên"}"),
                            ],
                          ),
                          trailing: const Icon(Icons.person),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void deleteGroup() async {
    await DataStore().authService.deleteGroup(DataStore().GroupID);
    DataStore().GroupID = 0;
    // TODO: Gọi API xóa nhóm tại đây
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Nhóm đã được xóa.")),
    );
    Navigator.pop(context); // Quay về màn hình trước
  }
}
