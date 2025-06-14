import 'package:flutter/material.dart';
import 'package:login_menu/data/data_store.dart';
import 'package:login_menu/models/notification.dart';
import 'package:login_menu/service/auth_service.dart';

class NotificationPopup extends StatelessWidget {
  final List<UserNotification> notifications;

  const NotificationPopup({Key? key, required this.notifications})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final n = notifications.first;
    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.warning_amber_rounded, color: Colors.redAccent),
          SizedBox(width: 8),
          Text('Thông báo hết hạn'),
        ],
      ),
      content: Text(n.message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Đã hiểu'),
        ),
      ],
    );
  }
}

void showNotificationPopup(
    BuildContext context, int userId, AuthService authService) async {
  // Fetch ở ngoài dialog!
  final notis = await authService.fetchUserNotifications(DataStore().userId!);
  final expired =
      notis.where((n) => n.notificationType == 'EXPIRED' && !n.isRead).toList();

  if (expired.isEmpty) return; // Không show popup nếu không có sản phẩm hết hạn

  // Có sản phẩm hết hạn thì show dialog như trước
  showDialog(
    context: context,
    builder: (_) => NotificationPopup(notifications: expired),
  );
}
