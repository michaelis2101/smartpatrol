import 'package:equatable/equatable.dart';

class FormatModel extends Equatable {
  const FormatModel({this.formats = const []});

  factory FormatModel.fromJson(dynamic json) => FormatModel(
      formats: ((json["format"] as List?) ?? [])
          .map((e) => Formats.fromJson(e))
          .toList());

  final List<Formats> formats;

  FormatModel copyWith({List<Formats>? formats}) =>
      FormatModel(formats: formats ?? this.formats);

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['format'] = formats.map((v) => v.toJson()).toList();
    return map;
  }

  @override
  List<Object> get props => [formats];
}

class Formats extends Equatable {
  const Formats({this.id = '', this.kodeFormat = '', this.department = '',this.kodeSection = ''});

  factory Formats.fromJson(dynamic json) => Formats(
        id: json['id'] ?? '',
        department: json['department'] ?? '',
        kodeFormat: json['kode_format'] ?? '',
        kodeSection: json['kode_section'] ?? '',
      );

  final String id;
  final String kodeFormat, department,kodeSection;

  Formats copyWith({String? id, String? kodeFormat, String? department,String? kodeSection}) =>
      Formats(
          id: id ?? this.id,
          kodeFormat: kodeFormat ?? this.kodeFormat,
          kodeSection:kodeSection??this.kodeSection,
          department: department ?? this.department,
          );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['kode_format'] = kodeFormat;
    map['kode_section'] = kodeSection;
    map['department'] = department;
    return map;
  }

  @override
  List<Object> get props => [id, kodeFormat, department,kodeSection];
}
