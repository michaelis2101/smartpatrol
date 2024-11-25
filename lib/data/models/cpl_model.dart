import 'package:equatable/equatable.dart';

class CplModel extends Equatable {
  const CplModel({this.cpl = const []});

  factory CplModel.fromJson(dynamic json) => CplModel(
      cpl: ((json['cpl'] as List?) ?? []).map((e) => Cpl.fromJson(e)).toList());

  final List<Cpl> cpl;

  CplModel copyWith({List<Cpl>? cpl}) => CplModel(cpl: cpl ?? this.cpl);

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['cpl'] = cpl.map((v) => v.toJson()).toList();
    return map;
  }

  @override
  List<Object> get props => [cpl];
}

class Cpl extends Equatable {
  const Cpl(
      {this.formatTipe = '',
      this.kodeNfcCpl = '',
      this.namaCpl = '',
      this.kodeCpl = '',
      this.kodeArea = '',
      this.tipeCpl = '',
      this.template = ''});

  factory Cpl.fromJson(dynamic json) => Cpl(
        formatTipe: json['format_tipe'] ?? '',
        kodeNfcCpl: json['kode_nfc_cpl'] ?? '',
        namaCpl: json['nama_cpl'] ?? '',
        kodeCpl: json['kode_cpl'] ?? '',
        kodeArea: json['kode_area'] ?? '',
        tipeCpl: json['tipe_cpl'] ?? '',
        template: json['template'] ?? '',
      );

  final String formatTipe;
  final String kodeNfcCpl;
  final String namaCpl;
  final String kodeCpl;
  final String kodeArea;
  final String tipeCpl;
  final String template;

  Cpl copyWith({
    String? formatTipe,
    String? kodeNfcCpl,
    String? namaCpl,
    String? kodeCpl,
    String? kodeArea,
    String? tipeCpl,
    String? template,
  }) =>
      Cpl(
        formatTipe: formatTipe ?? this.formatTipe,
        kodeNfcCpl: kodeNfcCpl ?? this.kodeNfcCpl,
        namaCpl: namaCpl ?? this.namaCpl,
        kodeCpl: kodeCpl ?? this.kodeCpl,
        kodeArea: kodeArea ?? this.kodeArea,
        tipeCpl: tipeCpl ?? this.tipeCpl,
        template: template ?? this.template,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['format_tipe'] = formatTipe;
    map['kode_nfc_cpl'] = kodeNfcCpl;
    map['nama_cpl'] = namaCpl;
    map['kode_cpl'] = kodeCpl;
    map['kode_area'] = kodeArea;
    map['tipe_cpl'] = tipeCpl;
    map['template'] = template;
    return map;
  }

  @override
  List<Object> get props =>
      [formatTipe, kodeNfcCpl, namaCpl, kodeCpl, kodeArea, tipeCpl, template];
}
