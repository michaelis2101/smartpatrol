import 'package:equatable/equatable.dart';

class AreaModel extends Equatable {
  const AreaModel({this.area = const []});

  factory AreaModel.fromJson(dynamic json) => AreaModel(
      area: ((json["area"] as List?) ?? [])
          .map((e) => Area.fromJson(e))
          .toList());

  final List<Area> area;

  AreaModel copyWith({List<Area>? area}) => AreaModel(area: area ?? this.area);

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['area'] = area.map((v) => v.toJson()).toList();
    return map;
  }

  @override
  List<Object> get props => [area];
}

class Area extends Equatable {
  const Area({this.kodeArea = '', this.namaArea = '', this.kodeSection = ''});

  factory Area.fromJson(dynamic json) => Area(
        kodeArea: json['kode_area'] ?? '',
        namaArea: json['nama_area'] ?? '',
        kodeSection: json['kode_section'] ?? '',
      );

  final String kodeArea;
  final String namaArea;
  final String kodeSection;

  Area copyWith({String? kodeArea, String? namaArea, String? kodeSection}) =>
      Area(
        kodeArea: kodeArea ?? this.kodeArea,
        namaArea: namaArea ?? this.namaArea,
        kodeSection: kodeSection ?? this.kodeSection,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['kode_area'] = kodeArea;
    map['nama_area'] = namaArea;
    map['kode_section'] = kodeSection;
    return map;
  }

  @override
  List<Object> get props => [kodeArea, namaArea, kodeSection];
}
