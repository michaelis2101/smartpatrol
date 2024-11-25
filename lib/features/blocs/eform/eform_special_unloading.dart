import 'package:flutter/material.dart';
import 'package:smart_patrol/features/blocs/auth/auth_bloc.dart';
import 'package:smart_patrol/features/blocs/eform/eform_bloc.dart';

class EformSpecialUnloading extends StatefulWidget {
  const EformSpecialUnloading(
      {
        super.key,
        required this.kodeEquipment,
        required this.areaBloc,
        required this.serviceBloc,
        required this.authBloc
      });

  final EFormBloc areaBloc;
  final EFormBloc serviceBloc;
  final AuthBloc authBloc;
  final String kodeEquipment;

  @override
  State<EformSpecialUnloading> createState() => _EformSpecialUnloadingState();
}

class _EformSpecialUnloadingState extends State<EformSpecialUnloading> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
