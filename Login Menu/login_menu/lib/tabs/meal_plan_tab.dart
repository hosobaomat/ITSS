import 'package:flutter/material.dart';
import 'package:login_menu/models/fooditem.dart';
import 'package:login_menu/models/recipes.dart';
import 'package:login_menu/models/mealPlan.dart';

import 'package:provider/provider.dart';

class MealPlanScreen extends StatefulWidget {
  final List<FoodItem> inventory;
  final List<Recipe> recipes;

  const MealPlanScreen(
      {super.key, required this.inventory, required this.recipes});

  @override
  _MealPlanScreenState createState() => _MealPlanScreenState();
}

class _MealPlanScreenState extends State<MealPlanScreen> {
  Set<DateTime> _selectedDates = {
    DateTime.now()
  }; // Lưu tất cả các ngày đã chọn
  final List<String> _weekdayNames = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];
  @override
  void initState() {
    super.initState();
    // Khôi phục _selectedDates từ MealPlanProvider
    final mealPlanProvider =
        Provider.of<MealPlanProvider>(context, listen: false);
    _selectedDates = mealPlanProvider.dailyPlans.keys.toSet();
    final today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    if (!_selectedDates.contains(today)) {
      _selectedDates.add(today);
      mealPlanProvider.initializeMealPlanForDate(today);
    }
  }

  void _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      final normalizedDate = DateTime(picked.year, picked.month, picked.day);
      setState(() {
        if (_selectedDates.contains(normalizedDate)) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Trùng ngày'),
              content: const Text('Ngày này đã có danh sách rồi.'),
            ),
          );
        } else {
          _selectedDates.add(normalizedDate);
          Provider.of<MealPlanProvider>(context, listen: false)
              .initializeMealPlanForDate(normalizedDate);
        }
      });
    }
  }

  void _assignMeal(DateTime date, String mealType) {
    if (widget.inventory.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Kho thực phẩm trống! Vui lòng thêm nguyên liệu.')),
      );
      return;
    }

    if (widget.recipes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không có công thức nào khả thi!')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
            'Chọn công thức cho $mealType - ${date.toString().split(' ')[0]}'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: widget.recipes.map((recipe) {
              final isAvailable =
                  Provider.of<MealPlanProvider>(context, listen: false)
                      .checkIngredients(recipe, widget.inventory);
              final missingIngredients = recipe.ingredients
                  .where((ingredient) => !widget.inventory.any((item) =>
                      item.name.trim().toLowerCase() ==
                          ingredient.trim().toLowerCase() &&
                      item.quantity! > 0))
                  .join(', ');
              return ListTile(
                title: Text(recipe.name),
                subtitle:
                    Text(isAvailable ? 'Có sẵn' : 'Thiếu: $missingIngredients'),
                onTap: isAvailable
                    ? () {
                        Provider.of<MealPlanProvider>(context, listen: false)
                            .addMealPlan(date, mealType.toLowerCase(), recipe);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content:
                                  Text('Đã thêm ${recipe.name} vào $mealType')),
                        );
                        Navigator.pop(context);
                      }
                    : null,
              );
            }).toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Đóng'),
          ),
        ],
      ),
    );
  }

  Widget _buildMealPlanCard(MealPlan mealPlan) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black54),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${_weekdayNames[mealPlan.date.weekday - 1]}, '
                '${mealPlan.date.day.toString().padLeft(2, '0')}/${mealPlan.date.month.toString().padLeft(2, '0')}',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              IconButton(
                onPressed: () {
                  Provider.of<MealPlanProvider>(context, listen: false)
                      .removeMealPlanForDate(mealPlan.date);
                  setState(() {
                    _selectedDates.remove(mealPlan.date);
                  });
                },
                icon: const Icon(Icons.delete_outline, color: Colors.red),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildMealSection(
              'Bữa sáng', mealPlan.meals['bữa sáng'], mealPlan.date),
          _buildMealSection(
              'Bữa trưa', mealPlan.meals['bữa trưa'], mealPlan.date),
          _buildMealSection(
              'Bữa tối', mealPlan.meals['bữa tối'], mealPlan.date),
        ],
      ),
    );
  }

  Widget _buildMealSection(String mealType, Recipe? recipe, DateTime date) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        title: Text(mealType),
        subtitle: Text(recipe?.name ?? 'Chưa chọn'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => _assignMeal(date, mealType),
            ),
            if (recipe != null)
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  Provider.of<MealPlanProvider>(context, listen: false)
                      .removeMealPlan(date, mealType.toLowerCase());
                },
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MealPlanProvider>(
      builder: (context, mealPlanProvider, child) {
        // Đảm bảo tất cả các ngày trong _selectedDates đều có thực đơn
        for (var date in _selectedDates) {
          if (!mealPlanProvider.dailyPlans.containsKey(date)) {
            mealPlanProvider.initializeMealPlanForDate(date);
          }
        }

        final mealPlans = mealPlanProvider.dailyPlans.entries
            .where((entry) => _selectedDates.contains(entry.key))
            .map((entry) => entry.value)
            .toList()
          ..sort((a, b) => a.date.compareTo(b.date)); // Sắp xếp theo ngày

        return Scaffold(
          appBar: AppBar(
            title: const Text('Lập thực đơn theo ngày'),
            backgroundColor: Colors.green,
            actions: [
              IconButton(
                icon: const Icon(Icons.calendar_today),
                onPressed: _selectDate,
              ),
            ],
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(Icons.restaurant_menu, size: 30),
                      const Text(
                        'Meal Plans',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 30),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: ListView(
                      children: [
                        ...mealPlans
                            .map((mealPlan) => _buildMealPlanCard(mealPlan)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
