import 'package:equatable/equatable.dart';

/// Custom List
class UserModel extends Equatable {

  List<User>? user;

  UserModel({this.user});

  UserModel.fromJson(dynamic json) {
    if (json['user'] != null) {
      user = <User>[];
      json['user'].forEach((v) {
        user!.add(User.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user'] = user!.map((v) => v.toJson()).toList();
    return data;
  }

  @override
  List<Object> get props => [user!];
}

class User extends Equatable {
  const User({
    this.nik = '',
    this.password = '',
    this.level = '',
    this.jabatan = '',
    this.name = '',
    this.username = '',
    this.department = '',
    this.shift = '',
    this.patrol = 1,
    this.backgroundCover = '',
    this.urlServer = 'http://192.168.31.34:8080',
    this.api_id = 'dikosongin'
  });

  factory User.fromJson(dynamic json) => User(
        nik: json['nik'] ?? '',
        password: json['password'] ?? '',
        level: json['level'] ?? '',
        jabatan: json['jabatan'] ?? '',
        name: json['name'] ?? '',
        username: json['username'] ?? '',
        shift: json['shift'] ?? "",
        patrol: json['patrol'] ?? 1,
        department: json['department'] ?? '',
        backgroundCover: json['background_path'] ?? '',
        urlServer: json['url_server'] ?? 'http://192.168.31.34:8080',
        api_id: json['api_id'] ?? 'dikosongin',
      );

  final String nik;
  final String password;
  final String level;
  final String jabatan;
  final String name;
  final String username;
  final String department;
  final String backgroundCover;
  final String urlServer;
  final String api_id;
  final int patrol;
  final String shift;

  User copyWith({
    String? nik,
    String? password,
    String? level,
    String? jabatan,
    String? name,
    String? username,
    String? department,
    String? shift,
    int? patrol,
    String? backgroundCover,
    String? urlServer,
    String? api_id,
  }) =>
      User(
          nik: nik ?? this.nik,
          password: password ?? this.password,
          level: level ?? this.level,
          jabatan: jabatan ?? this.jabatan,
          name: name ?? this.name,
          username: username ?? this.username,
          department: department ?? this.department,
          shift: shift ?? this.shift,
          patrol: patrol ?? this.patrol,
          backgroundCover: backgroundCover ?? this.backgroundCover,
          urlServer: urlServer ?? this.urlServer,
          api_id: api_id ?? this.api_id);

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['nik'] = nik;
    map['password'] = password;
    map['level'] = level;
    map['jabatan'] = jabatan;
    map['name'] = name;
    map['username'] = username;
    map['department'] = department;
    map['shift'] = shift;
    map['patrol'] = patrol;
    map['background_path'] = backgroundCover;
    map['url_server'] = urlServer;
    map['api_id'] = api_id;
    return map;
  }

  @override
  List<Object?> get props => [
        nik,
        password,
        level,
        jabatan,
        name,
        username,
        department,
        shift,
        patrol,
        backgroundCover,
        urlServer,
        api_id
      ];
}
