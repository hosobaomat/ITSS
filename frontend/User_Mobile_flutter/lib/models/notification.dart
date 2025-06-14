class UserNotification {
  final int notificationId;
  final String message;
  final String notificationType;
  final DateTime createdAt;
  final bool isRead;
  final int userId;
  final int foodId;

  UserNotification({
    required this.notificationId,
    required this.message,
    required this.notificationType,
    required this.createdAt,
    required this.isRead,
    required this.userId,
    required this.foodId,
  });

  factory UserNotification.fromJson(Map<String, dynamic> json) {
    return UserNotification(
      notificationId: json['notificationId'] as int,
      message: json['message'] as String,
      notificationType: json['notificationType'] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt']),
      isRead: json['isRead'] as bool,
      userId: json['userId'] as int,
      foodId: json['foodId'] as int,
    );
  }
}
