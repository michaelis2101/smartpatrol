import 'package:equatable/equatable.dart';

class NotificationModel extends Equatable {
  const NotificationModel({this.notification = const []});

  factory NotificationModel.fromJson(dynamic json) => NotificationModel(
      notification: ((json['notification'] as List?) ?? [])
          .map((e) => Notification.fromJson(e))
          .toList());

  final List<Notification> notification;

  NotificationModel copyWith({List<Notification>? notification}) =>
      NotificationModel(notification: notification ?? this.notification);

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['notification'] = notification.map((v) => v.toJson()).toList();
    return map;
  }

  @override
  List<Object> get props => [notification];
}

class Notification extends Equatable {
  const Notification(
      {this.namaCpl = '',
      this.kodeCpl = '',
      this.shift = '',
      this.kodeArea = '',
      this.namaArea = '',
      this.time = '',
      this.waktuPatrol = ''});

  factory Notification.fromJson(dynamic json) => Notification(
      namaCpl: json['nama_cpl'] ?? '',
      kodeCpl: json['kode_cpl'] ?? '',
      shift: json['shift'] ?? '',
      kodeArea: json['kode_area'] ?? '',
      namaArea: json['nama_area'] ?? '',
      time: json['time'] ?? '',
      waktuPatrol: json['waktu_patrol'] ?? '');

  final String namaCpl;
  final String kodeCpl;
  final String shift;
  final String kodeArea;
  final String namaArea;
  final String time;
  final String waktuPatrol;

  Notification copyWith({
    String? namaCpl,
    String? kodeCpl,
    String? shift,
    String? kodeArea,
    String? namaArea,
    String? time,
    String? waktuPatrol,
  }) =>
      Notification(
        namaCpl: namaCpl ?? this.namaCpl,
        kodeCpl: kodeCpl ?? this.kodeCpl,
        shift: shift ?? this.shift,
        kodeArea: kodeArea ?? this.kodeArea,
        namaArea: namaArea ?? this.namaArea,
        time: time ?? this.time,
        waktuPatrol: waktuPatrol ?? this.waktuPatrol,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['nama_cpl'] = namaCpl;
    map['kode_cpl'] = kodeCpl;
    map['shift'] = shift;
    map['kode_area'] = kodeArea;
    map['nama_area'] = namaArea;
    map['time'] = time;
    map['waktu_patrol'] = waktuPatrol;
    return map;
  }

  @override
  List<Object> get props =>
      [namaCpl, kodeCpl, shift, kodeArea, namaArea, time, waktuPatrol];
}
