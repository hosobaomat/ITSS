class RecipeInput {
  final int recipeId;
  final int groupId;

  RecipeInput({required this.recipeId, required this.groupId});

  Map<String, dynamic> toJson() => {
        'recipeId': recipeId,
        'groupId': groupId,
      };
}