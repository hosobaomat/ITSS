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
