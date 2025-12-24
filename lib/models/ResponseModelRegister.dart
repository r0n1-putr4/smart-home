// To parse this JSON data, do
//
//     final responseModelRegister = responseModelRegisterFromJson(jsonString);

import 'dart:convert';

ResponseModelRegister responseModelRegisterFromJson(String str) => ResponseModelRegister.fromJson(json.decode(str));

String responseModelRegisterToJson(ResponseModelRegister data) => json.encode(data.toJson());

class ResponseModelRegister {
  bool success;
  String message;

  ResponseModelRegister({
    required this.success,
    required this.message,
  });

  factory ResponseModelRegister.fromJson(Map<String, dynamic> json) => ResponseModelRegister(
    success: json["success"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
  };
}
