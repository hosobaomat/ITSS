import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:login_menu/models/fooditem.dart';

class StatisticTab extends StatelessWidget {
  const StatisticTab({super.key});

  List<_StatRow> _collectAllItems(List<FoodItem> inventory) {
    final now = DateTime.now();
    return inventory.map((item) {
      return _StatRow(
        name: item.name,
        quantity: item.quantity ?? 0,
        date: now,
        time: TimeOfDay.fromDateTime(now),
        category: item.category, // Lưu category nếu có
      );
    }).toList();
  }

  /// Phân tích xu hướng tiêu thụ thực phẩm (theo category)
  Map<String, int> _analyzeTrendsByCategory(List<FoodItem> inventory) {
    final Map<String, int> trendMap = {};
    for (var item in inventory) {
      final cat = item.category ?? 'Khác';
      trendMap[cat] = (trendMap[cat] ?? 0) + item.quantity.toInt();
    }
    return trendMap;
  }

  @override
  Widget build(BuildContext context) {
    final inventory = context.watch<FoodInventoryProvider>().items;
    final allRows = _collectAllItems(inventory);
    // Sửa lỗi: Định nghĩa lại _analyzeTrends cho xu hướng theo sản phẩm
    Map<String, int> _analyzeTrends(List<FoodItem> inventory) {
      final Map<String, int> trendMap = {};
      for (var item in inventory) {
        trendMap[item.name] =
            (trendMap[item.name] ?? 0) + item.quantity.toInt();
      }
      return trendMap;
    }

    final trends = _analyzeTrends(inventory);
    final trendsByCategory = _analyzeTrendsByCategory(inventory);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bảng Thống Kê Sản Phẩm Đã Mua'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: DataTable(
                      columnSpacing: 12,
                      headingRowColor:
                          MaterialStateProperty.all(Colors.blue.shade50),
                      headingTextStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                      columns: const [
                        DataColumn(label: Text('Tên thực phẩm')),
                        DataColumn(label: Text('SL')),
                        DataColumn(label: Text('Ngày')),
                        DataColumn(label: Text('Giờ')),
                      ],
                      rows: allRows.map((row) {
                        return DataRow(
                          cells: [
                            DataCell(Text(row.name)),
                            DataCell(Text('${row.quantity}')),
                            DataCell(Text(
                              '${row.date.day.toString().padLeft(2, '0')}/${row.date.month.toString().padLeft(2, '0')}/${row.date.year}',
                            )),
                            DataCell(Text(
                              '${row.time.hour.toString().padLeft(2, '0')}:${row.time.minute.toString().padLeft(2, '0')}',
                            )),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              if (trends.isNotEmpty)
                Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const Text(
                          'Xu hướng tiêu thụ theo sản phẩm',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.blue),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 200,
                          child: _TrendBarChart(trends: trends),
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 24),
              if (trendsByCategory.isNotEmpty)
                Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const Text(
                          'Xu hướng tiêu thụ theo nhóm (category)',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.deepPurple),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 200,
                          child: _TrendBarChart(trends: trendsByCategory),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// Widget biểu đồ cột đơn giản cho xu hướng tiêu thụ
class _TrendBarChart extends StatelessWidget {
  final Map<String, int> trends;
  const _TrendBarChart({required this.trends});

  @override
  Widget build(BuildContext context) {
    final maxVal = trends.values.isEmpty
        ? 1
        : trends.values.reduce((a, b) => a > b ? a : b);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: trends.entries.map((entry) {
        final barHeight = (entry.value / maxVal) * 120.0;
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              width: 24,
              height: barHeight,
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              entry.key,
              style: const TextStyle(fontSize: 12),
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              '${entry.value}',
              style: const TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ],
        );
      }).toList(),
    );
  }
}

class _StatRow {
  final String name;
  final int quantity;
  final DateTime date;
  final TimeOfDay time;
  final String? category; // Thêm category

  _StatRow({
    required this.name,
    required this.quantity,
    required this.date,
    required this.time,
    this.category,
  });
}
