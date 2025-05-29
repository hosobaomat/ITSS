class ShoppingListCreateRequest {
  String? listName;
  int? createdBy;
  int? group_id;
  DateTime? startDate;
  DateTime? endDate;
  String? status;

  ShoppingListCreateRequest(this.listName, this.createdBy, this.group_id,
      this.startDate, this.endDate, String s);
  //Set<ShoppingListItemRequest> items = new HashSet<>();
}
