// To parse this JSON data, do
//
//     final modelEditProfile = modelEditProfileFromJson(jsonString);

import 'dart:convert';

ModelEditProfile modelEditProfileFromJson(String str) => ModelEditProfile.fromJson(json.decode(str));

String modelEditProfileToJson(ModelEditProfile data) => json.encode(data.toJson());

class ModelEditProfile {
  int value;
  String message;

  ModelEditProfile({
    required this.value,
    required this.message,
  });

  factory ModelEditProfile.fromJson(Map<String, dynamic> json) => ModelEditProfile(
    value: json["value"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "value": value,
    "message": message,
  };
}