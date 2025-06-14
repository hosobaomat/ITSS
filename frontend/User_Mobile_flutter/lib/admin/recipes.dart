import 'package:flutter/material.dart';
import '../data/data_store.dart';

class RecipeManagerScreen extends StatefulWidget {
  @override
  _RecipeManagerScreenState createState() => _RecipeManagerScreenState();
}

class _RecipeManagerScreenState extends State<RecipeManagerScreen> {
  List<Recipe> recipes = DataStore.recipes;

  void _editIngredients(Recipe recipe) {
    List<String> tempIngredients = List.from(recipe.ingredients);
    TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (_, setStateDialog) => AlertDialog(
          title: Text('Sửa nguyên liệu - ${recipe.name}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ...tempIngredients.asMap().entries.map((entry) {
                int index = entry.key;
                String value = entry.value;
                return Row(
                  children: [
                    Expanded(child: Text(value)),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        setStateDialog(() {
                          tempIngredients.removeAt(index);
                        });
                      },
                    ),
                  ],
                );
              }),
              TextField(
                controller: controller,
                decoration: InputDecoration(labelText: 'Thêm nguyên liệu'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (controller.text.trim().isNotEmpty) {
                    setStateDialog(() {
                      tempIngredients.add(controller.text.trim());
                      controller.clear();
                    });
                  }
                },
                child: Text('Thêm'),
              )
            ],
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context), child: Text('Huỷ')),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  recipe.ingredients = tempIngredients;
                });
                Navigator.pop(context);
              },
              child: Text('Lưu'),
            ),
          ],
        ),
      ),
    );
  }

  void _showIngredients(Recipe recipe) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Chi tiết - ${recipe.name}'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Nguyên liệu:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              ...recipe.ingredients.map((e) => Text('• $e')).toList(),
              SizedBox(height: 16),
              Text('Hướng dẫn chế biến:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text(
                recipe.instruction.isNotEmpty
                    ? recipe.instruction
                    : 'Chưa có hướng dẫn chế biến',
                textAlign: TextAlign.justify,
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _editIngredients(recipe);
            },
            child: Text('Sửa nguyên liệu'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _editInstructions(recipe);
            },
            child: Text('Sửa hướng dẫn'),
          ),
          TextButton(
              onPressed: () => Navigator.pop(context), child: Text('Đóng')),
        ],
      ),
    );
  }

  void _addRecipe() {
    String name = '';
    List<String> ingredients = [];
    String instruction = '';
    TextEditingController ingredientController = TextEditingController();
    TextEditingController instructionController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (_, setStateDialog) => AlertDialog(
          title: Text('Thêm công thức'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: InputDecoration(labelText: 'Tên món ăn'),
                  onChanged: (val) => name = val,
                ),
                TextField(
                  controller: ingredientController,
                  decoration: InputDecoration(labelText: 'Nguyên liệu'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (ingredientController.text.trim().isNotEmpty) {
                      setStateDialog(() {
                        ingredients.add(ingredientController.text.trim());
                        ingredientController.clear();
                      });
                    }
                  },
                  child: Text('Thêm nguyên liệu'),
                ),
                ...ingredients.map((e) => Text('• $e')).toList(),
                SizedBox(height: 16),
                TextField(
                  controller: instructionController,
                  decoration: InputDecoration(labelText: 'Hướng dẫn chế biến'),
                  maxLines: 5,
                  onChanged: (val) => instruction = val,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context), child: Text('Hủy')),
            ElevatedButton(
              onPressed: () {
                if (name.trim().isNotEmpty &&
                    ingredients.isNotEmpty &&
                    instructionController.text.trim().isNotEmpty) {
                  setState(() {
                    recipes.add(Recipe(
                      name: name.trim(),
                      ingredients: ingredients,
                      instruction: instructionController.text.trim(),
                    ));
                  });
                  Navigator.pop(context);
                }
              },
              child: Text('Lưu'),
            ),
          ],
        ),
      ),
    );
  }

  void _editInstructions(Recipe recipe) {
    TextEditingController controller =
        TextEditingController(text: recipe.instruction ?? '');

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Sửa hướng dẫn chế biến - ${recipe.name}'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(labelText: 'Hướng dẫn chế biến'),
          maxLines: 5,
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context), child: Text('Hủy')),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                setState(() {
                  recipe.instruction = controller.text.trim();
                });
                Navigator.pop(context);
              }
            },
            child: Text('Lưu'),
          ),
        ],
      ),
    );
  }

  void _deleteRecipe(int index) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Xác nhận xoá'),
        content:
            Text('Bạn có muốn xoá công thức "${recipes[index].name}" không?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context), child: Text('Huỷ')),
          ElevatedButton(
            onPressed: () {
              setState(() {
                recipes.removeAt(index);
              });
              Navigator.pop(context);
            },
            child: Text('Xoá'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Recipes'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addRecipe,
        child: Icon(Icons.add),
        tooltip: 'Thêm công thức',
      ),
      body: ListView.builder(
        itemCount: recipes.length,
        itemBuilder: (_, index) {
          final recipe = recipes[index];
          return ListTile(
            title: Text(recipe.name),
            leading: Icon(Icons.restaurant_menu),
            onTap: () => _showIngredients(recipe),
            trailing: IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () => _deleteRecipe(index),
            ),
          );
        },
      ),
    );
  }
}
