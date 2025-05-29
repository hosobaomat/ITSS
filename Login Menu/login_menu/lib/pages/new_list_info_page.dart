import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:login_menu/pages/new_list_items_page.dart';
import 'package:login_menu/service/auth_service.dart';
import 'package:login_menu/service/UserAPI.dart' as UserAPI;
import 'package:login_menu/models/shoppinglist_request.dart';

class NewListInfoPage extends StatefulWidget {
  const NewListInfoPage({
    super.key,
    required this.authService,
  });

  final AuthService authService;

  @override
  State<NewListInfoPage> createState() => _NewListInfoPageState();
}

class _NewListInfoPageState extends State<NewListInfoPage> {
  DateTime? _selectedDate;
  final TextEditingController _listNameController = TextEditingController();
  int? _userId;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserId(); // Lấy user_id khi khởi tạo
  }

  Future<void> _loadUserId() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final userInfo = await UserAPI.Userapi
          .getMyInfo(); // Gọi API để lấy thông tin người dùng
      setState(() {
        _userId = userInfo['userid'] as int?; // Kiểm tra 'userid'
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _userId = null; // Nếu lỗi, đặt null để hiển thị thông báo
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Failed to load user info. Please try again.')),
      );
    }
  }

  void _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now.subtract(const Duration(days: 365)),
      lastDate: now.add(const Duration(days: 365)),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _navigateToItemsPage() async {
    if (_listNameController.text.isEmpty || _selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter list name and select date')),
      );
      return;
    }

    if (_userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('User ID not found. Please log in again.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final request = ShoppingListCreateRequest(
      _listNameController.text,
      _userId!, // createdBy
      2, // group_id (giả định group_id bằng user_id, có thể thay đổi nếu cần)
      _selectedDate,
      _selectedDate!.add(const Duration(days: 1)),
      'DRAFT',
    );

    try {
      // Gọi API để lưu danh sách và lấy listId
      final listResponse = await widget.authService.addShoppingList(request);
      final listId = 1;

      if (listId == null) {
        throw Exception('Không thể lấy list_id từ phản hồi');
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('List saved successfully')),
      );

      // Chuyển sang NewListItemsPage với userId và listId
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => NewListItemsPage(
            authService: widget.authService,
            listName: _listNameController.text,
            selectedDate: _selectedDate!,
            userId: _userId,
            listId: 1,
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateText = _selectedDate == null
        ? 'Choose date'
        : DateFormat('EEE, dd/MM/yyyy').format(_selectedDate!);

    return Scaffold(
      appBar: AppBar(
        leading: TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('X', style: TextStyle(fontSize: 20)),
        ),
        title: const Text('Create new list', style: TextStyle(fontSize: 22)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('List name', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            TextField(
              controller: _listNameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                hintText: 'Enter list name...',
              ),
            ),
            const SizedBox(height: 24),
            const Text('Date', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _pickDate,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                width: double.infinity,
                child: Text(
                  dateText,
                  style: TextStyle(
                    fontSize: 16,
                    color: _selectedDate == null ? Colors.grey : Colors.black,
                  ),
                ),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : OutlinedButton(
                      onPressed: _navigateToItemsPage,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 14),
                        child: Text('Next', style: TextStyle(fontSize: 18)),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
