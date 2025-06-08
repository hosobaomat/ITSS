class UpdateItemRequest {
  final int id;
  String storageLocation;
  DateTime expireDate; // Đúng tên trường backend yêu cầu!

  UpdateItemRequest({
    required this.id,
    required this.storageLocation,
    required this.expireDate,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'expireDate':
            expireDate.toIso8601String(), // Đúng key, không phải expiryDate!
        'storageLocation': storageLocation,
      };
}
