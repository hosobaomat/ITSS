class UnitResponse {
  int unidId;
  String unitName;
  String unitDescription;

  UnitResponse(this.unidId, this.unitName, this.unitDescription);

  factory UnitResponse.fromJson(Map<String, dynamic> json) {
    print("Mapping UnitResponse from JSON: $json"); // Debug dữ liệu JSON
    return UnitResponse(
      json['unidId'] as int,
      json['unitName'] as String,
      json['unitDescription'] as String,
    );
  }

  @override
  String toString() =>
      'UnitResponse(unidId: $unidId, unitName: $unitName, unitDescription: $unitDescription)';
}
