import 'dart:convert';

import 'package:equatable/equatable.dart';

class EquipmentModel extends Equatable {
  const EquipmentModel({this.equipment = const []});

  factory EquipmentModel.fromJson(dynamic json) =>
      EquipmentModel(
          equipment: ((json['equipment'] as List?) ?? [])
              .map((e) => Equipment.fromJson(e))
              .toList());

  final List<Equipment> equipment;

  EquipmentModel copyWith({List<Equipment>? equipment}) =>
      EquipmentModel(equipment: equipment ?? this.equipment);

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['equipment'] = equipment.map((v) => v.toJson()).toList();
    return map;
  }

  @override
  List<Object> get props => [equipment];
}

class Equipment extends Equatable {
  const Equipment({this.namaEquipment = '',
    this.kodeNfc = '',
    this.kodeCpl = '',
    this.kodeEquipment = '',
    this.shift = '',
    this.tipeCpl = '',
    required this.to ,
    this.progress = 0});

  factory Equipment.fromJson(dynamic json) =>
      Equipment(
          namaEquipment: json['nama_equipment'] ?? '',
          kodeNfc: json['kode_nfc'] ?? '',
          kodeCpl: json['kode_cpl'] ?? '',
          kodeEquipment: json['kode_equipment'] ?? '',
          shift: json['shift'] ?? '',
          tipeCpl: json['tipe_cpl'] ?? '',
          to: jsonEncode(json['to']),
          // to: (json['to'] as List?)
          //     ?.map((e) => e as Map<String, List<String>>)
          //     .toList() ?? [],

          progress: json['progress'] ?? 0);

  final String namaEquipment;
  final String kodeNfc;
  final String kodeCpl;
  final String kodeEquipment;
  final String shift;
  final String tipeCpl;
  final String to;
  final int progress;

  Equipment copyWith({
    String? namaEquipment,
    String? kodeNfc,
    String? kodeCpl,
    String? kodeEquipment,
    String? tipeCpl,
    int? progress,
    String? shift,
    String? to
  }) =>
      Equipment(
        namaEquipment: namaEquipment ?? this.namaEquipment,
        kodeNfc: kodeNfc ?? this.kodeNfc,
        kodeCpl: kodeCpl ?? this.kodeCpl,
        tipeCpl: tipeCpl ?? this.tipeCpl,
        kodeEquipment: kodeEquipment ?? this.kodeEquipment,
        progress: progress ?? this.progress,
        shift: shift ?? this.shift,
        to: to ?? this.to,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['nama_equipment'] = namaEquipment;
    map['kode_nfc'] = kodeNfc;
    map['kode_cpl'] = kodeCpl;
    map['kode_equipment'] = kodeEquipment;
    map['progress'] = progress;
    map['tipe_cpl'] = tipeCpl;
    map['shift'] = shift;
    map['to'] = to;
    return
    map;
  }

  @override
  List<Object> get props =>
      [
        namaEquipment,
        kodeNfc,
        kodeCpl,
        kodeEquipment,
        progress,
        shift,
        tipeCpl,
        to
      ];
}
class To {
  List<String>? l1;
  List<String>? l2;
  List<String>? l3;

  To({this.l1, this.l2, this.l3});

  To.fromJson(Map<String, dynamic> json) {
    l1 = json['1'].cast<String>();
    l2 = json['2'].cast<String>();
    l3 = json['3'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['1'] = l1;
    data['2'] = l2;
    data['3'] = l3;
    return data;
  }
}
