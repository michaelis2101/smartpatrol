part of 'shift_bloc.dart';

class ShiftState extends Equatable {
  const ShiftState({this.shifts = const []});

  final List<Shift> shifts;

  ShiftState copyWith({List<Shift>? shifts}) {
    return ShiftState(shifts: shifts ?? this.shifts);
  }

  @override
  List<Object> get props => [shifts];
}
