import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:smart_patrol/data/models/equipment_model.dart';
import 'package:smart_patrol/data/models/history_model.dart';
import 'package:smart_patrol/data/models/transaction_model.dart';
import 'package:smart_patrol/features/blocs/auth/auth_bloc.dart';
import 'package:smart_patrol/features/blocs/eform/eform_bloc.dart';
import 'package:smart_patrol/features/blocs/shift/shift_bloc.dart';
import 'package:smart_patrol/features/screens/eform/eform_page.dart';
import 'package:smart_patrol/features/screens/home/widget/empty_state.dart';
import 'package:smart_patrol/features/screens/home/widget/widget_toolbar_status_page.dart';
import 'package:smart_patrol/utils/constants.dart';
import 'package:smart_patrol/utils/enum.dart';
import 'package:smart_patrol/utils/routes.dart';
import 'package:smart_patrol/utils/styles/colors.dart';
import 'package:smart_patrol/utils/utils.dart';

import '../../../../utils/assets.dart';

class HomePresenterPage extends StatefulWidget {
  const HomePresenterPage(
      {super.key, required this.authBloc, required this.eformBloc});

  final AuthBloc authBloc;
  final EFormBloc eformBloc;

  @override
  State<HomePresenterPage> createState() => _HomePresenterPageState();
}

class _HomePresenterPageState extends State<HomePresenterPage> {
  ValueNotifier<String> clock =
      ValueNotifier(AppUtil.defaultTimeFormat(DateTime.now()));
  final ShiftBloc shiftBloc = ShiftBloc();
  final textStyle =
      const TextStyle(color: Colors.black, fontWeight: FontWeight.bold);
  final textStyleSmall = const TextStyle(color: Colors.black, fontSize: 12);
  final textStyleBig = const TextStyle(
      color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold);
  String? selectedTipeDocument;

  @override
  void initState() {
    Timer.periodic(const Duration(seconds: 1),
        (t) => clock.value = AppUtil.defaultTimeFormat(DateTime.now()));

    widget.authBloc.add(const GetLoginStatusEvent());
    shiftBloc.add(const CheckShiftTypeEvent());
    widget.eformBloc.add(const GetTransactionHistoryByFormatEvent(
        filterFormat: 'All', search: ''));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Image.asset(
              'assets/img/logoitasoft2020white.png',
              fit: BoxFit.contain,
              // height: 50,
              // width: 50,
              scale: 1.5,
            ),
          ),
          title: Container(
            // padding: const EdgeInsets.only(left: 12),
            child: Text(
              appName.toUpperCase(),
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
          ),
          actions: [
            OfflineBuilder(
                debounceDuration: Duration.zero,
                connectivityBuilder: (
                  BuildContext context,
                  ConnectivityResult connectivity,
                  Widget child,
                ) {
                  final bool connected =
                      connectivity != ConnectivityResult.none;
                  String infoStatus = connected ? 'Online' : 'Offline';
                  Color infoStatusColor = connected ? kGreyLight : kGreen;
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
          centerTitle: true,
          // backgroundColor: LinearGradient(colors: [
          //   kBlueTealPrimary,
          //   kGreenPrimary,
          // ]),
          backgroundColor: Colors.transparent,
          elevation: 0,
          flexibleSpace: Container(
            decoration: containerToolbarDecoration,
          )
          // backgroundColor: Colors.transparent,
          // elevation: 0,
          // flexibleSpace: Container(
          //   decoration: containerToolbarDecoration,
          //   padding: const EdgeInsetsDirectional.only(top: 45),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       Row(
          //         crossAxisAlignment: CrossAxisAlignment.center,
          //         mainAxisAlignment: MainAxisAlignment.start,
          //         children: [
          //           //logo itasoft
          //           // Padding(
          //           //   padding: const EdgeInsets.only(bottom: 8.0, left: 8),
          //           //   child: Container(
          //           //       // borderRadius: BorderRadius.circular(8),
          //           //       width: 64,
          //           //       child: Image.asset(
          //           //         'assets/img/logoitasoft2020white.png',
          //           //       )),
          //           // ),
          //           // Container(
          //           //   padding: const EdgeInsets.only(left: 12),
          //           //   child: Text(
          //           //     appName.toUpperCase(),
          //           //     style: const TextStyle(
          //           //         color: Colors.white,
          //           //         fontSize: 16,
          //           //         fontWeight: FontWeight.bold),
          //           //   ),
          //           // ),
          //         ],
          //       ),
          //       // OfflineBuilder(
          //       //     debounceDuration: Duration.zero,
          //       //     connectivityBuilder: (
          //       //       BuildContext context,
          //       //       ConnectivityResult connectivity,
          //       //       Widget child,
          //       //     ) {
          //       //       final bool connected =
          //       //           connectivity != ConnectivityResult.none;
          //       //       String infoStatus = connected ? 'Online' : 'Offline';
          //       //       Color infoStatusColor = connected ? kGreyLight : kGreen;
          //       //       if (connectivity == ConnectivityResult.none) {
          //       //                 return const WidgetToolbarStatusPage(
          //       //             appName: appName,
          //       //             isOnline: false,
          //       //             showIconCalendar: false);
          //       //       } else {
          //       //         return child;
          //       //       }
          //       //     },
          //       //     builder: (BuildContext context) {
          //       //       return const WidgetToolbarStatusPage(
          //       //           appName: appName,
          //       //           isOnline: true,
          //       //           showIconCalendar: false);
          //       //     }),

          //       //  const Row(
          //       //   children: [
          //       //     WidgetToolbarStatusPage(appName, true)
          //       //   ],
          //       // )
          //     ],
          // ),
          // ),
          ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Container(color: Colors.white),
            SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    buildHeaderHome(),
                    buildUserInfo(),
                    buildWarningComponent(),
                    buildContentList()
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

//background image diganti disini
  Widget buildHeaderHome() {
    //const textStyle = TextStyle(fontSize: 16, fontWeight: FontWeight.bold);
    return BlocBuilder<AuthBloc, AuthState>(
      bloc: widget.authBloc,
      builder: (context, state) {
        final ImageProvider myImageProvider =
            state.signedUser?.backgroundCover != null
                ? (state.signedUser!.backgroundCover.isNotEmpty
                    ? Image.memory(
                            base64Decode(state.signedUser!.backgroundCover),
                            fit: BoxFit.cover)
                        .image
                    //bg gedung disini
                    : Image.asset(
                        ImageAssets.bgGedungAndWayang,
                        fit: BoxFit.cover,
                      ).image)
                // : Image.asset(ImageAssets.bgCover, fit: BoxFit.cover).image)
                : Image.asset(ImageAssets.bgCover, fit: BoxFit.cover).image;
        return Container(
          height: 180,
          decoration: BoxDecoration(
            image: DecorationImage(image: myImageProvider, fit: BoxFit.cover),
            shape: BoxShape.rectangle,
            color: kBlueTeal,
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(0.4),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    margin: const EdgeInsets.all(8.0),
                    alignment: Alignment.center,
                    width: 130,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment(0.8, 1),
                        colors: <Color>[
                          kGreenPrimary,
                          kBlueTealPrimary,
                          // Color(0x94713d37),
                          // Color(0x9bda2f4e),
                          // Color(0xff3c0912),
                          // Color(0xff8f66bd),
                          // Color(0xffc1bb2d),
                        ],
                        tileMode: TileMode.mirror,
                      ),
                      borderRadius: BorderRadius.circular(15.0),
                      shape: BoxShape.rectangle,
                      // color: Colors.white
                    ),
                    padding: const EdgeInsetsDirectional.symmetric(
                        horizontal: 8, vertical: 5),
                    child: ValueListenableBuilder(
                      valueListenable: clock,
                      builder: (context, time, child) => Text(
                          '${time.split(',').last.split('-').last} WIB',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      //tanggal
                      Container(
                        padding: const EdgeInsetsDirectional.symmetric(
                            horizontal: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ValueListenableBuilder(
                              valueListenable: clock,
                              builder: (context, time, child) => Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Text(
                                    time.split(',').last.split(' ').first,
                                    style: const TextStyle(
                                        // color: Colors.black,

                                        fontSize: 30,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Container(
                                    padding:
                                        const EdgeInsetsDirectional.symmetric(
                                            horizontal: 8, vertical: 10),
                                    child: Text(
                                        time
                                            .split(',')
                                            .last
                                            .split(' ')[1]
                                            .split('-')
                                            .first,
                                        style: const TextStyle(
                                            // color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        // color: Colors.amber,
                        padding: const EdgeInsetsDirectional.symmetric(
                            horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            ValueListenableBuilder(
                              valueListenable: clock,
                              builder: (context, time, child) => Text(
                                time.split(',').first,
                                style: const TextStyle(
                                    // color: Colors.black,
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            departmentSection(),
                            shiftSection(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget departmentSection() => BlocBuilder<AuthBloc, AuthState>(
        bloc: context.read<AuthBloc>(),
        builder: (context, state) => SizedBox(
            child: Text(
          state.signedUser!.department,
          style: const TextStyle(
              // color: Colors.black,
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold),
        )),
      );

  Widget shiftSection() => BlocBuilder<AuthBloc, AuthState>(
        bloc: context.read<AuthBloc>(),
        builder: (context, state) => SizedBox(
          child: state.signedUser!.shift.isNotEmpty
              ? Text(
                  state.signedUser!.shift.contains("Shift")
                      ? state.signedUser!.shift
                      : 'Shift ${state.signedUser!.shift}',
                  style: const TextStyle(
                      // color: Colors.black,
                      // color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                )
              : const Text(
                  'Not Managed',
                  style: TextStyle(
                      // color: Colors.black,
                      // color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.bold),
                ),
        ),
      );

  Widget buildToolbar() => Container(
        decoration: const BoxDecoration(
          color: kBlueTeal,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 12),
                  child: Text(
                    appName.toUpperCase(),
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.calendar_month),
                      tooltip: 'Schedule',
                      onPressed: () {},
                    ),
                    // const WidgetToolbarStatusPage(appName, true)
                  ],
                )
              ],
            )
          ],
        ),
      );

  Widget statusConnectNetwork() => Row(
        children: [
          Container(
              padding: const EdgeInsets.only(right: 12),
              child:
                  const Text('Online', style: TextStyle(color: Colors.white))),
          Container(
            padding: const EdgeInsets.only(right: 12),
            height: 12,
            width: 12,
            decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(color: Color(0xFFFFFFFF)),
                  left: BorderSide(color: Color(0xFFFFFFFF)),
                  right: BorderSide(color: Color(0xFFFFFFFF)),
                  bottom: BorderSide(color: Color(0xFFFFFFFF)),
                ),
                shape: BoxShape.circle, //making box to circle
                color: kGreen),
          ),
          Container(
            padding: const EdgeInsets.only(right: 12),
          )
        ],
      );

  Widget buildContentList() => Container(
        padding: const EdgeInsetsDirectional.all(6.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(left: 8.0, top: 12.0),
              child: const Text(
                'Schedule Patrol',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            ),
            buildViewPerShiftDummy()
            // buildViewPerShift()
          ],
        ),
      );

  Widget buildViewPerShiftDummy() {
    List<Map<String, dynamic>> data = [
      {
        'wing': '2',
        'shift': 'Shift 1',
        'ruangan': 'Office Area 1',
        'security': "Andrianto Prasetyo",
        'schedule': 'Daily',
        'start_date': "2024-10-11",
        'end_date': "2024-10-12",
      },
      {
        'wing': '2',
        'shift': 'Shift 1',
        'ruangan': 'Office Area 1',
        'security': "Andrianto Prasetyo",
        'schedule': 'Daily',
        'start_date': "2024-10-11",
        'end_date': "2024-10-12",
      },
      {
        'wing': '2',
        'shift': 'Shift 1',
        'ruangan': 'Office Area 1',
        'security': "Andrianto Prasetyo",
        'schedule': 'Daily',
        'start_date': "2024-10-11",
        'end_date': "2024-10-12",
      },
      {
        'wing': '2',
        'shift': 'Shift 1',
        'ruangan': 'Office Area 1',
        'security': "Andrianto Prasetyo",
        'schedule': 'Daily',
        'start_date': "2024-10-11",
        'end_date': "2024-10-12",
      },
      {
        'wing': '2',
        'shift': 'Shift 1',
        'ruangan': 'Office Area 1',
        'security': "Andrianto Prasetyo",
        'schedule': 'Daily',
        'start_date': "2024-10-11",
        'end_date': "2024-10-12",
      },
    ];

    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.45,
      child: ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          var pat = data[index];

          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Container(
              width: MediaQuery.of(context).size.width,
              // height: 150,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 1),
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.black),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Wing ${pat['wing']}",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text("Shift : ${pat['shift']}",
                        style: const TextStyle(fontSize: 15)),
                    Text("Ruangan : ${pat['ruangan']}",
                        style: const TextStyle(fontSize: 15)),
                    Text("Security : ${pat['security']}",
                        style: const TextStyle(fontSize: 15)),
                    Text("Schedule : ${pat['schedule']}",
                        style: const TextStyle(fontSize: 15)),
                    Text("Start Date : ${pat['start_date']}",
                        style: const TextStyle(fontSize: 15)),
                    Text("End Data : ${pat['end_date']}",
                        style: const TextStyle(fontSize: 15)),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildViewPerShift() => BlocBuilder<AuthBloc, AuthState>(
        bloc: widget.authBloc,
        builder: (context, authState) => BlocBuilder<EFormBloc, EFormState>(
          bloc: widget.eformBloc,
          builder: (context, state) {
            var data = state.transactionsHistoryManual.transactions
                .where((e) => e.textValue.isNotEmpty)
                .toList();
            var equipments = data.isEmpty
                ? <String>[]
                : data.map((e) => e.codeEquipment).toSet().toList();
            var listEquipment = <Equipment>[];

            for (var i in state.equipments) {
              for (var j in equipments) {
                if (i.kodeEquipment == j) {
                  listEquipment.add(i);
                }
              }
            }

            if (listEquipment.isEmpty) {
              return EmptyStateWidget(label: 'History');
            }

            return SizedBox(
              height: 300,
              child: ListView.builder(
                  physics: const ScrollPhysics(),
                  itemCount: listEquipment.length,
                  shrinkWrap: true,
                  itemBuilder: (context, i) {
                    var namaCpl = state.cpls.isEmpty
                        ? ''
                        : state.cpls
                            .firstWhere(
                                (e) => e.kodeCpl == listEquipment[i].kodeCpl)
                            .namaCpl;

                    var tipeCpl = state.cpls.isEmpty
                        ? ''
                        : state.cpls
                            .firstWhere(
                                (e) => e.kodeCpl == listEquipment[i].kodeCpl)
                            .formatTipe;

                    var userId = data
                        .where((e) =>
                            e.codeEquipment == listEquipment[i].kodeEquipment)
                        .map((e) => e.userId)
                        .toSet()
                        .toList();

                    var warning = data
                        .where((e) =>
                            e.codeEquipment == listEquipment[i].kodeEquipment &&
                            e.isWarning())
                        .length;

                    var shift = data
                        .where((e) =>
                            e.codeEquipment == listEquipment[i].kodeEquipment)
                        .map((e) => e.shift)
                        .toSet()
                        .toList();

                    var created = data
                        .where((e) =>
                            e.codeEquipment == listEquipment[i].kodeEquipment)
                        .map((e) => e.dateCreated)
                        .toSet()
                        .toList();

                    var to = state.equipments.isEmpty
                        ? ''
                        : state.equipments
                            .firstWhere((e) =>
                                e.kodeEquipment ==
                                listEquipment[i].kodeEquipment)
                            .to;
                    Map<String, List<String>> listMapTo = {};
                    if (to.isNotEmpty) {
                      var checkTo = (jsonDecode(jsonDecode(to))).toString();
                      if (checkTo.isNotEmpty) {
                        var lengthTo =
                            (jsonDecode(jsonDecode(to)) as List).length;
                        if (jsonDecode(jsonDecode(to)).toString().isNotEmpty) {
                          for (var i = 0; i < lengthTo; i++) {
                            var itemTo = (jsonDecode(jsonDecode(to))[i]
                                    as Map<String, dynamic>)
                                .cast();
                            var mkeys = itemTo.keys.first;
                            var indexs = mkeys;
                            if (itemTo[indexs][0] != "") {
                              var item = itemTo[indexs];
                              List<String> icastStr = item.cast<String>();
                              listMapTo[indexs] = icastStr;
                            }
                          }
                        }
                      }
                    }
                    var namaOp = authState.localUsers.isEmpty
                        ? ''
                        : authState.localUsers
                            .firstWhere((e) => e.nik == userId.first)
                            .name;

                    final HistoryModel item = HistoryModel(
                        uuid: '',
                        template: '',
                        cplName: namaCpl,
                        cplCode: '',
                        equipmentName: listEquipment[i].namaEquipment,
                        equipmentCode: listEquipment[i].kodeEquipment,
                        opName: namaOp,
                        tipeCpl: tipeCpl,
                        dateCreated:
                            '${AppUtil.defaultTimeFormat(DateTime.parse(created.last), regular: true)} WIB',
                        shift: shift.first,
                        isSync: 0,
                        warning: warning);

                    return Card(
                      color: Colors.white,
                      child: ListTile(
                        onTap: () {
                          if (tipeCpl == "Special") {
                            if ((jsonDecode(jsonDecode(to)))
                                .toString()
                                .isEmpty) {
                              EformController.serviceBloc.add(
                                  GetServiceByEquipmentEvent(
                                      kodeEquipment: item.equipmentCode,
                                      areaState: state,
                                      steps: ""));
                              // EformController.serviceBloc.add(
                              //     GetServiceSpecialUnloadingStep(
                              //         steps: 0,
                              //         kodeEquipment:
                              //             listEquipment[i].kodeEquipment,
                              //         areaState: state));
                              EformController.equipmentName.value =
                                  item.equipmentName;
                              EformController.eqpTo = {};
                              EformController.equipmentCode.value =
                                  item.equipmentCode;
                              EformController.indexEquipment.value = i + 1;
                              EformController.fromHomePage.value = fromHomePage;
                              EformController.indexPage.value =
                                  eformStepEquipment;
                              EformController.equipmentCollection.value = [];
                              widget.authBloc
                                  .add(const ChangeMainPageEvent(index: 2));
                            } else {
                              EformController.eqpTo = listMapTo;
                              EformController.serviceBloc.add(
                                  GetServiceByEquipmentEvent(
                                      kodeEquipment: item.equipmentCode,
                                      areaState: state,
                                      steps: ""));
                              // EformController.serviceBloc.add(
                              //     GetServiceSpecialUnloadingStep(
                              //         steps: 0,
                              //         kodeEquipment:
                              //         listEquipment[i].kodeEquipment,
                              //         areaState: state));
                              EformController.equipmentName.value =
                                  item.equipmentName;
                              // EformController.eqpTo = {};
                              EformController.equipmentCode.value =
                                  item.equipmentCode;
                              EformController.indexEquipment.value = i + 1;
                              EformController.fromHomePage.value = fromHomePage;
                              EformController.indexPage.value =
                                  eformStepSpecialJob;
                              EformController.equipmentCollection.value = [];
                              widget.authBloc
                                  .add(const ChangeMainPageEvent(index: 2));
                            }
                          } else {
                            EformController.fromHomePage.value = fromHomePage;
                            EformController.serviceBloc.add(
                                GetServiceByEquipmentEvent(
                                    kodeEquipment: item.equipmentCode,
                                    areaState: state,
                                    steps: ""));

                            EformController.equipmentName.value =
                                item.equipmentName;
                            EformController.equipmentCode.value =
                                item.equipmentCode;
                            EformController.indexEquipment.value = i + 1;
                            EformController.indexPage.value = eformStepService;
                            EformController.equipmentCollection.value = [];
                            widget.authBloc
                                .add(const ChangeMainPageEvent(index: 2));
                          }
                        },
                        leading: Container(
                          padding: const EdgeInsets.only(right: 12),
                          height: 16,
                          width: 16,
                          decoration: BoxDecoration(
                              border: const Border(
                                top: BorderSide(color: Color(0xFFFFFFFF)),
                                left: BorderSide(color: Color(0xFFFFFFFF)),
                                right: BorderSide(color: Color(0xFFFFFFFF)),
                                bottom: BorderSide(color: Color(0xFFFFFFFF)),
                              ),
                              shape: BoxShape.circle, //making box to circle
                              color: item.warning > 0 ? Colors.red : kGreen),
                        ),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              width: 200,
                              child: Text(
                                item.equipmentName,
                                style: textStyle,
                              ),
                            ),
                            SizedBox(
                              child: Text(
                                'OP : ${item.opName}',
                                style: textStyleSmall,
                              ),
                            ),
                            SizedBox(
                              child: Text(
                                'Shift ${item.shift}',
                                style: textStyleSmall,
                              ),
                            ),
                            Row(
                              children: <Widget>[
                                Icon(
                                  Icons.warning_sharp,
                                  color: item.warning > 0
                                      ? Colors.red
                                      : Colors.blue,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    '${item.warning}',
                                    style: textStyleSmall,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        trailing: SizedBox(
                          width: 90,
                          child: Text(
                            item.dateCreated,
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w100),
                          ),
                        ),
                      ),
                    );
                  }),
            );
          },
        ),
      );
  String? selectedValue;

  Widget buildUserInfo() => Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsetsDirectional.symmetric(
                    horizontal: 9, vertical: 4),
                child: BlocBuilder<AuthBloc, AuthState>(
                  bloc: widget.authBloc,
                  builder: (context, state) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('${state.signedUser?.name.capitalizeFirst()}',
                              style: textStyleBig),
                        ],
                      ),
                      Text('${state.signedUser?.jabatan}', style: textStyle),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // Container(
          //   margin: const EdgeInsets.all(8),
          //   decoration: BoxDecoration(
          //       borderRadius: BorderRadius.circular(8),
          //       border: Border.all(color: Colors.grey)),
          //   padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          //   child: DropdownButtonHideUnderline(
          //     child: DropdownButton(
          //       isExpanded: true,
          //       hint: const Text('Select Document',
          //           style: TextStyle(color: Colors.grey)),
          //       style: const TextStyle(color: Colors.black),
          //       dropdownColor: Colors.white,
          //       value: selectedTipeDocument,
          //       items: const [
          //         DropdownMenuItem(value: 'FIELD', child: Text("FIELD")),
          //         DropdownMenuItem(value: 'DCS', child: Text("DCS")),
          //         DropdownMenuItem(value: "QUALITY", child: Text("QUALITY")),
          //       ],
          //       onChanged: (value) {
          //         setState(() {
          //           selectedTipeDocument = value;
          //         });
          //       },
          //     ),
          //   ),
          // )
        ],
      );

  Widget buildWarningComponent() {
    const textStyleWarn = TextStyle(
        fontSize: 14, fontWeight: FontWeight.normal, color: Colors.grey);
    const warningStyle =
        TextStyle(color: kRedDark, fontWeight: FontWeight.bold, fontSize: 14);
    return BlocBuilder<EFormBloc, EFormState>(
      bloc: widget.eformBloc,
      builder: (context, state) => state.cpls.isNotEmpty &&
              state.services.isNotEmpty &&
              state.equipments.isNotEmpty &&
              state.areas.isNotEmpty
          ? Container(
              padding: const EdgeInsetsDirectional.symmetric(horizontal: 3),
              child: Column(children: [
                Container(
                  padding: const EdgeInsetsDirectional.symmetric(
                      horizontal: 5, vertical: 3),
                  child: Stack(children: [
                    Card(
                      margin: const EdgeInsets.all(0),
                      elevation: 6.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      shadowColor: kGreen.withOpacity(1.0),
                      color: Colors.white,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withOpacity(0.1),
                              offset: const Offset(
                                  0, -2), // Set the offset to negative y-axis
                              blurRadius: 3,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Expanded(
                                child: ClipRRect(
                                  child: Icon(
                                    Icons.check_circle,
                                    color: kGreen,
                                    size: 40,
                                  ),
                                ),
                              ),
                              Expanded(
                                  flex: 5,
                                  child: Container(
                                    padding: const EdgeInsets.only(bottom: 4.0),
                                    child: const Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'The E-Form file has been set',
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ],
                                    ),
                                  ))
                            ]),
                      ),
                    ),
                  ]),
                ),
              ]),
            )
          : InkWell(
              child: Container(
                padding: const EdgeInsetsDirectional.symmetric(horizontal: 3),
                child: Column(children: [
                  Container(
                    padding: const EdgeInsetsDirectional.symmetric(
                        horizontal: 5, vertical: 3),
                    child: Stack(children: [
                      Card(
                        margin: const EdgeInsets.all(0),
                        elevation: 6.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        shadowColor: Colors.red.withOpacity(1.0),
                        color: Colors.white,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.white.withOpacity(0.1),
                                offset: const Offset(
                                    0, -2), // Set the offset to negative y-axis
                                blurRadius: 3,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Expanded(
                                  child: ClipRRect(
                                    child: Icon(
                                      Icons.close,
                                      color: kRedDark,
                                      size: 40,
                                    ),
                                  ),
                                ),
                                Expanded(
                                    flex: 5,
                                    child: Container(
                                      padding:
                                          const EdgeInsets.only(bottom: 4.0),
                                      child: const Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                              padding:
                                                  EdgeInsets.only(right: 10),
                                              child: Text(
                                                'WARNING',
                                                style: warningStyle,
                                              )),
                                          Text(
                                            'You Have Not Managed Your E-Form File',
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                          Text(
                                            'Tap Here To Manage E-Form Files',
                                            style: textStyleWarn,
                                          )
                                        ],
                                      ),
                                    ))
                              ]),
                        ),
                      ),
                    ]),
                  ),
                ]),
              ),
              onTap: () {
                // if (widget.authBloc.state.signedUser?.level.toLowerCase() ==
                //         "admin" ||
                //     widget.authBloc.state.signedUser?.level.toLowerCase() ==
                //         "administrator") {
                Navigator.pushNamed(context, importEformRoute,
                    arguments: [widget.eformBloc, EFormType.standard]);
                // } else {
                //   AppUtil.snackBar(message: 'Only Administrator');
                // }
              },
            ),
    );
  }
}
