import 'package:flutter/material.dart';
import 'package:login_menu/data/data_store.dart';
import 'package:login_menu/models/recipesResponse.dart';
import 'package:login_menu/service/auth_service.dart';

class RecipeListPage extends StatefulWidget {
  const RecipeListPage(
      {super.key, required this.authService, this.isSelectionMode = false});
  final AuthService authService;
  final bool isSelectionMode; // Chế độ chọn

  @override
  State<RecipeListPage> createState() => _RecipeListPageState();
}

class _RecipeListPageState extends State<RecipeListPage> {
  late Future<List<Recipesresponse>> _recipeFuture;
  late Set<int> _selectedRecipeIds;
  List<Recipesresponse> _recipeSuggest = [];
  bool _onTap = false; // false: tất cả, true: gợi ý

  @override
  void initState() {
    super.initState();
    _selectedRecipeIds = {};
    _loadRecipes();
  }

  void _loadRecipes() {
    _recipeFuture = DataStore().recipesresponse.isNotEmpty
        ? Future.value(DataStore().recipesresponse)
        : widget.authService.fetchRecipesByUser().then((recipes) {
            DataStore().recipesresponse = recipes;
            return recipes;
          });

    // Load gợi ý nếu đã có
    if (DataStore().recipesSuggest.isNotEmpty) {
      _recipeSuggest = DataStore().recipesSuggest;
    } else {
      // Giả lập delay nếu cần chờ
      Future.delayed(const Duration(seconds: 10), () {
        setState(() {
          _recipeSuggest = DataStore().recipesSuggest;
        });
      });
    }
  }

  void onTap() {
    setState(() {
      _onTap = !_onTap;
    });
  }

  void _toggleRecipeSelection(int id, bool selected) {
    setState(() {
      if (selected) {
        _selectedRecipeIds.add(id);
      } else {
        _selectedRecipeIds.remove(id);
      }
    });
  }

  void _confirmSelection() {
    final selectedRecipes = (_onTap ? _recipeSuggest : DataStore().recipesresponse)
        .where((recipe) => _selectedRecipeIds.contains(recipe.id))
        .toList();
    Navigator.pop(context, selectedRecipes);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách công thức'),
        actions: [
          IconButton(
            onPressed: onTap,
            icon: const Icon(Icons.lightbulb_outline),
            tooltip: 'Gợi ý',
          ),
          if (widget.isSelectionMode)
            IconButton(
              icon: const Icon(Icons.check),
              onPressed:
                  _selectedRecipeIds.isNotEmpty ? _confirmSelection : null,
              tooltip: 'Xác nhận chọn',
            ),
        ],
      ),
      body: _onTap
          ? _buildRecipeList(_recipeSuggest)
          : FutureBuilder<List<Recipesresponse>>(
              future: _recipeFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Lỗi: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('Không có công thức nào.'));
                } else {
                  return _buildRecipeList(snapshot.data!);
                }
              },
            ),
    );
  }

  Widget _buildRecipeList(List<Recipesresponse> recipes) {
    return ListView.builder(
      itemCount: recipes.length,
      itemBuilder: (context, index) {
        final recipe = recipes[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          elevation: 3,
          child: CheckboxListTile(
            title: Text(recipe.recipeName),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(recipe.description, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text('Tác giả: ${recipe.createdBy}', style: const TextStyle(fontWeight: FontWeight.bold)),
                const Text('Hướng dẫn:', style: TextStyle(fontWeight: FontWeight.bold)),
                Text(recipe.instructions),
                const Text('Nguyên liệu:', style: TextStyle(fontWeight: FontWeight.bold)),
                ...recipe.ingredients.map((ingredient) => Text(
                      '- ${ingredient.foodName}: ${ingredient.quantity} ${ingredient.unitName}',
                      style: const TextStyle(fontSize: 13),
                    )),
              ],
            ),
            value: _selectedRecipeIds.contains(recipe.id),
            onChanged: widget.isSelectionMode
                ? (bool? value) {
                    _toggleRecipeSelection(recipe.id, value ?? false);
                  }
                : null,
            secondary: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Chuẩn bị: ${recipe.prepTime} phút'),
                Text('Nấu: ${recipe.cookTime} phút'),
              ],
            ),
            controlAffinity: ListTileControlAffinity.leading,
          ),
        );
      },
    );
  }
}

