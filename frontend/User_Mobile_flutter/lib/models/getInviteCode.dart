class Getinvitecode {
  final int code;
  final String result;

  Getinvitecode({required this.code, required this.result});

  factory Getinvitecode.fromJson(Map<String, dynamic> json) {
    return Getinvitecode(
      code: json['code'],
      result: json['result'],
    );
  }
}