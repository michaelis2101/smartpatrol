import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smart_patrol/dummy/view/dummy_history_page.dart';
import 'package:smart_patrol/dummy/view/dummy_page.dart';
import 'package:smart_patrol/features/blocs/auth/auth_bloc.dart';
import 'package:smart_patrol/features/blocs/eform/eform_bloc.dart';
import 'package:smart_patrol/features/blocs/shift/shift_bloc.dart';
import 'package:smart_patrol/features/screens/eform/eform_page.dart';
// import 'package:smart_patrol/features/screens/history/history_page.dart';
import 'package:smart_patrol/features/screens/settings/settings_page.dart';
import 'package:smart_patrol/utils/styles/colors.dart';
import 'package:smart_patrol/utils/utils.dart';

import '../../../../utils/routes.dart';
import 'home_presenter_page.dart';

class MainHomePage extends StatefulWidget {
  const MainHomePage({super.key, required this.authBloc});
  final AuthBloc authBloc;

  @override
  State<MainHomePage> createState() => _MainHomePageState();
}

class _MainHomePageState extends State<MainHomePage> {
  final EFormBloc eformBloc = EFormBloc();
  final ShiftBloc shiftBloc = ShiftBloc();

  final List<BottomNavigationBarItem> _bottomNavBarItems = const [
    BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: 'Home',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.history),
      label: 'History',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.format_list_bulleted),
      label: 'E-Form',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.settings_outlined),
      label: 'Setting',
    ),
  ];

  late final List<Widget> _listWidget;

  final Widget svgIcon = SvgPicture.asset('assets/ico_svg/cellphone_nfc.svg',
      colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
      semanticsLabel: 'A red up arrow');

  @override
  void initState() {
    _listWidget = [
      HomePresenterPage(authBloc: widget.authBloc, eformBloc: eformBloc),
      // HistoryPage(authBloc: widget.authBloc, eformBloc: eformBloc),
      // const DummyPage(),
      DummyHistoryPage(authBloc: widget.authBloc, eformBloc: eformBloc),
      EformPage(kodeNfc: "", authBloc: widget.authBloc, eformBloc: eformBloc),
      SettingsPage(
        eformBloc: eformBloc,
        shiftBloc: shiftBloc,
      ),
    ];

    eformBloc.add(const InitEFormEvent());
    shiftBloc.add(const InitShiftEvent());
    shiftBloc.add(const CheckShiftTypeEvent());
    eformBloc.add(const GetListHistorySpecialJob(searchEquipment: ''));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => widget.authBloc,
      child: Scaffold(
        body: BlocBuilder<AuthBloc, AuthState>(
          bloc: widget.authBloc,
          builder: (context, state) => _listWidget[state.indexPage],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, nfcScanRoute,
                arguments: [widget.authBloc, eformBloc]);
          },
          backgroundColor: Colors.transparent,
          tooltip: 'Nfc',
          shape: RoundedRectangleBorder(
              side: const BorderSide(width: 3, color: Colors.white),
              borderRadius: BorderRadius.circular(100)),
          child: Container(
            width: 60,
            height: 60,
            decoration: buttonNFCDecoration,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: svgIcon,
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BlocBuilder<AuthBloc, AuthState>(
          bloc: widget.authBloc,
          builder: (context, state) => BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            unselectedItemColor: Colors.black,
            selectedItemColor: Colors.green.shade600,
            // selectedItemColor: kRedBlack,
            backgroundColor: Colors.white,
            currentIndex: state.indexPage,
            items: _bottomNavBarItems,
            onTap: (v) {
              if (v == 2) {
                if (state.signedUser?.level.toLowerCase() == "admin" ||
                    state.signedUser?.level.toLowerCase() == "administrator") {
                  widget.authBloc.add(ChangeMainPageEvent(index: v));
                } else {
                  AppUtil.snackBar(message: "Only Admin");
                  widget.authBloc.add(const ChangeMainPageEvent(index: 0));
                  return;
                }
              } else {
                widget.authBloc.add(ChangeMainPageEvent(index: v));
              }
            },
          ),
        ),
      ),
    );
  }
}
