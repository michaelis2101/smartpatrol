// ignore: file_names
import 'dart:convert';

/// user : {"tanggal":"2023-06-23","shift":"1","nama_staff":"SORE SORE","kode_cpl":"200","nama_cpl":"Cobain Foto Lagi","department":"VCM-1"}
/// data : [{"kode_service":"d79006ae-7886-457b-aa84-6fa5e389c5b4","user_nik":"19880116","shift":"2","input":"hasilnya","tanggal":"2023-06-20 08:00:00","foto":""},{"kode_service":"d79006ae-7886-457b-aa84-6fa5e389c5b4","user_nik":"19880116","shift":"2","input":"hasilnya","tanggal":"2023-06-20 08:00:00","foto":""}]

DataSyncronizeModel dataSyncronizeModelFromJson(String str) =>
    DataSyncronizeModel.fromJson(json.decode(str));
String dataSyncronizeModelToJson(DataSyncronizeModel data) =>
    json.encode(data.toJson());

class DataSyncronizeModel {
  DataSyncronizeModel({
    this.user,
    this.data,
  });

  DataSyncronizeModel.fromJson(dynamic json) {
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(Data.fromJson(v));
      });
    }
  }
  User? user;
  List<Data>? data;
  DataSyncronizeModel copyWith({
    User? user,
    List<Data>? data,
  }) =>
      DataSyncronizeModel(
        user: user ?? this.user,
        data: data ?? this.data,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (user != null) {
      map['user'] = user?.toJson();
    }
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// kode_service : "d79006ae-7886-457b-aa84-6fa5e389c5b4"
/// user_nik : "19880116"
/// shift : "2"
/// input : "hasilnya"
/// tanggal : "2023-06-20 08:00:00"
/// foto : ""

Data dataFromJson(String str) => Data.fromJson(json.decode(str));
String dataToJson(Data data) => json.encode(data.toJson());

class Data {
  Data({
    this.kodeService,
    this.userNik,
    this.shift,
    this.input,
    this.tanggal,
    this.foto,
  });

  Data.fromJson(dynamic json) {
    kodeService = json['kode_service'];
    userNik = json['user_nik'];
    shift = json['shift'];
    input = json['input'];
    tanggal = json['tanggal'];
    foto = json['foto'];
  }
  String? kodeService;
  String? userNik;
  String? shift;
  String? input;
  String? tanggal;
  String? foto;
  Data copyWith({
    String? kodeService,
    String? userNik,
    String? shift,
    String? input,
    String? tanggal,
    String? foto,
  }) =>
      Data(
        kodeService: kodeService ?? this.kodeService,
        userNik: userNik ?? this.userNik,
        shift: shift ?? this.shift,
        input: input ?? this.input,
        tanggal: tanggal ?? this.tanggal,
        foto: foto ?? this.foto,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['kode_service'] = kodeService;
    map['user_nik'] = userNik;
    map['shift'] = shift;
    map['input'] = input;
    map['tanggal'] = tanggal;
    map['foto'] = foto;
    return map;
  }
}

/// tanggal : "2023-06-23"
/// shift : "1"
/// nama_staff : "SORE SORE"
/// kode_cpl : "200"
/// nama_cpl : "Cobain Foto Lagi"
/// department : "VCM-1"

User userFromJson(String str) => User.fromJson(json.decode(str));
String userToJson(User data) => json.encode(data.toJson());

class User {
  User({
    this.tanggal,
    this.shift,
    this.namaStaff,
    this.kodeCpl,
    this.namaCpl,
    this.department,
  });

  User.fromJson(dynamic json) {
    tanggal = json['tanggal'];
    shift = json['shift'];
    namaStaff = json['nama_staff'];
    kodeCpl = json['kode_cpl'];
    namaCpl = json['nama_cpl'];
    department = json['department'];
  }
  String? tanggal;
  String? shift;
  String? namaStaff;
  String? kodeCpl;
  String? namaCpl;
  String? department;
  User copyWith({
    String? tanggal,
    String? shift,
    String? namaStaff,
    String? kodeCpl,
    String? namaCpl,
    String? department,
  }) =>
      User(
        tanggal: tanggal ?? this.tanggal,
        shift: shift ?? this.shift,
        namaStaff: namaStaff ?? this.namaStaff,
        kodeCpl: kodeCpl ?? this.kodeCpl,
        namaCpl: namaCpl ?? this.namaCpl,
        department: department ?? this.department,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['tanggal'] = tanggal;
    map['shift'] = shift;
    map['nama_staff'] = namaStaff;
    map['kode_cpl'] = kodeCpl;
    map['nama_cpl'] = namaCpl;
    map['department'] = department;
    return map;
  }
}
