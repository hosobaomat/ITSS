// shoppinglist_request.dart

class ShoppingListCreateRequest {
  final String listName;
  final int createdBy;
  final int group_id;
  final DateTime startDate;
  final DateTime endDate;
  final String status;

  ShoppingListCreateRequest(
    this.listName,
    this.createdBy,
    this.group_id,
    this.startDate,
    this.endDate,
    this.status,
  );

  Map<String, dynamic> toJson() {
    return {
      'listName': listName,
      'createdBy': createdBy,
      'group_id': group_id,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'status': status,
    };
  }
}
