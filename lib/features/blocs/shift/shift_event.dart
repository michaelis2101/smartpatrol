part of 'shift_bloc.dart';

abstract class ShiftEvent extends Equatable {
  const ShiftEvent();
  @override
  List<Object> get props => [];
}

class ImportShiftEvent extends ShiftEvent {
  final Function onSuccess;
  final Function(String) onFailed;
  const ImportShiftEvent({required this.onSuccess, required this.onFailed});
}

class InitShiftEvent extends ShiftEvent {
  const InitShiftEvent();
}

class CheckShiftTypeEvent extends ShiftEvent {
  const CheckShiftTypeEvent();
}
