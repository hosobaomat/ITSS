import 'package:login_menu/models/foodCatalogResponse.dart';
import 'package:login_menu/models/foodCategoryResponse.dart';
import 'package:login_menu/models/getGroupMember.dart';
import 'package:login_menu/models/getMealPlan.dart';
import 'package:login_menu/models/recipesResponse.dart';
import 'package:login_menu/models/unitResponse.dart';
import 'package:login_menu/service/auth_service.dart';

class Recipe {
  String name;
  List<String> ingredients;
  String instruction;

  Recipe(
      {required this.name,
      required this.ingredients,
      required this.instruction});
}

class DataStore {
  //
  // Singleton pattern
  static final DataStore _instance = DataStore._internal();
  factory DataStore() => _instance;
  DataStore._internal();
  // Các biến lưu trữ dữ liệu dùng chung
  List<FoodCategoryResponse> categories = [];
  List<FoodCatalogResponse> foodCatalogs = [];
  List<UnitResponse> units = [];
  late int? userId; // ID của người dùng hiện tại
  List<Recipesresponse> recipesresponse = [];
  List<Recipesresponse> recipesSuggest = [];
  late AuthService authService;
  late int GroupID = 0;
  late int UserID = 0;
  List<MealPlanResponse> mealPlanResponse = [];
  late String username = '';
  late String email = '';
  late String url = 'http://192.168.100.19:8082/ITSS_BE';
  late int userCreateID = 0;
  late int groupcreatID = 0;
  late String tokenSignup = '';
  // Hàm clear nếu cần reset
  void clearAll() {
    categories = [];
    foodCatalogs = [];
    units = [];
    recipesresponse = [];
    mealPlanResponse = [];
    recipesSuggest = [];
  }

  //
  static final Map<String, List<String>> itemsByCategory = {
    'Vegetables': ['Carrot', 'Broccoli', 'Lettuce', 'Spinach'],
    'Fruits': ['Apple', 'Banana', 'Orange', 'Grape'],
    'Beverages': ['Water', 'Juice', 'Soda', 'Milk'],
    'Snacks': ['Chips', 'Cookies', 'Popcorn', 'Candy'],
  };

  static final List<Recipe> recipes = [
    Recipe(
        name: 'Phở bò',
        ingredients: ['Thịt bò', 'Bánh phở', 'Hành', 'Gừng', 'Nước dùng'],
        instruction: 'https://hocmonviet.edu.vn/khoa-hoc-nau-pho-bo/'),
    Recipe(
        name: 'Cơm rang',
        ingredients: ['Cơm nguội', 'Trứng', 'Hành lá', 'Dầu ăn'],
        instruction:
            'Bước 1: Chuẩn bị nguyên liệu.\nBước 2: Nấu theo cách bạn muốn.'),
    // 🌶️ Xào
    Recipe(
        name: 'Rau muống xào tỏi',
        ingredients: ['Rau muống', 'Tỏi', 'Dầu ăn', 'Muối'],
        instruction:
            'Bước 1: Chuẩn bị nguyên liệu.\nBước 2: Nấu theo cách bạn muốn.'),
    // 🍖 Nướng
    Recipe(
        name: 'Gà nướng mật ong',
        ingredients: ['Đùi gà', 'Mật ong', 'Tỏi', 'Nước mắm', 'Tiêu'],
        instruction:
            'Bước 1: Chuẩn bị nguyên liệu.\nBước 2: Nấu theo cách bạn muốn.'),
    // 🥩 Áp chảo (Bít tết)
    Recipe(
        name: 'Bít tết bò',
        ingredients: ['Thịt bò', 'Muối', 'Tiêu', 'Bơ', 'Tỏi'],
        instruction:
            'Bước 1: Chuẩn bị nguyên liệu.\nBước 2: Nấu theo cách bạn muốn.'),
    // 🥣 Luộc
    Recipe(
        name: 'Trứng luộc',
        ingredients: ['Trứng', 'Nước', 'Muối'],
        instruction:
            'Bước 1: Chuẩn bị nguyên liệu.\nBước 2: Nấu theo cách bạn muốn.'),
  ];
}
