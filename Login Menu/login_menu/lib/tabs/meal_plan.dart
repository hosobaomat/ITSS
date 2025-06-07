import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:login_menu/data/data_store.dart';
import 'package:login_menu/models/getMealPlan.dart';
import 'package:login_menu/service/auth_service.dart';

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
  if (groupId != null && groupId != 0) {
    getMealPlan();
  } else {
    print("GroupID chưa sẵn sàng, không gọi API");
  }
  }

  Widget _buildMealPlanCard(MealPlanResponse mealPlan) {
    String formattedDate =
        DateFormat('dd/MM/yyyy').format(mealPlan.startDateTime);
    String username = creatorNames[mealPlan.createdBy] ?? 'Unknown';
    print('${DataStore().GroupID}');
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
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Meal Plans")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: mealplan.length,
              itemBuilder: (context, index) {
                return _buildMealPlanCard(mealplan[index]);
              },
            ),
    );
  }
}
