import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:login_menu/data/data_store.dart';
import 'package:login_menu/models/getMealPlan.dart';
import 'package:login_menu/service/auth_service.dart';
import 'package:login_menu/tabs/meal_plan_create.dart';

class MealPlanScreenGet extends StatefulWidget {
  final AuthService authService;
  const MealPlanScreenGet({super.key, required this.authService});

  @override
  State<MealPlanScreenGet> createState() => _MealPlanScreenGetState();
}

class _MealPlanScreenGetState extends State<MealPlanScreenGet> {
  List<MealPlanResponse> mealplan = [];
  Map<int, String> creatorNames = {};
  bool isLoading = true;

  Future<void> getMealPlan() async {
    try {
      await Future.delayed(Duration(seconds: 3));
      final fetchedMealPlans =
          await widget.authService.fetchMealPlansByGroupId(DataStore().GroupID);

      // Lấy tất cả createdBy duy nhất
      final creatorIds = fetchedMealPlans.map((e) => e.createdBy).toSet();

      // Gọi API lấy tên từng người tạo
      final Map<int, String> names = {};
      for (var id in creatorIds) {
        final name = await widget.authService.getUserbyId(id);
        names[id] = name;
      }

      setState(() {
        mealplan = fetchedMealPlans;
        creatorNames = names;
        isLoading = false;
      });
    } catch (e) {
      print('error loading data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    final groupId = DataStore().GroupID;
    if (groupId != 0) {
      getMealPlan();
    } else {
      waitForGroupIdAndFetch();
    }
  }

  Future<void> waitForGroupIdAndFetch() async {
    while (DataStore().GroupID == 0) {
      await Future.delayed(const Duration(milliseconds: 300));
    }
    getMealPlan();
  }

  Widget _buildDetailCard(List<PlanDetail> plandetail) {
    Map<String, List<PlanDetail>> groupedDetails = {
      'Bữa sáng': [],
      'Bữa trưa': [],
      'Bữa tối': [],
    };
    for (var detail in plandetail) {
      switch (detail.mealType.toLowerCase()) {
        case 'breakfast':
          groupedDetails['Bữa sáng']!.add(detail);
          break;
        case 'lunch':
          groupedDetails['Bữa trưa']!.add(detail);
          break;
        case 'dinner':
          groupedDetails['Bữa tối']!.add(detail);
          break;
      }
    }

    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: groupedDetails.entries.map((entry) {
          final mealType = entry.key;
          final meals = entry.value;

          return Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$mealType\n(${meals.length} món)',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                if (meals.isEmpty)
                  const Text('(Không có món nào)')
                else
                  ...meals.map((m) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text(m.recipeName),
                      )),
              ],
            ),
          );
        }).toList());
  }

  Widget _buildMealPlanCard(MealPlanResponse mealPlan) {
    String formattedDate =
        DateFormat('dd/MM/yyyy').format(mealPlan.startDateTime);
    String username = creatorNames[mealPlan.createdBy] ?? 'Unknown';
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black54),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(
              mealPlan.planName,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'Create by: $username',
              style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
            )
          ]),
          const SizedBox(height: 8),
          Text(
            'Ngày bắt đầu: $formattedDate',
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
          const SizedBox(height: 12),
          const Text(
            'Chi tiết bữa ăn:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          _buildDetailCard(mealPlan.details),
        ],
      ),
    );
  }

  Future<void> _deleteMealPlan(int planId) async {
    try {
      await DataStore().authService.deleteMealPlanbyId(planId);
      print('thanh cong');
    } catch (e) {
      print("loi: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Meal Plans"),
        actions: [
          IconButton(
              onPressed: () async {
                final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MealPlanScreen(
                              recipes: DataStore().recipesresponse,
                            )));
                if (result == 'refresh') {
                  getMealPlan();
                }
              },
              icon: const Icon(Icons.add_circle_outline, size: 30))
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: mealplan.length,
              itemBuilder: (context, index) {
                final mealPlan = mealplan[index];
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Dismissible(
                      key: Key(mealPlan.planId.toString()),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (direction) {
                        setState(() {
                          mealplan.removeAt(index);
                          _deleteMealPlan(mealPlan.planId);
                        });
                      },
                      child: _buildMealPlanCard(
                          mealPlan), // Sử dụng lại hàm hiện có
                    ),
                  ),
                );
              },
            ),
    );
  }
}
