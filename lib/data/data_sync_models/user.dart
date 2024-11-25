import 'dart:convert';

import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String? shift;
  final String? namaStaff;
  final String? department;

  const User({this.shift, this.namaStaff, this.department});

  factory User.fromMap(Map<String, dynamic> data) => User(
        shift: data['shift'] as String?,
        namaStaff: data['nama_staff'] as String?,
        department: data['department'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'shift': shift,
        'nama_staff': namaStaff,
        'department': department,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [User].
  factory User.fromJson(String data) {
    return User.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [User] to a JSON string.
  String toJson() => json.encode(toMap());

  User copyWith({
    String? shift,
    String? namaStaff,
    String? department,
  }) {
    return User(
      shift: shift ?? this.shift,
      namaStaff: namaStaff ?? this.namaStaff,
      department: department ?? this.department,
    );
  }

  @override
  List<Object?> get props => [shift, namaStaff, department];
}
