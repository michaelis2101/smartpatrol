import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_patrol/data/models/format_model.dart';
import 'package:smart_patrol/data/models/transaction_model.dart';
import 'package:smart_patrol/data/provider/database_helper.dart';
import 'package:smart_patrol/features/blocs/auth/auth_bloc.dart';
import 'package:smart_patrol/features/blocs/eform/eform_bloc.dart';
import 'package:smart_patrol/features/screens/home/widget/empty_state.dart';
import 'package:smart_patrol/features/screens/settings/settings_page.dart';
import 'package:smart_patrol/utils/styles/colors.dart';
import 'package:smart_patrol/utils/utils.dart';

class DummyHistoryPage extends StatefulWidget {
  final AuthBloc authBloc;
  final EFormBloc eformBloc;
  const DummyHistoryPage(
      {super.key, required this.authBloc, required this.eformBloc});

  @override
  State<DummyHistoryPage> createState() => _DummyHistoryPageState();
}

class _DummyHistoryPageState extends State<DummyHistoryPage> {
  final srchCont = TextEditingController();

  List<DropdownMenuItem> formats = [];

  // Future<void> getUserJson

  void getFormat() async {
    formats = [
      const DropdownMenuItem(
        value: 'All',
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'All',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    ];

    var formatsList = widget.eformBloc.state.formats;

    print(formatsList);

    if (formats.isNotEmpty) {
      for (var format in formatsList) {
        formats.add(DropdownMenuItem<String>(
            value: format.id,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                format.kodeFormat,
                style: const TextStyle(color: Colors.white),
              ),
            )));
      }
    }
  }

  @override
  void initState() {
    super.initState();

    try {
      widget.eformBloc.add(const CheckTransactionEvent());
      widget.eformBloc.add(const InitEFormEvent());
      // widget.eformBloc.add(const SetFormatForDropdown());
    } catch (e) {
      print(e);
    } finally {
      getFormat();
    }
  }

  @override
  void dispose() {
    srchCont.dispose();
    super.dispose();
  }

  String? selectedFormat = 'All';

  @override
  Widget build(BuildContext context) {
    // final historyBloc = context.read<EFormBloc>();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Dummy History Page',
            style: textStyleHeader.copyWith(color: Colors.white),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: Container(
              color: Colors.white,
              child: const TabBar(
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorColor: kRedDark,
                  indicatorWeight: 3,
                  tabs: [
                    Tab(
                      child: Text(
                        "Data",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    Tab(
                      child: Text(
                        "Room",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ]),
            ),
          ),
          actions: [
            PopupMenuButton(
              onSelected: (value) async {
                // print(value);
                final user = await DatabaseProvider.getSignedUserJson();
                var nik = user?.nik; //uid;
                var shift = user?.shift;
                var patrol = user?.patrol;
                var urlServer = user?.urlServer;
                var departement = user?.department;
                var api_id = user?.api_id;
                var name = user?.name;
                var uName = user?.username;
                if (value == 1) {
                  print(user);
                  // print(nik);
                  // print(shift);
                  // print(patrol);
                  // print(urlServer);
                  // print(departement);
                  // print(api_id);
                  // print(name);
                  // print(uName);

                  print('Sync Data');
                  // widget.eformBloc.add(SyncTransactionEvent(
                  //     userId: nik!,
                  //     uName: uName!,
                  //     nik: nik,
                  //     nama: name!,
                  //     department: departement!,
                  //     shift: shift!,
                  //     patrol: patrol!,
                  //     urlServer: urlServer!,
                  //     api_id: api_id!));
                } else {
                  print('Delete Data');
                  widget.eformBloc.add(DeleteAllTransactionEvent(
                      userId: nik!, shift: shift!, patrol: patrol!));
                }
              },
              icon: const Icon(
                Icons.more_vert,
                color: Colors.white,
              ),
              // splashRadius: 200,
              color: Colors.white,
              itemBuilder: (context) {
                return const [
                  PopupMenuItem(
                    value: 1,
                    child: Text(
                      'Sync Data',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  PopupMenuItem(
                    value: 2,
                    child: Text(
                      'Delete All Transaction',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ];
              },
            )
            // IconButton(
            //   icon: const Icon(
            //     Icons.more_horiz_rounded,
            //     color: Colors.white,
            //   ),
            //   onPressed: () {
            //     // widget.authBloc.add(const AuthLogoutEvent());

            //   },
            // ),
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            textfieldSearch(),
            labelDropDown(),
            dropdownFormat(),
            Expanded(
              child: TabBarView(children: [
                listFloorWidget(),
                listRoomWidget(),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget listRoomWidget() {
    return BlocBuilder<EFormBloc, EFormState>(
      bloc: widget.eformBloc,
      builder: (context, state) {
        List<Transaction> data = state.transactionsHistoryManual.transactions;

        if (state is EFormLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (data.isEmpty) {
          return Center(
              child: EmptyStateWidget(
            label: 'History',
          ));
          // return const Center(child: Text("No transaction data yet"));
        } else {
          Map<String, String> uniqueRooms =
              data.fold<Map<String, String>>({}, (map, trx) {
            map[trx.codeEquipment] = trx.codeEquipmentName;
            return map;
          });

          return ListView.builder(
            itemCount: uniqueRooms.length,
            itemBuilder: (context, index) {
              var keys = uniqueRooms.keys.toList();
              var key = keys[index];

              var trxForRoom =
                  data.where((trx) => trx.codeEquipment == key).toList();

              bool hasNegativeStatus = trxForRoom.any((trx) {
                var valueOption = trx.textValue;
                // Define negative meanings (e.g., "No", "ABNORMAL", etc.)
                return valueOption == "No" || valueOption == "ABNORMAL";
              });

              return ListTile(
                title: Text(
                  "$key (${uniqueRooms[key]})",
                  style: const TextStyle(color: Colors.black),
                ),
                leading: hasNegativeStatus
                    ? const Icon(Icons.warning,
                        color:
                            Colors.red) // Show warning if negative status found
                    : null, // No icon if no negative status
              );

              // return ListTile(
              //   title: Text(
              //     "$key (${uniqueRooms[key]})",
              //     style: const TextStyle(color: Colors.black),
              //   ),
              // );
            },
          );
        }
      },
    );
  }

  Widget textfieldSearch() => SizedBox(
        // height: 50,
        width: AppUtil.width,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: TextField(
            style: const TextStyle(color: Colors.black),
            decoration: const InputDecoration(
                label: Text('Search'),
                labelStyle: TextStyle(color: Colors.black),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                hintText: "Search here",
                hintStyle: TextStyle(color: Colors.black),
                suffixIcon: Icon(Icons.search)),
            controller: srchCont,
          ),
        ),
      );

  Widget labelDropDown() => const Padding(
        padding: EdgeInsets.only(left: 15.0, bottom: 5),
        child: Text(
          'Filter By Format',
          style: TextStyle(color: Colors.black, fontSize: 14),
        ),
      );

  Widget listFloorWidget() {
    return BlocBuilder<EFormBloc, EFormState>(
      bloc: widget.eformBloc,
      builder: (context, state) {
        List<Transaction> data = state.transactionsHistoryManual.transactions;
        print("Data length : ${data.length}");

        if (state is EFormLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (data.isEmpty) {
          return Center(
              child: EmptyStateWidget(
            label: 'History',
          ));
          // return const Center(child: Text("No transaction data yet"));
        } else {
          Map<String, String> uniqueFloors =
              data.fold<Map<String, String>>({}, (map, trx) {
            map[trx.codeCpl] = trx.codeCplName;
            return map;
          });
          return ListView.builder(
            itemCount: uniqueFloors.length,
            itemBuilder: (context, index) {
              var keys = uniqueFloors.keys.toList();
              var key = keys[index];
              return ListTile(
                title: Text(
                  "$key (${uniqueFloors[key]})",
                  style: const TextStyle(color: Colors.black),
                ),
              );
            },
          );
          // return SizedBox(
          //   width: AppUtil.width,
          //   height: AppUtil.height - 400,
          //   child: ListView.builder(
          //     itemCount: data.length,
          //     itemBuilder: (context, index) {
          //       var trx = data[index];
          //       return ListTile(
          //         title: Text(
          //           trx.codeCpl,
          //           // trx.codeEquipment,
          //           // trx.codeEquipmentName,
          //           // trx.serviceName,
          //           style: TextStyle(color: Colors.black),
          //         ),
          //       );
          //     },
          //   ),
          // );
        }
      },
    );
  }

  Widget dropdownFormat() {
    // String? selectedFormat = 'All';
    return SizedBox(
        height: 50,
        width: AppUtil.width,
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: DropdownButtonHideUnderline(
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(
                      color: kRedBlack,
                      width: 3,
                    ),
                    // color: Colors.red,
                    color: kRedBlack,
                    borderRadius: BorderRadius.circular(10)),
                child: DropdownButton(
                  style: const TextStyle(color: Colors.black),
                  // style: const TextStyle(color: Colors.blue),
                  icon: const Icon(
                    Icons.arrow_drop_down_sharp,
                    color: Colors.white,
                  ),
                  items: formats,
                  value: selectedFormat,
                  onChanged: (value) {
                    setState(() {
                      selectedFormat = value;
                    });

                    print(selectedFormat);
                  },
                ),
              ),
            )));
  }
}

// Column(
//                   children: [
//                     Expanded(child: listFloorWidget()),
//                     // SizedBox(
//                     //   height: 50,
//                     //   width: AppUtil.width,
//                     //   child: ElevatedButton(
//                     //       onPressed: () {
//                     //         EFormBloc().add(const CheckTransactionEvent());
//                     //       },
//                     //       child: const Text("Test")),
//                     // ),
//                     // const SizedBox(
//                     //   height: 20,
//                     // ),
//                     // SizedBox(
//                     //   height: 50,
//                     //   width: AppUtil.width,
//                     //   child: ElevatedButton(
//                     //       onPressed: () {
//                     //         DatabaseProvider.deleteTransactionJson();
//                     //       },
//                     //       child: const Text("delete")),
//                     // ),
//                   ],
//                 ),