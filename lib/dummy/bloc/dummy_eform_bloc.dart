import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:smart_patrol/data/models/area_model.dart';
import 'package:smart_patrol/data/models/cpl_model.dart';
import 'package:smart_patrol/data/models/equipment_model.dart';
import 'package:smart_patrol/data/models/format_model.dart';
import 'package:smart_patrol/data/models/position_model.dart';
import 'package:smart_patrol/data/models/section_model.dart';
import 'package:smart_patrol/data/models/service_model.dart';
import 'package:smart_patrol/data/models/special_job_model.dart';
import 'package:smart_patrol/data/models/transaction_model.dart';
import 'package:smart_patrol/utils/enum.dart';

part 'dummy_eform_event.dart';
part 'dummy_eform_state.dart';

class DummyEformBloc extends Bloc<DummyEformEvent, DummyEformState> {
  DummyEformBloc() : super(DummyEformInitial()) {
    on<DummyEformEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
