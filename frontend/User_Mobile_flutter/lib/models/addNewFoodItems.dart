import 'package:login_menu/models/foodItemsResponse.dart';

class AddNewFoodItemsRequest {
  final int userId;
  final int groupId;
  final List<FoodItemResponse> foodItems;

  AddNewFoodItemsRequest({
    required this.userId,
    required this.groupId,
    required this.foodItems,
  });

  // Chuyển đổi sang JSON để gửi API
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'groupId': groupId,
      'foodItems': foodItems.map((item) => item.toJson()).toList(),
    };
  }
}
