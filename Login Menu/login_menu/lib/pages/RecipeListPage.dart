import 'package:flutter/material.dart';
import 'package:login_menu/data/data_store.dart';
import 'package:login_menu/models/recipesResponse.dart';
import 'package:login_menu/service/auth_service.dart';

class RecipeListPage extends StatefulWidget {
  const RecipeListPage({Key? key, required this.authService, this.isSelectionMode = false})
      : super(key: key);
  final AuthService authService;
  final bool isSelectionMode; // Chế độ chọn

  @override
  State<RecipeListPage> createState() => _RecipeListPageState();
}

class _RecipeListPageState extends State<RecipeListPage> {
  late Future<List<Recipesresponse>> _recipeFuture;
  late Set<int> _selectedRecipeIds; // Theo dõi các recipe đã chọn bằng ID

  @override
  void initState() {
    super.initState();
    _selectedRecipeIds = {};
    if (DataStore().recipesresponse.isNotEmpty) {
      _recipeFuture = Future.value(DataStore().recipesresponse);
    } else {
      _recipeFuture = widget.authService.fetchRecipesByUser().then((recipes) {
        DataStore().recipesresponse = recipes;
        return recipes;
      });
    }
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
    final selectedRecipes = DataStore().recipesresponse
        .where((recipe) => _selectedRecipeIds.contains(recipe.id))
        .toList();
    Navigator.pop(context, selectedRecipes); // Trả về danh sách recipe đã chọn
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách công thức'),
        actions: [
          if (widget.isSelectionMode)
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: _selectedRecipeIds.isNotEmpty ? _confirmSelection : null,
              tooltip: 'Xác nhận chọn',
            ),
        ],
      ),
      body: FutureBuilder<List<Recipesresponse>>(
        future: _recipeFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Không có công thức nào.'));
          } else {
            final recipes = snapshot.data!;
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
                        Text(recipe.description ?? 'Không có mô tả'),
                        Text('Tác giả: ${recipe.createdBy}'),
                        Text('Hướng dẫn:/n ${recipe.instructions}'),
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
        },
      ),
    );
  }
}