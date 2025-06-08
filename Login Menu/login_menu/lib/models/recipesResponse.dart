class Recipesresponse {
  final int id;
  final String recipeName;
  final String instructions;
  final int prepTime;
  final int cookTime;
  final String description;
  final String createdBy;

  Recipesresponse({
    required this.id,
    required this.recipeName,
    required this.instructions,
    required this.prepTime,
    required this.cookTime,
    required this.description,
    required this.createdBy,
  });

  factory Recipesresponse.fromJson(Map<String, dynamic> json) {
    return Recipesresponse(
      id: json['id'],
      recipeName: json['recipeName'],
      instructions: json['instructions'],
      prepTime: json['prepTime'],
      cookTime: json['cookTime'],
      description: json['description'],
      createdBy: json['createdBy'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'recipeName': recipeName,
      'instructions': instructions,
      'prepTime': prepTime,
      'cookTime': cookTime,
      'description': description,
      'createdBy': createdBy,
    };
  }
}