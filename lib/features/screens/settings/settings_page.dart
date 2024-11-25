import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:smart_patrol/features/blocs/auth/auth_bloc.dart';
import 'package:smart_patrol/features/blocs/eform/eform_bloc.dart';
import 'package:smart_patrol/features/blocs/shift/shift_bloc.dart';
import 'package:smart_patrol/features/screens/home/widget/widget_toolbar_status_page.dart';
import 'package:smart_patrol/utils/constants.dart';
import 'package:smart_patrol/utils/enum.dart';
import 'package:smart_patrol/utils/routes.dart';
import 'package:smart_patrol/utils/styles/colors.dart';
import 'package:smart_patrol/utils/utils.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage(
      {super.key, required this.eformBloc, required this.shiftBloc});

  final EFormBloc eformBloc;
  final ShiftBloc shiftBloc;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

final ShiftBloc shiftBloc = ShiftBloc();
final AuthBloc authBloc = AuthBloc();
const textStyleHeader =
    TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: Colors.grey);
const textStyleSubtitleEform =
    TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black);
const textStyleSubtitle =
    TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black);
const textStyleSmall = TextStyle(color: Colors.grey, fontSize: 12);

class _SettingsPageState extends State<SettingsPage> {
  bool isSwitched = false;

  @override
  void initState() {
    authBloc.add(const GetLoginStatusEvent());
    widget.eformBloc.add(const InitEFormEvent());
    widget.shiftBloc.add(const InitShiftEvent());
    widget.shiftBloc.add(const CheckShiftTypeEvent());
    super.initState();
  }

  DateTime selectedDate = DateTime.now();
  @override
  Widget build(BuildContext context) {
    const tsRadio = TextStyle(color: Colors.black);
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: FlexibleSpaceBar(
          background: Container(
            decoration: containerToolbarDecoration,
            padding: const EdgeInsetsDirectional.only(top: 20),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    padding: const EdgeInsetsDirectional.only(top: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(left: 12),
                          child: Text(
                            settingMenu.toUpperCase(),
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        OfflineBuilder(
                            debounceDuration: Duration.zero,
                            connectivityBuilder: (
                              BuildContext context,
                              ConnectivityResult connectivity,
                              Widget child,
                            ) {
                              if (connectivity == ConnectivityResult.none) {
                                return const WidgetToolbarStatusPage(
                                    appName: appName,
                                    isOnline: false,
                                    showIconCalendar: false);
                              } else {
                                return child;
                              }
                            },
                            builder: (BuildContext context) {
                              return const WidgetToolbarStatusPage(
                                  appName: appName,
                                  isOnline: true,
                                  showIconCalendar: false);
                            }),
                      ],
                    ),
                  )
                ]),
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 12, left: 10, right: 10),
        child: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // ListTile(
                //   onTap: () => {},
                //   title: Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: const <Widget>[
                //       SizedBox(
                //         width: 270,
                //         child: Text(
                //           'Setting Jaringan',
                //           style: textStyleSubtitle,
                //         ),
                //       ),
                //       SizedBox(
                //         child: Padding(
                //           padding: EdgeInsets.only(top: 5, right: 6),
                //           child: Text(
                //             "switch untuk mengatur jaringan internet",
                //             style: textStyleSmall,
                //           ),
                //         ),
                //       )
                //     ],
                //   ),
                //   trailing: SizedBox(
                //     width: 20,
                //     child: Switch(
                //       value: isSwitched,
                //       onChanged: (value) {
                //         setState(() {
                //           isSwitched = value;
                //         });
                //       },
                //       activeTrackColor: Colors.lightGreenAccent,
                //       activeColor: Colors.green,
                //     ),
                //   ),
                // ),
                BlocBuilder<AuthBloc, AuthState>(
                  bloc: context.read<AuthBloc>(),
                  builder: (_, state) {
                    //== "approval" || state.signedUser?.level.toLowerCase() == "administrator"
                    if (state.signedUser!.level.toLowerCase().isNotEmpty) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Text(
                              "General",
                              style: textStyleHeader,
                            ),
                          ),
                          const Padding(
                              padding:
                                  EdgeInsetsDirectional.symmetric(vertical: 5)),
                          ListTile(
                            onTap: () => {
                              Navigator.pushNamed(context, importEformRoute,
                                  arguments: [
                                    widget.eformBloc,
                                    EFormType.standard
                                  ])
                            },
                            title: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(
                                  width: 240,
                                  child: Text(
                                    'Eform Standard Data Synchronization',
                                    style: textStyleSubtitleEform,
                                  ),
                                ),
                                SizedBox(
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 5, right: 6),
                                    child: Text(
                                      "tap to import eform data",
                                      style: textStyleSmall,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            trailing: BlocBuilder<EFormBloc, EFormState>(
                                bloc: widget.eformBloc,
                                builder: (context, state) =>
                                    state.cpls.isNotEmpty &&
                                            state.services.isNotEmpty &&
                                            state.equipments.isNotEmpty &&
                                            state.areas.isNotEmpty
                                        ? const SizedBox(
                                            width: 70,
                                            child: Text(
                                              'exist ',
                                              style: TextStyle(
                                                  color: Colors.green,
                                                  fontSize: 10),
                                            ),
                                          )
                                        : const SizedBox(
                                            width: 70,
                                            child: Text(
                                              'no data ',
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 10),
                                            ),
                                          )),
                          ),

                          //shift
                          ListTile(
                            onTap: () => {
                              Navigator.pushNamed(context, importShiftRoute,
                                  arguments: [
                                    widget.eformBloc,
                                  ])
                            },
                            title: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(
                                  width: 240,
                                  child: Text(
                                    'Data Shift',
                                    style: textStyleSubtitleEform,
                                  ),
                                ),
                                SizedBox(
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 5, right: 6),
                                    child: Text(
                                      "tap to import shift",
                                      style: textStyleSmall,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            trailing: BlocBuilder<ShiftBloc, ShiftState>(
                                bloc: widget.shiftBloc,
                                builder: (context, state) =>
                                    state.shifts.isNotEmpty
                                        ? const SizedBox(
                                            width: 70,
                                            child: Text(
                                              'exist ',
                                              style: TextStyle(
                                                  color: Colors.green,
                                                  fontSize: 10),
                                            ),
                                          )
                                        : const SizedBox(
                                            width: 70,
                                            child: Text(
                                              'no data ',
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 10),
                                            ),
                                          )),
                          ),
                          Row(children: <Widget>[
                            Expanded(
                              child: Container(
                                  margin: const EdgeInsets.only(
                                      left: 2.0, right: 2.0),
                                  child: const Divider(
                                    color: Colors.black,
                                    height: 20,
                                  )),
                            )
                          ]),
                        ],
                      );
                    } else {
                      return const Text("-");
                    }
                  },
                ),
                ListTile(
                  onTap: () => {
                    _selectDate(context)
                    // Navigator.pushNamed(context, importEformRoute,arguments: [widget.eformBloc, EFormType.autonomous])
                  },
                  title: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        width: 240,
                        child: Text(
                          'Set Tanggal Patrol',
                          style: textStyleSubtitleEform,
                        ),
                      ),
                      SizedBox(
                        child: Padding(
                          padding: EdgeInsets.only(top: 5, right: 6),
                          child: Text(
                            "tap untuk mengatur tanggal\ntanggal ini hanya untuk mengecek data patrol sebelumnya",
                            style: textStyleSmall,
                          ),
                        ),
                      )
                    ],
                  ),
                  trailing: BlocBuilder<EFormBloc, EFormState>(
                      bloc: widget.eformBloc,
                      builder: (context, state) => state.tglPatrol.isEmpty
                          ? SizedBox(
                              width: 70,
                              child: Text(
                                '${AppUtil.defaultTimeFormatCustom(selectedDate, "yyyy-MM-dd")} ',
                                style: const TextStyle(
                                    color: kGreenPrimary, fontSize: 10),
                              ),
                            )
                          : SizedBox(
                              width: 70,
                              child: Text(
                                state.tglPatrol,
                                style: const TextStyle(
                                    color: Colors.green, fontSize: 10),
                              ),
                            )),
                ),
                // ListTile(
                //   onTap: () => {
                //     Navigator.pushNamed(context, importEformRoute,
                //         arguments: [widget.eformBloc, EFormType.special])
                //   },
                //   title: const Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: <Widget>[
                //       SizedBox(
                //         width: 240,
                //         child: Text(
                //           'Sinkronisasi Data Eform Spesial Job',
                //           style: textStyleSubtitleEform,
                //         ),
                //       ),
                //       SizedBox(
                //         child: Padding(
                //           padding: EdgeInsets.only(top: 5, right: 6),
                //           child: Text(
                //             "tap untuk mengimport data",
                //             style: textStyleSmall,
                //           ),
                //         ),
                //       )
                //     ],
                //   ),
                //   trailing: BlocBuilder<EFormBloc, EFormState>(
                //       bloc: widget.eformBloc,
                //       builder: (context, state) => state.specialJobCpl.isEmpty &&
                //           state.specialJobPosition.isEmpty &&
                //           state.specialJobForm.isEmpty
                //           ? const SizedBox(
                //         width: 70,
                //         child: Text(
                //           'belum ada ',
                //           style: TextStyle(color: Colors.red, fontSize: 10),
                //         ),
                //       )
                //           : const SizedBox(
                //         width: 70,
                //         child: Text(
                //           'sudah ada ',
                //           style:
                //           TextStyle(color: Colors.green, fontSize: 10),
                //         ),
                //       )),
                // ),

                const Padding(
                  padding: EdgeInsets.only(top: 6.0, bottom: 6.0),
                  child: Text(
                    'Settings Account',
                    style: textStyleHeader,
                  ),
                ),
                // ListTile(
                //   onTap: () {
                //     showDialog(
                //         context: context,
                //         builder: (BuildContext ctx) {
                //           return AlertDialog(
                //             backgroundColor: Colors.white,
                //             title: const Text(
                //               "Choose Shift",
                //               style: tsRadio,
                //             ),
                //             actions: [
                //               ElevatedButton(
                //                   onPressed: () {
                //                     Navigator.of(ctx).pop();
                //                   },
                //                   child: const Text(
                //                     "Save",
                //                     style: TextStyle(color: Colors.white),
                //                   )),
                //             ],
                //             content: SizedBox(
                //               height: 170.0,
                //               child: BlocBuilder<AuthBloc, AuthState>(
                //                 bloc: context.read<AuthBloc>(),
                //                 builder: (_, state) {
                //                   return Column(
                //                     mainAxisAlignment: MainAxisAlignment.start,
                //                     children: <Widget>[
                //                       Theme(
                //                         data: ThemeData(
                //                           unselectedWidgetColor: Colors.black,
                //                         ),
                //                         child: RadioListTile(
                //                           value: 1,
                //                           title: const Text(
                //                             "Shift 1",
                //                             style: tsRadio,
                //                           ),
                //                           onChanged: (val) {
                //                             context.read<AuthBloc>().add(
                //                                 const SetSettingShiftEvent(
                //                                     shift: "1"));
                //                           },
                //                           activeColor: Colors.green,
                //                           groupValue: state.signedUser?.shift,
                //                           // selected: state == 1,
                //                         ),
                //                       ),
                //                       Theme(
                //                         data: ThemeData(
                //                           unselectedWidgetColor: Colors.black,
                //                         ),
                //                         child: RadioListTile(
                //                           value: 2,
                //                           // selected: state == 2,
                //                           title: const Text("Shift 2",
                //                               style: tsRadio),
                //                           onChanged: (val) {
                //                             context.read<AuthBloc>().add(
                //                                 const SetSettingShiftEvent(
                //                                     shift: "2"));
                //                           },
                //                           activeColor: Colors.green,
                //                           groupValue: state.signedUser?.shift,
                //                         ),
                //                       ),
                //                       Theme(
                //                         data: ThemeData(
                //                           unselectedWidgetColor: Colors.black,
                //                         ),
                //                         child: RadioListTile(
                //                           value: 3,
                //                           // selected: state == 3,
                //                           title: const Text("Shift 3",
                //                               style: tsRadio),
                //                           onChanged: (val) {
                //                             context.read<AuthBloc>().add(
                //                                 const SetSettingShiftEvent(
                //                                     shift: "3"));
                //                           },
                //                           activeColor: Colors.green,
                //                           groupValue: state.signedUser?.shift,
                //                         ),
                //                       ),
                //                     ],
                //                   );
                //                 },
                //               ),
                //             ),
                //           );
                //         });
                //   },
                //   title: const Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: <Widget>[
                //       SizedBox(
                //         width: 240,
                //         child: Text(
                //           'Shift Settings',
                //           style: textStyleSubtitle,
                //         ),
                //       ),
                //       SizedBox(
                //         child: Padding(
                //           padding: EdgeInsets.only(top: 5, right: 6),
                //           child: Text(
                //             "tap to change shift",
                //             style: textStyleSmall,
                //           ),
                //         ),
                //       )
                //     ],
                //   ),
                //   trailing: SizedBox(width: 50, child: shiftSection()),
                // ),
                ListTile(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext ctx) {
                        final teCtrl = TextEditingController();
                        return AlertDialog(
                          title: const Text('Input Shift Stage'),
                          content: TextField(
                            controller: teCtrl,
                            keyboardType: TextInputType.number,
                            autofocus: true,
                            decoration:
                                const InputDecoration(hintText: 'Stage (x)'),
                          ),
                          actions: [
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.of(ctx).pop();
                                },
                                child: const Text(
                                  "Cancel",
                                  style: TextStyle(color: Colors.white),
                                )),
                            ElevatedButton(
                                onPressed: () {
                                  var patrol =
                                      int.tryParse(teCtrl.value.text) ?? 0;
                                  if (patrol > 0) {
                                    context.read<AuthBloc>().add(
                                        SetSettingPatrolEvent(patrol: patrol));
                                  }
                                  Navigator.of(ctx).pop();
                                },
                                child: const Text(
                                  "Save",
                                  style: TextStyle(color: Colors.white),
                                )),
                          ],
                        );
                      },
                    );
                  },
                  title: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        width: 240,
                        child: Text(
                          'Stage Patrol Settings',
                          style: textStyleSubtitle,
                        ),
                      ),
                      SizedBox(
                        child: Padding(
                          padding: EdgeInsets.only(top: 5, right: 6),
                          child: Text(
                            "tap to change patrol stages",
                            style: textStyleSmall,
                          ),
                        ),
                      )
                    ],
                  ),
                  trailing: SizedBox(width: 50, child: tahapPatrolSection()),
                ),
                ListTile(
                  onTap: () => {Navigator.pushNamed(context, profileRoute)},
                  title: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        width: 240,
                        child: Text(
                          'Profile',
                          style: textStyleSubtitle,
                        ),
                      ),
                      SizedBox(
                        child: Padding(
                          padding: EdgeInsets.only(top: 5, right: 6),
                          child: Text(
                            "tap to view profile",
                            style: textStyleSmall,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                ListTile(
                  onTap: () => {Navigator.pushNamed(context, aboutRoute)},
                  title: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        width: 240,
                        child: Text(
                          'About',
                          style: textStyleSubtitle,
                        ),
                      ),
                      SizedBox(
                        child: Padding(
                          padding: EdgeInsets.only(top: 5, right: 6),
                          child: Text(
                            "tap to see about the application",
                            style: textStyleSmall,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                ListTile(
                  onTap: () =>
                      {Navigator.pushNamed(context, settingBackgroundRoute)},
                  title: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        width: 240,
                        child: Text(
                          'Background',
                          style: textStyleSubtitle,
                        ),
                      ),
                      SizedBox(
                        child: Padding(
                          padding: EdgeInsets.only(top: 5, right: 6),
                          child: Text(
                            "tap untuk mengatur background",
                            style: textStyleSmall,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                ListTile(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext ctx) {
                        final teCtrl = TextEditingController();
                        return AlertDialog(
                          title: const Text('Input Url Server'),
                          content: TextField(
                            controller: teCtrl,
                            keyboardType: TextInputType.number,
                            autofocus: true,
                            decoration:
                            const InputDecoration(hintText: 'http://(x)'),
                          ),
                          actions: [
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.of(ctx).pop();
                                },
                                child: const Text(
                                  "Cancel",
                                  style: TextStyle(color: Colors.white),
                                )),
                            ElevatedButton(
                                onPressed: () {
                                  var url_servers = teCtrl.value.text;
                                  if (url_servers != '') {
                                    context.read<AuthBloc>().add(
                                        SetSettingUrlServerEvent(url_server: url_servers));
                                  }
                                  Navigator.of(ctx).pop();
                                },
                                child: const Text(
                                  "Save",
                                  style: TextStyle(color: Colors.white),
                                )),
                          ],
                        );
                      },
                    );
                  },
                  title: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        width: 240,
                        child: Text(
                          'Url Server',
                          style: textStyleSubtitle,
                        ),
                      ),
                      SizedBox(
                        child: Padding(
                          padding: EdgeInsets.only(top: 5, right: 6),
                          child: Text(
                            "tap untuk mengatur url server",
                            style: textStyleSmall,
                          ),
                        ),
                      )
                    ],
                  ),
                  trailing: SizedBox(width: 190, child: urlServerSection()),
                ),
                ListTile(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext ctx) {
                        final teCtrl = TextEditingController();
                        return AlertDialog(
                          title: const Text('Input Api ID'),
                          content: TextField(
                            controller: teCtrl,
                            keyboardType: TextInputType.number,
                            autofocus: true,
                            decoration:
                            const InputDecoration(hintText: 'ex : diskosongin'),
                          ),
                          actions: [
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.of(ctx).pop();
                                },
                                child: const Text(
                                  "Cancel",
                                  style: TextStyle(color: Colors.white),
                                )),
                            ElevatedButton(
                                onPressed: () {
                                  var api_id = teCtrl.value.text;
                                  if (api_id != '') {
                                    context.read<AuthBloc>().add(
                                        SetApiKeyEvent(api_id: api_id));
                                  }
                                  Navigator.of(ctx).pop();
                                },
                                child: const Text(
                                  "Save",
                                  style: TextStyle(color: Colors.white),
                                )),
                          ],
                        );
                      },
                    );
                  },
                  title: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        width: 240,
                        child: Text(
                          'Api ID',
                          style: textStyleSubtitle,
                        ),
                      ),
                      SizedBox(
                        child: Padding(
                          padding: EdgeInsets.only(top: 5, right: 6),
                          child: Text(
                            "tap untuk mengatur api id",
                            style: textStyleSmall,
                          ),
                        ),
                      )
                    ],
                  ),
                  trailing: SizedBox(width: 190, child: apiKeySection()),
                ),
                Row(children: <Widget>[
                  Expanded(
                    child: Container(
                        margin: const EdgeInsets.only(left: 2.0, right: 2.0),
                        child: const Divider(
                          color: Colors.black,
                          height: 20,
                        )),
                  )
                ]),
                ListTile(
                  onTap: () {
                    AppUtil.showLoading();
                    context
                        .read<AuthBloc>()
                        .add(LogOutUserEvent(onFailed: (msg) {
                          Navigator.of(context).pop();
                          AppUtil.snackBar(message: msg);
                        }, onSuccess: () {
                          Navigator.of(context).pop();
                          Navigator.pushNamedAndRemoveUntil(context, loginRoute,
                              (Route<dynamic> route) => false,
                              arguments: context.read<AuthBloc>());
                        }));
                  },
                  title: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        width: 240,
                        child: Text(
                          'Logout',
                          style: textStyleSubtitle,
                        ),
                      ),
                      SizedBox(
                        child: Padding(
                          padding: EdgeInsets.only(top: 5, right: 6),
                          child: Text(
                            "tap Untuk keluar dari aplikasi",
                            style: textStyleSmall,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ]),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: kBlueAccent, // <-- SEE HERE
              onPrimary: Colors.white, // <-- SEE HERE
              onSurface: kGreen, // <-- SEE HERE
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      var dateParse = AppUtil.defaultTimeFormatCustom(picked, "yyyy-MM-dd");
      widget.eformBloc.add(SetDatePatrol(tglPatrol: dateParse));
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Widget tahapPatrolSection() => BlocBuilder<AuthBloc, AuthState>(
      bloc: context.read<AuthBloc>(),
      builder: (context, state) => Text(
            '${state.signedUser!.patrol}x',
            style: const TextStyle(color: kTextBlue, fontSize: 14),
          ));

  Widget urlServerSection() => BlocBuilder<AuthBloc, AuthState>(
      bloc: context.read<AuthBloc>(),
      builder: (context, state) => Text(
        '${state.signedUser!.urlServer}',
        style: const TextStyle(color: kTextBlue, fontSize: 14),
      ));

  Widget apiKeySection() => BlocBuilder<AuthBloc, AuthState>(
      bloc: context.read<AuthBloc>(),
      builder: (context, state) => Text(
        '${state.signedUser!.api_id}',
        style: const TextStyle(color: kTextBlue, fontSize: 14),
      ));

  Widget shiftSection() => BlocBuilder<AuthBloc, AuthState>(
        bloc: authBloc,
        builder: (context, state) => SizedBox(
          child: state.signedUser?.shift != null
              ? Text(
                  'Shift ${state.signedUser?.shift}',
                  style: const TextStyle(color: kTextBlue, fontSize: 14),
                )
              : const Text(
                  'Belum diatur',
                  style: TextStyle(color: kTextBlue, fontSize: 11),
                ),
        ),
      );
}
