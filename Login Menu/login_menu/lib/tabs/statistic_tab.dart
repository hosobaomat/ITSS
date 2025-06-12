import 'package:flutter/material.dart';
import 'package:login_menu/data/data_store.dart';
import 'package:login_menu/models/ItemsForStatistics.dart';
import 'package:login_menu/models/consumptionTrend.dart';
import 'package:login_menu/service/auth_service.dart';

class StatisticTab extends StatefulWidget {
  const StatisticTab({super.key});

  @override
  _StatisticTabState createState() => _StatisticTabState();
}

class _StatisticTabState extends State<StatisticTab> {
  // Sử dụng PageController để điều hướng các bảng
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Các nút mũi tên bên trái và bên phải
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    if (_pageController.page! > 0) {
                      _pageController.previousPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.ease,
                      );
                    }
                  },
                ),
                Expanded(
                  child: Text(
                    'Thống kê gia đình',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.arrow_forward),
                  onPressed: () {
                    if (_pageController.page! < 2) {
                      _pageController.nextPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.ease,
                      );
                    }
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              children: [
                // Bảng Sản phẩm đã mua
                _buildUsedItemsTable(),
                // Bảng Sản phẩm đã lãng phí
                _buildWastedItemsTable(),
                // Bảng Xu hướng tiêu thụ
                _buildConsumptionTrendTable(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Bảng "Sản phẩm đã mua"
  Widget _buildUsedItemsTable() {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Text(
            'Sản phẩm đã sử dụng', // Tiêu đề cho bảng "Sản phẩm đã mua"
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
        ),
        FutureBuilder<List<ItemModel>>(
          future: AuthService().getUsedItems(DataStore().GroupID),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('Không có dữ liệu'));
            } else {
              final usedItems = snapshot.data!;
              return Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: DataTable(
                    columnSpacing: 12,
                    headingRowColor:
                        MaterialStateProperty.all(Colors.blue.shade50),
                    headingTextStyle: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.blue),
                    columns: const [
                      DataColumn(label: Text('Tên thực phẩm')),
                      DataColumn(label: Text('SL')),
                      DataColumn(label: Text('Ngày')),
                      DataColumn(label: Text('Giờ')),
                    ],
                    rows: usedItems.map((item) {
                      return DataRow(
                        cells: [
                          DataCell(Text(item.foodname)),
                          DataCell(Text('${item.quantity}')),
                          DataCell(Text(
                              '${item.actionDate.day.toString().padLeft(2, '0')}/${item.actionDate.month.toString().padLeft(2, '0')}/${item.actionDate.year}')),
                          DataCell(Text(
                              '${item.actionDate.hour.toString().padLeft(2, '0')}:${item.actionDate.minute.toString().padLeft(2, '0')}')),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              );
            }
          },
        ),
      ],
    );
  }

  // Bảng "Sản phẩm đã lãng phí"
  Widget _buildWastedItemsTable() {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Text(
            'Sản phẩm đã lãng phí', // Tiêu đề cho bảng "Sản phẩm đã lãng phí"
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple,
            ),
          ),
        ),
        FutureBuilder<List<ItemModel>>(
          future: AuthService().getWastedItems(DataStore().GroupID),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('Không có dữ liệu'));
            } else {
              final wastedItems = snapshot.data!;
              return Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: DataTable(
                    columnSpacing: 12,
                    headingRowColor:
                        MaterialStateProperty.all(Colors.deepPurple.shade50),
                    headingTextStyle: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.deepPurple),
                    columns: const [
                      DataColumn(label: Text('Thực phẩm')),
                      DataColumn(label: Text('SL')),
                      DataColumn(label: Text('Ngày')),
                      DataColumn(label: Text('Giờ')),
                    ],
                    rows: wastedItems.map((item) {
                      return DataRow(
                        cells: [
                          DataCell(Text(item.foodname)),
                          DataCell(Text('${item.quantity}')),
                          DataCell(Text(
                              '${item.actionDate.day.toString().padLeft(2, '0')}/${item.actionDate.month.toString().padLeft(2, '0')}/${item.actionDate.year}')),
                          DataCell(Text(
                              '${item.actionDate.hour.toString().padLeft(2, '0')}:${item.actionDate.minute.toString().padLeft(2, '0')}')),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              );
            }
          },
        ),
      ],
    );
  }

  // Bảng "Xu hướng tiêu thụ của gia đình"
  Widget _buildConsumptionTrendTable() {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Text(
            'Xu hướng tiêu thụ của gia đình', // Tiêu đề cho bảng "Xu hướng tiêu thụ của gia đình"
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
        ),
        FutureBuilder<List<ConsumptionTrend>>(
          future: AuthService().getConsumptionTrend(DataStore().GroupID),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('Không có dữ liệu'));
            } else {
              final consumptionData = snapshot.data!;
              return Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: DataTable(
                    columnSpacing: 12,
                    headingRowColor:
                        MaterialStateProperty.all(Colors.green.shade50),
                    headingTextStyle: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.green),
                    columns: const [
                      DataColumn(label: Text('Tên thực phẩm')),
                      DataColumn(label: Text('Tỷ lệ tiêu thụ')),
                    ],
                    rows: consumptionData.map((item) {
                      return DataRow(
                        cells: [
                          DataCell(Text(item.categoryName)),
                          DataCell(Text('${item.consumptionPercentage}')),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              );
            }
          },
        ),
      ],
    );
  }
}
