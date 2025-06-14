class GroupMember {
  final int userid;
  final String username;
  final String email;
  final String fullName;
  final String role;
  final int createdAt;
  final int? updatedAt;

  GroupMember({
    required this.userid,
    required this.username,
    required this.email,
    required this.fullName,
    required this.role,
    required this.createdAt,
    this.updatedAt,
  });

  factory GroupMember.fromJson(Map<String, dynamic> json) {
    return GroupMember(
      userid: json['userid'],
      username: json['username'],
      email: json['email'],
      fullName: json['fullName'],
      role: json['role'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}

class FamilyGroup {
  final int id;
  final String groupName;
  final String createdBy;
  final DateTime createdAt;
  final String? inviteCode;
  final List<GroupMember> members;

  FamilyGroup({
    required this.id,
    required this.groupName,
    required this.createdBy,
    required this.createdAt,
    this.inviteCode,
    required this.members,
  });

  factory FamilyGroup.fromJson(Map<String, dynamic> json) {
    return FamilyGroup(
      id: json['id'],
      groupName: json['groupName'],
      createdBy: json['createdBy'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt']),
      inviteCode: json['inviteCode'],
      members: (json['members'] as List)
          .map((m) => GroupMember.fromJson(m))
          .toList(),
    );
  }
}
