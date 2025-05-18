class Recipe {
  final String name;
  final List<String> ingredients; // Danh sách tên nguyên liệu cần thiết
  final String tag; // Ví dụ: 'Popular', 'Saved'

  Recipe({required this.name, required this.ingredients, required this.tag});
}