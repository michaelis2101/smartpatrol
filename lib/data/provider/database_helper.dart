import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:smart_patrol/data/models/area_model.dart';
import 'package:smart_patrol/data/models/cpl_model.dart';
import 'package:smart_patrol/data/models/equipment_model.dart';
import 'package:smart_patrol/data/models/notification_model.dart';
import 'package:smart_patrol/data/models/position_model.dart';
import 'package:smart_patrol/data/models/schedule_model.dart';
import 'package:smart_patrol/data/models/section_model.dart';
import 'package:smart_patrol/data/models/service_model.dart';
import 'package:smart_patrol/data/models/shift_model.dart';
import 'package:smart_patrol/data/models/special_job_model.dart';
import 'package:smart_patrol/data/models/transaction_model.dart';
import 'package:smart_patrol/data/models/user_model.dart';

import '../models/format_model.dart';

class DatabaseProvider {
  static Future<CollectionBox<Map>> initialize() async {
    try {
      final directory = await getApplicationDocumentsDirectory();

      final collection =
          await BoxCollection.open('/SmartPatrol', {'db'}, path: directory.path);

      final db = await collection.openBox<Map>('db');
      return db;
    } catch (e, st) {
      if (kDebugMode) {
        log('DB Init - Exception[e]: $e');
        log('DB Init - Exception[st]: $st');
      }
      rethrow;
    }
  }

  static Future<void> putUserJson(List<User> user) async {
    try {
      final db = await initialize();

      if (user.isNotEmpty) {
        UserModel data = UserModel(user: user);
        await db.put('user', data.toJson());
      }
    } catch (e, st) {
      if (kDebugMode) {
        log('Put User Json - Exception[e]: $e');
        log('Put User Json - Exception[st]: $st');
      }
      rethrow;
    }
  }

  static Future<List<User>> getUserJson() async {
    try {
      final db = await initialize();

      var data = await db.get('user');

      if (data != null) {
        var user = UserModel.fromJson(data);
        return user.user!;
      } else {
        return [];
      }
    } catch (e, st) {
      if (kDebugMode) {
        log('Get User Json - Exception[e]: $e');
        log('Get User Json - Exception[st]: $st');
      }
      rethrow;
    }
  }

  static Future<void> putSignedUserJson(User user) async {
    try {
      final db = await initialize();
      await db.put('signed', user.toJson());
    } catch (e, st) {
      if (kDebugMode) {
        log('Put Signed User Json - Exception[e]: $e');
        log('Put Signed User Json - Exception[st]: $st');
      }
      rethrow;
    }
  }

  static Future<User?> getSignedUserJson() async {
    try {
      final db = await initialize();
      var data = await db.get('signed');
      if (data != null) {
        return User.fromJson(data);
      } else {
        return null;
      }
    } catch (e, st) {
      if (kDebugMode) {
        log('Get Signed User Json - Exception[e]: $e');
        log('Get Signed User Json - Exception[st]: $st');
      }
      rethrow;
    }
  }
//section

  static Future<void> putSectionJson(SectionModel section) async {
    try {
      final db = await initialize();

      await db.put('section', section.toJson());
    } catch (e, st) {
      if (kDebugMode) {
        log('Put Section Json - Exception[e]: $e');
        log('Put Section Json - Exception[st]: $st');
      }
      rethrow;
    }
  }

  static Future<List<Section>> getSectionsJson() async {
    try {
      final db = await initialize();

      var data = await db.get('section');

      if (data != null) {
        var section = SectionModel.fromJson(data);
        return section.section;
      } else {
        return [];
      }
    } catch (e, st) {
      if (kDebugMode) {
        log('Get Section Json - Exception[e]: $e');
        log('Get Section Json - Exception[st]: $st');
      }
      rethrow;
    }
  }

  //format

  static Future<void> putFormatJson(FormatModel format) async {
    try {
      final db = await initialize();
      await db.put('format_type', format.toJson());
    } catch (e, st) {
      if (kDebugMode) {
        log('Put Format Json - Exception[e]: $e');
        log('Put Format Json - Exception[st]: $st');
      }
      rethrow;
    }
  }

  static Future<List<Formats>> getFormatsJson() async {
    try {
      final db = await initialize();

      var data = await db.get('format_type');

      if (data != null) {
        var format = FormatModel.fromJson(data);
        return format.formats;
      } else {
        return [];
      }
    } catch (e, st) {
      if (kDebugMode) {
        log('Get Format Json - Exception[e]: $e');
        log('Get Format Json - Exception[st]: $st');
      }
      rethrow;
    }
  }

  static Future<void> putAreaJson(AreaModel area) async {
    try {
      final db = await initialize();

      await db.put('area', area.toJson());
    } catch (e, st) {
      if (kDebugMode) {
        log('Put Area Json - Exception[e]: $e');
        log('Put Area Json - Exception[st]: $st');
      }
      rethrow;
    }
  }

  static Future<List<Area>> getAreaJson() async {
    try {
      final db = await initialize();

      var data = await db.get('area');

      if (data != null) {
        var area = AreaModel.fromJson(data);
        return area.area;
      } else {
        return [];
      }
    } catch (e, st) {
      if (kDebugMode) {
        log('Get Area Json - Exception[e]: $e');
        log('Get Area Json - Exception[st]: $st');
      }
      rethrow;
    }
  }

  /// Shift

  static Future<List<Shift>> getShiftJson() async {
    try {
      final db = await initialize();

      var data = await db.get('shift');

      if (data != null) {
        var shift = ShiftModel.fromJson(data);
        return shift.shift;
      } else {
        return [];
      }
    } catch (e, st) {
      if (kDebugMode) {
        log('Get Shift Json - Exception[e]: $e');
        log('Get Shift Json - Exception[st]: $st');
      }
      rethrow;
    }
  }

  static Future<void> putShiftJson(ShiftModel shift) async {
    try {
      final db = await initialize();

      await db.put('shift', shift.toJson());
    } catch (e, st) {
      if (kDebugMode) {
        log('Put Shift Json - Exception[e]: $e');
        log('Put Shift Json - Exception[st]: $st');
      }
      rethrow;
    }
  }

  static Future<void> putCPLJson(CplModel cpl) async {
    try {
      final db = await initialize();

      await db.put('cpl', cpl.toJson());
    } catch (e, st) {
      if (kDebugMode) {
        log('Put CPL Json - Exception[e]: $e');
        log('Put CPL Json - Exception[st]: $st');
      }
      rethrow;
    }
  }

  static Future<List<Cpl>> getCPLJson() async {
    try {
      final db = await initialize();

      var data = await db.get('cpl');

      if (data != null) {
        var cpl = CplModel.fromJson(data);
        return cpl.cpl;
      } else {
        return [];
      }
    } catch (e, st) {
      if (kDebugMode) {
        log('Get CPL Json - Exception[e]: $e');
        log('Get CPL Json - Exception[st]: $st');
      }
      rethrow;
    }
  }

  static Future<void> putEquipmentJson(EquipmentModel equipment) async {
    try {
      final db = await initialize();

      await db.put('equipment', equipment.toJson());
    } catch (e, st) {
      if (kDebugMode) {
        log('Put Equipment Json - Exception[e]: $e');
        log('Put Equipment Json - Exception[st]: $st');
      }
      rethrow;
    }
  }

  static Future<List<Equipment>> getEquipmentJson() async {
    try {
      final db = await initialize();

      var data = await db.get('equipment');

      if (data != null) {
        var equipment = EquipmentModel.fromJson(data);
        return equipment.equipment;
      } else {
        return [];
      }
    } catch (e, st) {
      if (kDebugMode) {
        log('Get Equipment Json - Exception[e]: $e');
        log('Get Equipment Json - Exception[st]: $st');
      }
      rethrow;
    }
  }

  static Future<void> putNotificationJson(
      NotificationModel notification) async {
    try {
      final db = await initialize();

      await db.put('notification', notification.toJson());
    } catch (e, st) {
      if (kDebugMode) {
        log('Put Notification Json - Exception[e]: $e');
        log('Put Notification Json - Exception[st]: $st');
      }
      rethrow;
    }
  }

  static Future<List<Notification>> getNotificationJson() async {
    try {
      final db = await initialize();

      var data = await db.get('notification');

      if (data != null) {
        var notification = NotificationModel.fromJson(data);
        return notification.notification;
      } else {
        return [];
      }
    } catch (e, st) {
      if (kDebugMode) {
        log('Get Notification Json - Exception[e]: $e');
        log('Get Notification Json - Exception[st]: $st');
      }
      rethrow;
    }
  }

  static Future<void> putSpecialCPLJson(CplModel cpl) async {
    try {
      final db = await initialize();

      await db.put('cpl_special', cpl.toJson());
    } catch (e, st) {
      if (kDebugMode) {
        log('Put Special CPL Json - Exception[e]: $e');
        log('Put Special CPL Json - Exception[st]: $st');
      }
      rethrow;
    }
  }

  static Future<List<Cpl>> getSpecialCPLJson() async {
    try {
      final db = await initialize();

      var data = await db.get('cpl_special');

      if (data != null) {
        var cpl = CplModel.fromJson(data);
        return cpl.cpl;
      } else {
        return [];
      }
    } catch (e, st) {
      if (kDebugMode) {
        log('Get Special CPL Json - Exception[e]: $e');
        log('Get Special CPL Json - Exception[st]: $st');
      }
      rethrow;
    }
  }

  static Future<void> putPositionJson(List<Position> positions) async {
    try {
      final db = await initialize();

      if (positions.isNotEmpty) {
        PositionModel data = PositionModel(position: positions);
        await db.put('position', data.toJson());
      }
    } catch (e, st) {
      if (kDebugMode) {
        log('Put Position Json - Exception[e]: $e');
        log('Put Position Json - Exception[st]: $st');
      }
      rethrow;
    }
  }

  static Future<List<Position>> getPositionJson() async {
    try {
      final db = await initialize();

      var data = await db.get('position');

      if (data != null) {
        var position = PositionModel.fromJson(data);
        return position.position;
      } else {
        return [];
      }
    } catch (e, st) {
      if (kDebugMode) {
        log('Get Position Json - Exception[e]: $e');
        log('Get Position Json - Exception[st]: $st');
      }
      rethrow;
    }
  }

  static Future<void> putScheduleJson(List<Schedule> schedules) async {
    try {
      final db = await initialize();

      if (schedules.isNotEmpty) {
        ScheduleModel data = ScheduleModel(schedule: schedules);
        await db.put('schedule', data.toJson());
      }
    } catch (e, st) {
      if (kDebugMode) {
        log('Put Schedule Json - Exception[e]: $e');
        log('Put Schedule Json - Exception[st]: $st');
      }
      rethrow;
    }
  }

  static Future<List<Schedule>> getScheduleJson() async {
    try {
      final db = await initialize();

      var data = await db.get('schedule');

      if (data != null) {
        var schedule = ScheduleModel.fromJson(data);
        return schedule.schedule;
      } else {
        return [];
      }
    } catch (e, st) {
      if (kDebugMode) {
        log('Get Schedule Json - Exception[e]: $e');
        log('Get Schedule Json - Exception[st]: $st');
      }
      rethrow;
    }
  }

  static Future<void> delServiceJson() async {
    try {
      final db = await initialize();

      await db.delete('service');
    } catch (e, st) {
      if (kDebugMode) {
        log('Put Service Json - Exception[e]: $e');
        log('Put Service Json - Exception[st]: $st');
      }
      rethrow;
    }
  }

  static Future<void> putServiceJson(ServiceModel service) async {
    try {
      final db = await initialize();

      await db.put('service', service.toJson());
    } catch (e, st) {
      if (kDebugMode) {
        log('Put Service Json - Exception[e]: $e');
        log('Put Service Json - Exception[st]: $st');
      }
      rethrow;
    }
  }

  static Future<List<Service>> getServiceJson() async {
    try {
      final db = await initialize();

      var data = await db.get('service');

      if (data != null) {
        var service = ServiceModel.fromJson(data);
        return service.service;
      } else {
        return [];
      }
    } catch (e, st) {
      if (kDebugMode) {
        log('Get Service Json - Exception[e]: $e');
        log('Get Service Json - Exception[st]: $st');
      }
      rethrow;
    }
  }

  static Future<List<Service>> getServiceSpecialJobJson() async {
    try {
      final db = await initialize();

      var data = await db.get('service');

      if (data != null) {
        var service = ServiceModel.fromJson(data);
        return service.service;
      } else {
        return [];
      }
    } catch (e, st) {
      if (kDebugMode) {
        log('Get Service Json - Exception[e]: $e');
        log('Get Service Json - Exception[st]: $st');
      }
      rethrow;
    }
  }

  static Future<void> putJobJson(List<SpecialJob> jobs) async {
    try {
      final db = await initialize();

      if (jobs.isNotEmpty) {
        SpecialJobModel data = SpecialJobModel(specialJob: jobs);
        await db.put('job', data.toJson());
      }
    } catch (e, st) {
      if (kDebugMode) {
        log('Put SpecialJob Json - Exception[e]: $e');
        log('Put SpecialJob Json - Exception[st]: $st');
      }
      rethrow;
    }
  }

  static Future<List<SpecialJob>> getJobJson() async {
    try {
      final db = await initialize();

      var data = await db.get('job');

      if (data != null) {
        var job = SpecialJobModel.fromJson(data);
        return job.specialJob;
      } else {
        return [];
      }
    } catch (e, st) {
      if (kDebugMode) {
        log('Get SpecialJob Json - Exception[e]: $e');
        log('Get SpecialJob Json - Exception[st]: $st');
      }
      rethrow;
    }
  }

  static Future<void> putCPLAutoJson(CplModel cpl) async {
    try {
      final db = await initialize();

      await db.put('cpl_auto', cpl.toJson());
    } catch (e, st) {
      if (kDebugMode) {
        log('Put CPL Auto Json - Exception[e]: $e');
        log('Put CPL Auto Json - Exception[st]: $st');
      }
      rethrow;
    }
  }

  static Future<List<Cpl>> getCPLAutoJson() async {
    try {
      final db = await initialize();

      var data = await db.get('cpl_auto');

      if (data != null) {
        var cpl = CplModel.fromJson(data);
        return cpl.cpl;
      } else {
        return [];
      }
    } catch (e, st) {
      if (kDebugMode) {
        log('Get CPL Auto Json - Exception[e]: $e');
        log('Get CPL Auto Json - Exception[st]: $st');
      }
      rethrow;
    }
  }

  static Future<void> putEquipmentAutoJson(EquipmentModel equipment) async {
    try {
      final db = await initialize();

      await db.put('equipment_auto', equipment.toJson());
    } catch (e, st) {
      if (kDebugMode) {
        log('Put Equipment Auto Json - Exception[e]: $e');
        log('Put Equipment Auto Json - Exception[st]: $st');
      }
      rethrow;
    }
  }

  static Future<List<Equipment>> getEquipmentAutoJson() async {
    try {
      final db = await initialize();

      var data = await db.get('equipment_auto');

      if (data != null) {
        var equipment = EquipmentModel.fromJson(data);
        return equipment.equipment;
      } else {
        return [];
      }
    } catch (e, st) {
      if (kDebugMode) {
        log('Get Equipment Auto Json - Exception[e]: $e');
        log('Get Equipment Auto Json - Exception[st]: $st');
      }
      rethrow;
    }
  }

  static Future<void> putServiceAutoJson(ServiceModel service) async {
    try {
      final db = await initialize();

      await db.put('service_auto', service.toJson());
    } catch (e, st) {
      if (kDebugMode) {
        log('Put Service Auto Json - Exception[e]: $e');
        log('Put Service Auto Json - Exception[st]: $st');
      }
      rethrow;
    }
  }

  static Future<List<Service>> getServiceAutoJson() async {
    try {
      final db = await initialize();

      var data = await db.get('service_auto');

      if (data != null) {
        var service = ServiceModel.fromJson(data);
        return service.service;
      } else {
        return [];
      }
    } catch (e, st) {
      if (kDebugMode) {
        log('Get Service Auto Json - Exception[e]: $e');
        log('Get Service Auto Json - Exception[st]: $st');
      }
      rethrow;
    }
  }

  static Future<void> putTransactionJson(List<Transaction> trx) async {
    try {
      final db = await initialize();

      TransactionModel data = TransactionModel(transactions: trx);
      await db.put('transaction', data.toJson());
    } catch (e, st) {
      if (kDebugMode) {
        log('Put Transaction Json - Exception[e]: $e');
        log('Put Transaction Json - Exception[st]: $st');
      }
      rethrow;
    }
  }

  static Future<void> deleteTransactionJson() async {
    try {
      final db = await initialize();
      await db.delete('transaction');
    } catch (e, st) {
      if (kDebugMode) {
        log('Delete Transaction Json - Exception[e]: $e');
        log('Delete Transaction Json - Exception[st]: $st');
      }
      rethrow;
    }
  }

  static Future<TransactionModel> getTransactionJson() async {
    try {
      final db = await initialize();

      var data = await db.get('transaction');

      if (data != null) {
        var trx = TransactionModel.fromJson(data);
        return trx;
      } else {
        return const TransactionModel(transactions: []);
      }
    } catch (e, st) {
      if (kDebugMode) {
        log('Get Transaction Json - Exception[e]: $e');
        log('Get Transaction Json - Exception[st]: $st');
      }
      rethrow;
    }
  }

  static Future<void> putTransactionSpecialJobJson(
      List<Transaction> trx) async {
    try {
      final db = await initialize();

      TransactionModel data = TransactionModel(transactions: trx);
      await db.put('transaction_special', data.toJson());
    } catch (e, st) {
      if (kDebugMode) {
        log('Put Transaction Special Json - Exception[e]: $e');
        log('Put Transaction Special Json - Exception[st]: $st');
      }
      rethrow;
    }
  }

  static Future<TransactionModel> getTransactionSpecialJobJson() async {
    try {
      final db = await initialize();

      var data = await db.get('transaction_special');

      if (data != null) {
        var trx = TransactionModel.fromJson(data);
        return trx;
      } else {
        return const TransactionModel(transactions: []);
      }
    } catch (e, st) {
      if (kDebugMode) {
        log('Get Transaction Special Job Json - Exception[e]: $e');
        log('Get Transaction Special Job - Exception[st]: $st');
      }
      rethrow;
    }
  }

  static Future<void> deleteTableJson(String tableName) async {
    try {
      final db = await initialize();

      await db.delete(tableName);
    } catch (e, st) {
      if (kDebugMode) {
        log('Delete Table Json - Exception[e]: $e');
        log('Delete Table Json - Exception[st]: $st');
      }
      rethrow;
    }
  }
}
