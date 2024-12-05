import 'dart:convert';

class QRUserModel {
  final String fullName;
  final String email;
  final String phoneNo;
  final String address;

  // Constructor
  const QRUserModel({
    required this.fullName,
    required this.email,
    required this.phoneNo,
    required this.address,
  });

  // Convert to JSON
  String toJson() {
    return jsonEncode({
      "FullName": fullName,
      "Email": email,
      "Phone": phoneNo,
      "Address": address,
    });
  }

  // Convert JSON to QRUserModel
  factory QRUserModel.fromJson(String json) {
    final data = jsonDecode(json);
    return QRUserModel(
      fullName: data['FullName'],
      email: data['Email'],
      phoneNo: data['Phone'],
      address: data['Address'],
    );
  }
}
