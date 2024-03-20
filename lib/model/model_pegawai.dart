// To parse this JSON data, do
//
//     final modelPegawai = modelPegawaiFromJson(jsonString);

import 'dart:convert';

ModelPegawai modelPegawaiFromJson(String str) => ModelPegawai.fromJson(json.decode(str));

String modelPegawaiToJson(ModelPegawai data) => json.encode(data.toJson());

class ModelPegawai {
  bool isSuccess;
  String message;
  List<Datum> data;

  ModelPegawai({
    required this.isSuccess,
    required this.message,
    required this.data,
  });

  factory ModelPegawai.fromJson(Map<String, dynamic> json) => ModelPegawai(
    isSuccess: json["isSuccess"],
    message: json["message"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "isSuccess": isSuccess,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  String id;
  String nama;
  String noBp;
  String noHp;
  String email;
  DateTime tglInput;

  Datum({
    required this.id,
    required this.nama,
    required this.noBp,
    required this.noHp,
    required this.email,
    required this.tglInput,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    nama: json["nama"],
    noBp: json["no_bp"],
    noHp: json["no_hp"],
    email: json["email"],
    tglInput: DateTime.parse(json["tgl_input"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "nama": nama,
    "no_bp": noBp,
    "no_hp": noHp,
    "email": email,
    "tgl_input": "${tglInput.year.toString().padLeft(4, '0')}-${tglInput.month.toString().padLeft(2, '0')}-${tglInput.day.toString().padLeft(2, '0')}",
  };
}
