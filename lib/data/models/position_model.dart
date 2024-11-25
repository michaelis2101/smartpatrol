import 'package:equatable/equatable.dart';

/// Custom List
class PositionModel extends Equatable {
  const PositionModel({this.position = const []});

  factory PositionModel.fromJson(dynamic json) => PositionModel(
      position: ((json["position"] as List?) ?? [])
          .map((e) => Position.fromJson(e))
          .toList());

  final List<Position> position;

  PositionModel copyWith({List<Position>? position}) =>
      PositionModel(position: position ?? this.position);

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['position'] = position.map((v) => v.toJson()).toList();
    return map;
  }

  @override
  List<Object> get props => [position];
}

class Position extends Equatable {
  const Position(
      {this.idTahap = '',
      this.kodeCpl = '',
      this.trainB = '',
      this.trainA = '',
      this.id = '',
      this.posisi = '',
      this.trainC = ''});

  factory Position.fromJson(dynamic json) => Position(
      idTahap: json['id_tahap'] ?? '',
      kodeCpl: json['kode_cpl'] ?? '',
      trainB: json['train_b'] ?? '',
      trainA: json['train_a'] ?? '',
      id: json['id'] ?? '',
      posisi: json['posisi'] ?? '',
      trainC: json['train_c'] ?? '');

  final String idTahap;
  final String kodeCpl;
  final String trainB;
  final String trainA;
  final String id;
  final String posisi;
  final String trainC;

  Position copyWith({
    String? idTahap,
    String? kodeCpl,
    String? trainB,
    String? trainA,
    String? id,
    String? posisi,
    String? trainC,
  }) =>
      Position(
          idTahap: idTahap ?? this.idTahap,
          kodeCpl: kodeCpl ?? this.kodeCpl,
          trainB: trainB ?? this.trainB,
          trainA: trainA ?? this.trainA,
          id: id ?? this.id,
          posisi: posisi ?? this.posisi,
          trainC: trainC ?? this.trainC);

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id_tahap'] = idTahap;
    map['kode_cpl'] = kodeCpl;
    map['train_b'] = trainB;
    map['train_a'] = trainA;
    map['id'] = id;
    map['posisi'] = posisi;
    map['train_c'] = trainC;
    return map;
  }

  @override
  List<Object> get props =>
      [idTahap, kodeCpl, trainB, trainA, id, posisi, trainC];
}
