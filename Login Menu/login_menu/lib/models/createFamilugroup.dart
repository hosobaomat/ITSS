class Createfamilugroup {
  final String groupName;
  final int createdBy;
  final List<int> members;

  Createfamilugroup({
    required this.groupName,
    required this.createdBy,
    required this.members,
  });

  // Chuyển từ JSON sang object
  factory Createfamilugroup.fromJson(Map<String, dynamic> json) {
    return Createfamilugroup(
      groupName: json['groupName'],
      createdBy: json['createdBy'],
      members: List<int>.from(json['members']),
    );
  }

  // Chuyển object sang JSON
  Map<String, dynamic> toJson() {
    return {
      'groupName': groupName,
      'createdBy': createdBy,
      'members': members,
    };
  }
}
