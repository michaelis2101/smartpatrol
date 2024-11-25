import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_patrol/data/models/shift_model.dart';
import 'package:smart_patrol/data/provider/database_helper.dart';
import 'package:smart_patrol/utils/utils.dart';

part 'shift_event.dart';
part 'shift_state.dart';

class ShiftBloc extends Bloc<ShiftEvent, ShiftState> {
  ShiftBloc({ShiftState? initialState}) : super(const ShiftState()) {
    on<ImportShiftEvent>(_importShift);
    on<InitShiftEvent>(_initShift);
    on<CheckShiftTypeEvent>(_checkMyShift);
  }

  Future<void> _initShift(
      InitShiftEvent event, Emitter<ShiftState> emitter) async {
    //get data shift
    try {
      final user = await DatabaseProvider.getSignedUserJson();
      final shift = await DatabaseProvider.getShiftJson();
      if (shift.isNotEmpty) {
        emitter(state.copyWith(shifts: shift));
      }
    } catch (e, st) {
      if (kDebugMode) {
        log('Init Shift Exception[e] $e');
        log('Init Shift Exception[st] $st');
      }
    }
  }

  Future<void> _checkMyShift(
      CheckShiftTypeEvent event, Emitter<ShiftState> emitter) async {
    final shift = await DatabaseProvider.getShiftJson();
    DateTime currentTime = DateTime.now();

    if (shift.isNotEmpty) {
      DateTime startTime;
      for (var item in shift) {
        // if(item.beginHours.split(':').first)
        var firstClock = int.parse(item.beginHours.split(':').first);
        if (firstClock >= 20) {
          startTime = AppUtil.timeClockFormatToDateTimeStart(item.beginHours);
        } else {
          startTime = AppUtil.timeClockFormatToDateTime(item.beginHours);
        }
        DateTime endTime = AppUtil.timeClockFormatToDateTime(item.endHours);
        //jika start time hari sebelumnya maka datetime -1 day
        if (currentTime.isAfter(startTime) && currentTime.isBefore(endTime)) {
          //set shit
          try {
            var signedUser = await DatabaseProvider.getSignedUserJson();
            var myShift = item.name;
            log("my Shift $myShift");
            var user = signedUser?.copyWith(shift: myShift);
            await DatabaseProvider.putSignedUserJson(user!);
          } catch (e) {
            debugPrint('SetSettingShiftEvent $e');
          }
          return;
        }
      }
    }
  }

  Future<void> _importShift(
      ImportShiftEvent event, Emitter<ShiftState> emitter) async {
    try {
      final File? file = await AppUtil.readFile(['json']);
      if (file != null) {
        final jsonFile = await json.decode(file.readAsStringSync());
        ShiftModel shift = ShiftModel.fromJson(jsonFile);
        await DatabaseProvider.putShiftJson(shift);
        final data = await DatabaseProvider.getShiftJson();
        if (data.isNotEmpty) {
          emitter(state.copyWith(shifts: data));
          event.onSuccess();
        } else {
          event.onFailed('Daftar shift kosong');
        }
      } else {
        event.onFailed('Tidak ada file yang di import');
      }
    } catch (e, st) {
      if (kDebugMode) {
        log('Import Shift Exception[e]: $e');
        log('Import Shift Exception[st]: $st');
      }
      event.onFailed('Gagal mengimport file');
    }
  }
}
