import 'package:flutter/material.dart';
import 'package:login_menu/models/notification.dart';
import 'package:login_menu/service/auth_service.dart';
import 'package:login_menu/data/data_store.dart';
import 'package:intl/intl.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<UserNotification> _notifications = [];
  final Set<int> _selectedNotificationIds = {};
  bool _isLoading = false;
  bool _isSelecting = false;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    setState(() => _isLoading = true);
    final data =
        await AuthService().fetchUserNotifications(DataStore().userId!);
    setState(() {
      _notifications = data;
      _selectedNotificationIds.clear();
      _isLoading = false;
      _isSelecting = false;
    });
  }

  void _toggleSelection(int id) {
    setState(() {
      if (_selectedNotificationIds.contains(id)) {
        _selectedNotificationIds.remove(id);
        if (_selectedNotificationIds.isEmpty) _isSelecting = false;
      } else {
        _selectedNotificationIds.add(id);
      }
    });
  }

  void _enterSelectionMode(int id) {
    setState(() {
      _isSelecting = true;
      _selectedNotificationIds.add(id);
    });
  }

  Future<void> _markSelectedAsRead() async {
    setState(() => _isLoading = true);
    try {
      for (var id in _selectedNotificationIds) {
        await AuthService().markNotificationAsRead(id);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đã đánh dấu là đã đọc')),
      );
      await _loadNotifications();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi: $e')),
      );
      setState(() => _isLoading = false);
    }
  }

  void _cancelSelection() {
    setState(() {
      _isSelecting = false;
      _selectedNotificationIds.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final hasSelection = _selectedNotificationIds.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: Text(_isSelecting
            ? 'Đã chọn (${_selectedNotificationIds.length})'
            : 'Thông báo'),
        actions: [
          if (_isSelecting)
            TextButton(
              onPressed: _cancelSelection,
              child: Text(
                'Hủy',
                style: TextStyle(color: Colors.black),
              ),
            ),
          if (_isSelecting && hasSelection)
            TextButton(
              onPressed: _markSelectedAsRead,
              child: Text(
                'Xác nhận',
                style: TextStyle(color: Colors.black),
              ),
            ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _notifications.isEmpty
              ? Center(child: Text('Không có thông báo nào.'))
              : ListView.builder(
                  itemCount: _notifications.length,
                  itemBuilder: (context, index) {
                    final n = _notifications[index];
                    final isSelected =
                        _selectedNotificationIds.contains(n.notificationId);

                    return GestureDetector(
                      onLongPress: n.isRead
                          ? null
                          : () => _enterSelectionMode(n.notificationId),
                      child: ListTile(
                        leading: AnimatedSwitcher(
                          duration: Duration(milliseconds: 200),
                          transitionBuilder: (child, animation) =>
                              FadeTransition(opacity: animation, child: child),
                          child: _isSelecting
                              ? Checkbox(
                                  key: ValueKey('checkbox_${n.notificationId}'),
                                  value: isSelected,
                                  onChanged: n.isRead
                                      ? null
                                      : (val) =>
                                          _toggleSelection(n.notificationId),
                                )
                              : SizedBox(
                                  key: ValueKey(
                                      'no_checkbox_${n.notificationId}'),
                                  width: 0,
                                ),
                        ),
                        title: Text(n.message),
                        subtitle: Text(
                            DateFormat('dd/MM/yyyy HH:mm').format(n.createdAt)),
                        trailing: n.isRead
                            ? null
                            : Icon(Icons.fiber_new, color: Colors.green),
                        onTap: _isSelecting
                            ? () => _toggleSelection(n.notificationId)
                            : null,
                      ),
                    );
                  },
                ),
    );
  }
}
