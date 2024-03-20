// To parse this JSON data, do
//
//     final modelCreatePegawai = modelCreatePegawaiFromJson(jsonString);

import 'dart:convert';

ModelCreatePegawai modelCreatePegawaiFromJson(String str) => ModelCreatePegawai.fromJson(json.decode(str));

String modelCreatePegawaiToJson(ModelCreatePegawai data) => json.encode(data.toJson());

class ModelCreatePegawai {
  int value;
  String message;

  ModelCreatePegawai({
    required this.value,
    required this.message,
  });

  factory ModelCreatePegawai.fromJson(Map<String, dynamic> json) => ModelCreatePegawai(
    value: json["value"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "value": value,
    "message": message,
  };
}
