import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:smart_patrol/features/blocs/eform/eform_bloc.dart';
import 'package:smart_patrol/features/blocs/shift/shift_bloc.dart';
import 'package:smart_patrol/features/screens/home/widget/empty_state.dart';
import 'package:smart_patrol/utils/styles/colors.dart';
import 'package:smart_patrol/utils/styles/text_styles.dart';
import 'package:smart_patrol/utils/utils.dart';

class InputShiftPage extends StatefulWidget {
  final EFormBloc eformBloc;
  const InputShiftPage({
    super.key,
    required this.eformBloc,
  });
  @override
  State<InputShiftPage> createState() => _InputShiftState();
}

class _InputShiftState extends State<InputShiftPage> {
  ShiftBloc bloc = ShiftBloc();

  @override
  void initState() {
    super.initState();
    bloc.add(const InitShiftEvent());
    bloc.add(const CheckShiftTypeEvent());
  }

  @override
  Widget build(BuildContext context) {
    String tdata = DateFormat("HH:mm").format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: containerToolbarDecoration,
        ),
        title: const Text(
          'Form Input Data Shoft',
          style: kToolbarHeader,
        ),
        leading: BackButton(
          color: Colors.white,
          onPressed: () {
            bloc.add(const InitShiftEvent());
            widget.eformBloc.add(const InitEFormEvent());
            Navigator.maybePop(context);
          },
        ),
      ),
      floatingActionButton: InkWell(
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: kGreen, borderRadius: BorderRadius.circular(50)),
            child: const Icon(Icons.folder),
          ),
          onTap: () {
            AppUtil.showLoading();
            bloc.add(ImportShiftEvent(
                onSuccess: () => Navigator.of(context).pop(),
                onFailed: (msg) {
                  Navigator.of(context).pop();
                  AppUtil.snackBar(message: msg);
                }));
          }),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 20, left: 20),
            child: Text(
              'Shift Form Input',
              style: TextStyle(color: kRichBlack, fontSize: 16),
            ),
          ),
          Align(
            child: Text(
              'Time $tdata',
              style: const TextStyle(color: kRichBlack, fontSize: 16),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 20),
            child: BlocBuilder<ShiftBloc, ShiftState>(
                bloc: bloc,
                builder: (context, state) {
                  int total = 0;
                  total = state.shifts.length;
                  return Text(
                    'Total Data: $total',
                    style: const TextStyle(color: kRichBlack, fontSize: 14),
                  );
                }),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: BlocBuilder<ShiftBloc, ShiftState>(
                bloc: bloc,
                builder: (context, state) {
                  int itemCount = 0;
                  itemCount = state.shifts.length;
                  if (itemCount > 0) {
                    return listItem(state: state, itemCount: itemCount);
                  } else {
                    return EmptyStateWidget(label: 'Shift');
                  }
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget listItem({required ShiftState state, required int itemCount}) =>
      ListView.builder(
        itemCount: itemCount,
        itemBuilder: (context, index) {
          String title = '', subtitle = '', beginH = '', endH = '';
          title = state.shifts[index].shiftId;
          subtitle = state.shifts[index].name;
          beginH = state.shifts[index].beginHours;
          endH = state.shifts[index].endHours;

          return Card(
            color: Colors.white,
            child: ListTile(
              title: Text(
                title,
                style: const TextStyle(fontSize: 14, color: kRichBlack),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Shift $subtitle",
                    style: const TextStyle(fontSize: 12, color: kBlueTeal),
                  ),
                  Text(
                    "Begin - End Hours : $beginH - $endH",
                    style: const TextStyle(fontSize: 12, color: kRedBlack),
                  ),
                ],
              ),
            ),
          );
        },
      );
}
