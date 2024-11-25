import 'package:equatable/equatable.dart';

/// Custom List
class SpecialJobModel extends Equatable {
  const SpecialJobModel({this.specialJob = const []});

  factory SpecialJobModel.fromJson(dynamic json) => SpecialJobModel(
      specialJob: ((json["special_job"] as List?) ?? [])
          .map((e) => SpecialJob.fromJson(e))
          .toList());

  final List<SpecialJob> specialJob;

  SpecialJobModel copyWith({List<SpecialJob>? specialJob}) =>
      SpecialJobModel(specialJob: specialJob ?? this.specialJob);

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['special_job'] = specialJob.map((v) => v.toJson()).toList();
    return map;
  }

  @override
  List<Object> get props => [specialJob];
}

class SpecialJob extends Equatable {
  const SpecialJob(
      {this.nilaiMax = '',
      this.tipeForm = '',
      this.kodeNfc = '',
      this.opsi = '',
      this.namaCpl = '',
      this.check = '',
      this.idTahap = '',
      this.number = '',
      this.nilaiMin = '',
      this.unit = '',
      this.pumpCheck = '',
      this.nama = '',
      this.kodeCpl = '',
      this.duty = '',
      this.tahap = '',
      this.tipeCpl = '',
      this.tipeFormat = '',
      this.opsiBenar = '',
      this.option = ''});

  factory SpecialJob.fromJson(dynamic json) => SpecialJob(
      nilaiMax: json['nilai_max'] ?? '',
      tipeForm: json['tipe_form'] ?? '',
      kodeNfc: json['kode_nfc'] ?? '',
      opsi: json['opsi'] ?? '',
      namaCpl: json['nama_cpl'] ?? '',
      check: json['check'] ?? '',
      idTahap: json['id_tahap'] ?? '',
      number: json['number'] ?? '',
      nilaiMin: json['nilai_min'] ?? '',
      unit: json['unit'] ?? '',
      pumpCheck: json['pump_check'] ?? '',
      nama: json['nama'] ?? '',
      kodeCpl: json['kode_cpl'] ?? '',
      duty: json['duty'] ?? '',
      tahap: json['tahap'] ?? '',
      tipeCpl: json['tipe_cpl'] ?? '',
      tipeFormat: json['tipe_format'] ?? '',
      opsiBenar: json['opsi_benar'] ?? '',
      option: json['option'] ?? '');

  final String nilaiMax;
  final String tipeForm;
  final String kodeNfc;
  final String opsi;
  final String namaCpl;
  final String check;
  final String idTahap;
  final String number;
  final String nilaiMin;
  final String unit;
  final String pumpCheck;
  final String nama;
  final String kodeCpl;
  final String duty;
  final String tahap;
  final String tipeCpl;
  final String tipeFormat;
  final String opsiBenar;
  final String option;

  SpecialJob copyWith({
    String? nilaiMax,
    String? tipeForm,
    String? kodeNfc,
    String? opsi,
    String? namaCpl,
    String? check,
    String? idTahap,
    String? number,
    String? nilaiMin,
    String? unit,
    String? pumpCheck,
    String? nama,
    String? kodeCpl,
    String? duty,
    String? tahap,
    String? tipeCpl,
    String? tipeFormat,
    String? opsiBenar,
    String? option,
  }) =>
      SpecialJob(
        nilaiMax: nilaiMax ?? this.nilaiMax,
        tipeForm: tipeForm ?? this.tipeForm,
        kodeNfc: kodeNfc ?? this.kodeNfc,
        opsi: opsi ?? this.opsi,
        namaCpl: namaCpl ?? this.namaCpl,
        check: check ?? this.check,
        idTahap: idTahap ?? this.idTahap,
        number: number ?? this.number,
        nilaiMin: nilaiMin ?? this.nilaiMin,
        unit: unit ?? this.unit,
        pumpCheck: pumpCheck ?? this.pumpCheck,
        nama: nama ?? this.nama,
        kodeCpl: kodeCpl ?? this.kodeCpl,
        duty: duty ?? this.duty,
        tahap: tahap ?? this.tahap,
        tipeCpl: tipeCpl ?? this.tipeCpl,
        tipeFormat: tipeFormat ?? this.tipeFormat,
        opsiBenar: opsiBenar ?? this.opsiBenar,
        option: option ?? this.option,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['nilai_max'] = nilaiMax;
    map['tipe_form'] = tipeForm;
    map['kode_nfc'] = kodeNfc;
    map['opsi'] = opsi;
    map['nama_cpl'] = namaCpl;
    map['check'] = check;
    map['id_tahap'] = idTahap;
    map['number'] = number;
    map['nilai_min'] = nilaiMin;
    map['unit'] = unit;
    map['pump_check'] = pumpCheck;
    map['nama'] = nama;
    map['kode_cpl'] = kodeCpl;
    map['duty'] = duty;
    map['tahap'] = tahap;
    map['tipe_cpl'] = tipeCpl;
    map['tipe_format'] = tipeFormat;
    map['opsi_benar'] = opsiBenar;
    map['option'] = option;
    return map;
  }

  @override
  List<Object> get props => [
        nilaiMax,
        tipeForm,
        kodeNfc,
        opsi,
        namaCpl,
        check,
        idTahap,
        number,
        nilaiMin,
        unit,
        pumpCheck,
        nama,
        kodeCpl,
        duty,
        tahap,
        tipeCpl,
        tipeFormat,
        opsiBenar,
        option
      ];
}
