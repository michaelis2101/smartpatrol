import 'package:equatable/equatable.dart';

class SectionModel extends Equatable {
  const SectionModel({this.section = const []});

  factory SectionModel.fromJson(dynamic json) => SectionModel(
      section: ((json["section"] as List?) ?? [])
          .map((e) => Section.fromJson(e))
          .toList());

  final List<Section> section;

  SectionModel copyWith({List<Section>? section}) =>
      SectionModel(section: section ?? this.section);

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['section'] = section.map((v) => v.toJson()).toList();
    return map;
  }

  @override
  List<Object> get props => [section];
}

class Section extends Equatable {
  const Section({this.id = '',this.kodeSection = '', this.namaSection = '',this.kodeFormat = ''});

  factory Section.fromJson(dynamic json) => Section(
        id: json['id'] ?? '',
        kodeSection: json['kode_section'] ?? '',
        namaSection: json['nama_section'] ?? '',
        kodeFormat: json['kode_format'] ?? '',
        
      );

  final String kodeSection;
  final String namaSection;
  final String kodeFormat,id;

  Section copyWith(
          {String? id,String? kodeSection, String? namaSection, String? kodeFormat}) =>
      Section(
         id: id ?? this.id,
        kodeSection: kodeSection ?? this.kodeSection,
        namaSection: namaSection ?? this.namaSection,
        kodeFormat: kodeFormat ?? this.kodeFormat,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['kode_section'] = kodeSection;
    map['nama_section'] = namaSection;
    map['kode_format'] = kodeFormat;
    return map;
  }

  @override
  List<Object> get props => [id,kodeSection, namaSection, kodeFormat];
}
