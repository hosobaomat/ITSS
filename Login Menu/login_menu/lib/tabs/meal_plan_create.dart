import 'package:flutter/material.dart';
import 'package:login_menu/data/data_store.dart';
import 'package:login_menu/models/createMealPlan.dart';
import 'package:login_menu/models/recipesResponse.dart'; // Sử dụng Recipesresponse
import 'package:login_menu/models/mealPlan.dart';
import 'package:provider/provider.dart';
import '../pages/RecipeListPage.dart';

class MealPlanScreen extends StatefulWidget {
  final List<Recipesresponse> recipes; // Chỉ cần recipes, không cần inventory

  const MealPlanScreen({
    super.key,
    required this.recipes,
  });

  @override
  _MealPlanScreenState createState() => _MealPlanScreenState();
}

class _MealPlanScreenState extends State<MealPlanScreen> {
  late TextEditingController _planNameController;
  final createmealplan = Createmealplan(
    createdBy: DataStore().UserID,
    planName: '',
    startDate: DateTime.now(),
    endDate: DateTime.now(),
    groupId: DataStore().GroupID,
    details: [],
  );
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
  void dispose() {
    _planNameController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // Khôi phục _selectedDates từ MealPlanProvider
    final mealPlanProvider =
        Provider.of<MealPlanProvider>(context, listen: false);
    _selectedDates = mealPlanProvider.dailyPlans.keys.toSet();
    final today =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    _planNameController = TextEditingController(text: createmealplan.planName);
    if (!_selectedDates.contains(today)) {
      _selectedDates.add(today);
      mealPlanProvider.initializeMealPlanForDate(today);
    }
  }

  void _handleDone(MealPlan mealPlan) {
    createmealplan.startDate = mealPlan.date;
    createmealplan.endDate = mealPlan.date;
    final meals = mealPlan.meals;
    meals.forEach((mealType, recipe) {
      for (var item in recipe) {
        createmealplan.details.add(CreateMealPlanDetail(
            recipeId: item.id, mealDate: mealPlan.date, mealType: mealType));
      }
    });
    createMealPlan();
  }

  Future<void> createMealPlan() async {
    try {
      bool result = await DataStore().authService.addMealPlan(createmealplan);
      if (result == true) {
        print("thanh cong");
      } else {
        print("that bai");
      }
    } catch (e) {
      print("loi : $e");
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

  void _assignMeal(DateTime date, String mealType) async {
    if (widget.recipes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không có công thức nào khả thi!')),
      );
      return;
    }

    final selectedRecipes = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RecipeListPage(
          authService: DataStore().authService,
          isSelectionMode: true,
        ),
      ),
    );

    if (selectedRecipes != null && selectedRecipes.isNotEmpty) {
      print(
          'Selected Recipes: ${selectedRecipes.map((r) => r.recipeName).toList()}');
      final mealPlanProvider =
          Provider.of<MealPlanProvider>(context, listen: false);
      final typeMapping = {
        'Bữa sáng': 'breakfast',
        'Bữa trưa': 'lunch',
        'Bữa tối': 'dinner',
      };
      final normalizedType = typeMapping[mealType] ?? mealType.toLowerCase();
      for (var recipe in selectedRecipes) {
        mealPlanProvider.addMealPlan(date, normalizedType, recipe);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Đã thêm ${recipe.recipeName} vào $mealType')),
        );
      }
    }
    setState(() {});
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
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: TextField(
              controller: _planNameController,
              decoration: InputDecoration(
                labelText: 'Tên thực đơn',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  createmealplan.planName = value;
                });
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${_weekdayNames[mealPlan.date.weekday - 1]}, '
                '${mealPlan.date.day.toString().padLeft(2, '0')}/${mealPlan.date.month.toString().padLeft(2, '0')}',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      _handleDone(mealPlan);
                    },
                    icon: const Icon(Icons.done, color: Colors.blue),
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
              )
            ],
          ),
          const SizedBox(height: 12),
          _buildMealSection(
              'Bữa sáng', mealPlan.meals['breakfast'] ?? [], mealPlan.date),
          _buildMealSection(
              'Bữa trưa', mealPlan.meals['lunch'] ?? [], mealPlan.date),
          _buildMealSection(
              'Bữa tối', mealPlan.meals['dinner'] ?? [], mealPlan.date),
        ],
      ),
    );
  }

  Widget _buildMealSection(
      String mealType, List<Recipesresponse> recipes, DateTime date) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ExpansionTile(
        title: Text(mealType),
        subtitle: Text('(${recipes.length} món)'),
        trailing: IconButton(
          icon: const Icon(Icons.add),
          onPressed: () =>
              _assignMeal(date, mealType), // Mở RecipeListPage khi nhấn add
        ),
        children: [
          if (recipes.isEmpty)
            const ListTile(title: Text('Chưa có món ăn nào.')),
          for (var recipe in recipes)
            ListTile(
              title: Text(recipe.recipeName),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      final typeMapping = {
                        'Bữa sáng': 'breakfast',
                        'Bữa trưa': 'lunch',
                        'Bữa tối': 'dinner',
                      };
                      final normalizedType =
                          typeMapping[mealType] ?? mealType.toLowerCase();
                      Provider.of<MealPlanProvider>(context, listen: false)
                          .removeMealPlan(date, normalizedType, recipe);
                      setState(() {});
                    },
                  ),
                ],
              ),
            ),
        ],
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
        print(
            'Meal Plans: ${mealPlans.map((plan) => "${plan.date}: ${plan.meals}").toList()}'); // Debug log
        return WillPopScope(
            onWillPop: () async {
              Navigator.pop(context, 'refresh'); // Gửi result khi back
              return false; // Ngăn mặc định pop nữa
            },
            child: Scaffold(
              appBar: AppBar(
                title: const Text('Lập thực đơn theo ngày'),
                backgroundColor: Colors.green,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: _selectDate,
                  ),
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: () {
                      setState(() {}); // Làm mới giao diện
                    },
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
                            ...mealPlans.map(
                                (mealPlan) => _buildMealPlanCard(mealPlan)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ));
      },
    );
  }
}
