import 'package:equatable/equatable.dart';

/// Custom List
class ScheduleModel extends Equatable {
  const ScheduleModel({this.schedule = const []});

  factory ScheduleModel.fromJson(dynamic json) => ScheduleModel(
      schedule: ((json["schedule"] as List?) ?? [])
          .map((e) => Schedule.fromJson(e))
          .toList());

  final List<Schedule> schedule;

  ScheduleModel copyWith({List<Schedule>? schedule}) =>
      ScheduleModel(schedule: schedule ?? this.schedule);

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['schedule'] = schedule.map((v) => v.toJson()).toList();
    return map;
  }

  @override
  List<Object> get props => [schedule];
}

class Schedule extends Equatable {
  const Schedule(
      {this.tagService = '',
      this.hari = '',
      this.tipeSchedule = '',
      this.namaCpl = '',
      this.nomerCpl = '',
      this.shift = '',
      this.kodeArea = '',
      this.namaArea = '',
      this.namaEquipment = '',
      this.time1 = '',
      this.time2 = '',
      this.uuidService = '',
      this.groupTren = '',
      this.waktuPatrol = '',
      this.namaService = '',
      this.kodeEquipment = ''});

  factory Schedule.fromJson(dynamic json) => Schedule(
      tagService: json['tag_service'] ?? '',
      hari: json['hari'] ?? '',
      tipeSchedule: json['tipe_schedule'] ?? '',
      namaCpl: json['nama_cpl'] ?? '',
      nomerCpl: json['nomer_cpl'] ?? '',
      shift: json['shift'] ?? '',
      kodeArea: json['kode_area'] ?? '',
      namaArea: json['nama_area'] ?? '',
      namaEquipment: json['nama_equipment'] ?? '',
      time1: json['time1'] ?? '',
      time2: json['time2'] ?? '',
      uuidService: json['uuid_service'] ?? '',
      groupTren: json['group_tren'] ?? '',
      waktuPatrol: json['waktu_patrol'] ?? '',
      namaService: json['nama_service'] ?? '',
      kodeEquipment: json['kode_equipment'] ?? '');

  final String tagService;
  final String hari;
  final String tipeSchedule;
  final String namaCpl;
  final String nomerCpl;
  final String shift;
  final String kodeArea;
  final String namaArea;
  final String namaEquipment;
  final String time1;
  final String time2;
  final String uuidService;
  final String groupTren;
  final String waktuPatrol;
  final String namaService;
  final String kodeEquipment;

  Schedule copyWith({
    String? tagService,
    String? hari,
    String? tipeSchedule,
    String? namaCpl,
    String? nomerCpl,
    String? shift,
    String? kodeArea,
    String? namaArea,
    String? namaEquipment,
    String? time1,
    String? time2,
    String? uuidService,
    String? groupTren,
    String? waktuPatrol,
    String? namaService,
    String? kodeEquipment,
  }) =>
      Schedule(
        tagService: tagService ?? this.tagService,
        hari: hari ?? this.hari,
        tipeSchedule: tipeSchedule ?? this.tipeSchedule,
        namaCpl: namaCpl ?? this.namaCpl,
        nomerCpl: nomerCpl ?? this.nomerCpl,
        shift: shift ?? this.shift,
        kodeArea: kodeArea ?? this.kodeArea,
        namaArea: namaArea ?? this.namaArea,
        namaEquipment: namaEquipment ?? this.namaEquipment,
        time1: time1 ?? this.time1,
        time2: time2 ?? this.time2,
        uuidService: uuidService ?? this.uuidService,
        groupTren: groupTren ?? this.groupTren,
        waktuPatrol: waktuPatrol ?? this.waktuPatrol,
        namaService: namaService ?? this.namaService,
        kodeEquipment: kodeEquipment ?? this.kodeEquipment,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['tag_service'] = tagService;
    map['hari'] = hari;
    map['tipe_schedule'] = tipeSchedule;
    map['nama_cpl'] = namaCpl;
    map['nomer_cpl'] = nomerCpl;
    map['shift'] = shift;
    map['kode_area'] = kodeArea;
    map['nama_area'] = namaArea;
    map['nama_equipment'] = namaEquipment;
    map['time1'] = time1;
    map['time2'] = time2;
    map['uuid_service'] = uuidService;
    map['group_tren'] = groupTren;
    map['waktu_patrol'] = waktuPatrol;
    map['nama_service'] = namaService;
    map['kode_equipment'] = kodeEquipment;
    return map;
  }

  @override
  List<Object> get props => [
        tagService,
        hari,
        tipeSchedule,
        namaCpl,
        nomerCpl,
        shift,
        kodeArea,
        namaArea,
        namaEquipment,
        time1,
        time2,
        uuidService,
        groupTren,
        waktuPatrol,
        namaService,
        kodeEquipment
      ];
}
