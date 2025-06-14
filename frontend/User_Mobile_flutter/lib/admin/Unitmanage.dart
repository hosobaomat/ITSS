import 'package:flutter/material.dart';

class UnitManagementScreen extends StatefulWidget {
  @override
  State<UnitManagementScreen> createState() => _UnitManagementScreenState();
}

class _UnitManagementScreenState extends State<UnitManagementScreen> {
  List<String> units = ['kg', 'gram', 'lit', 'muỗng', 'chén'];

  final TextEditingController _unitController = TextEditingController();

  void _addUnit() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Thêm đơn vị tính'),
        content: TextField(
          controller: _unitController,
          decoration: InputDecoration(labelText: 'Tên đơn vị'),
        ),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
                _unitController.clear();
              },
              child: Text('Huỷ')),
          ElevatedButton(
              onPressed: () {
                setState(() {
                  units.add(_unitController.text);
                });
                _unitController.clear();
                Navigator.pop(context);
              },
              child: Text('Thêm')),
        ],
      ),
    );
  }

  void _deleteUnit(int index) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Xác nhận xoá'),
        content: Text('Bạn có chắc chắn muốn xoá đơn vị này không?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context), child: Text('Huỷ')),
          ElevatedButton(
              onPressed: () {
                setState(() {
                  units.removeAt(index);
                });
                Navigator.pop(context);
              },
              child: Text('Xoá')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text('Units')),
      body: ListView.builder(
        itemCount: units.length,
        itemBuilder: (context, index) {
          final unit = units[index];
          return ListTile(
            title: Text(unit),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              color: Colors.red,
              onPressed: () => _deleteUnit(index),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addUnit,
        child: Icon(Icons.add),
      ),
    );
  }
}
