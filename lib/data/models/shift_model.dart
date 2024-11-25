import 'package:equatable/equatable.dart';

class ShiftModel extends Equatable {
  const ShiftModel({this.shift = const []});

  factory ShiftModel.fromJson(dynamic json) => ShiftModel(
      shift: ((json['shift'] as List?) ?? [])
          .map((e) => Shift.fromJson(e))
          .toList());

  final List<Shift> shift;

  ShiftModel copyWith({List<Shift>? shift}) =>
      ShiftModel(shift: shift ?? this.shift);

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['shift'] = shift.map((v) => v.toJson()).toList();
    return map;
  }

  @override
  List<Object> get props => [shift];
}

class Shift extends Equatable {
  const Shift(
      {this.shiftId = '',
      this.name = '',
      this.beginHours = '',
      this.endHours = ''});

  factory Shift.fromJson(dynamic json) => Shift(
      shiftId: json['shifId'] ?? '',
      name: json['name'] ?? '',
      beginHours: json['beginHours'] ?? '',
      endHours: json['endHours'] ?? '');

  final String beginHours;
  final String shiftId;
  final String endHours;
  final String name;

  Shift copyWith({
    String? shiftId,
    String? name,
    String? beginHours,
    String? endHours,
  }) =>
      Shift(
        shiftId: shiftId ?? this.shiftId,
        name: name ?? this.name,
        beginHours: beginHours ?? this.beginHours,
        endHours: endHours ?? this.endHours,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['shifId'] = shiftId;
    map['name'] = name;
    map['beginHours'] = beginHours;
    map['endHours'] = endHours;
    return map;
  }

  @override
  List<Object> get props => [shiftId, name, beginHours, endHours];
}
