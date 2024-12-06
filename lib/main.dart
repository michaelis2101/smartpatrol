import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:smart_patrol/dummy/view/dummy_history_page.dart';
import 'package:smart_patrol/features/blocs/auth/auth_bloc.dart';
import 'package:smart_patrol/features/blocs/eform/eform_bloc.dart';
import 'package:smart_patrol/features/screens/auth/init_page.dart';
import 'package:smart_patrol/features/screens/eform/input_eform.dart';
import 'package:smart_patrol/features/screens/eform/nfc_scan_page.dart';
import 'package:smart_patrol/features/screens/eform/warning_report.dart';
import 'package:smart_patrol/features/screens/settings/background_page.dart';
import 'package:smart_patrol/features/screens/settings/input_shift.dart';
import 'package:smart_patrol/utils/constants.dart';
import 'package:smart_patrol/utils/routes.dart';
import 'package:smart_patrol/utils/styles/colors.dart';
import 'package:smart_patrol/utils/styles/text_styles.dart';
import 'package:smart_patrol/utils/utils.dart';
import 'features/screens/about/about_page.dart';
import 'features/screens/auth/user_login_page.dart';
import 'features/screens/home/home_presenter/main_home_page.dart';
import 'features/screens/settings/profile_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppUtil.navigatorKey = GlobalKey<NavigatorState>();
  AppUtil.scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  isNfcAvailable = await NfcManager.instance.isAvailable();
  runApp(const MyApp());
}

/// Global flag if NFC is avalible
bool isNfcAvailable = false;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appName,
      navigatorKey: AppUtil.navigatorKey,
      scaffoldMessengerKey: AppUtil.scaffoldMessengerKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: false).copyWith(
        cardTheme: const CardTheme(
          surfaceTintColor: Colors.white,
        ),
        colorScheme: kColorScheme,
        primaryColor: kBlueTeal,
        scaffoldBackgroundColor: Colors.white,
        textTheme: kTextTheme,
      ),
      home: const InitScreen(),
      navigatorObservers: [routeObserver],
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case historyRoute:
            return MaterialPageRoute(
                builder: (_) => DummyHistoryPage(
                    authBloc: (settings.arguments as List)[0] as AuthBloc,
                    eformBloc: (settings.arguments as List)[1] as EFormBloc));
          case homeRoute:
            return MaterialPageRoute(
                builder: (_) =>
                    MainHomePage(authBloc: settings.arguments as AuthBloc));
          case loginRoute:
            return MaterialPageRoute(
                builder: (_) =>
                    UserLoginPage(bloc: settings.arguments as AuthBloc));
          case aboutRoute:
            return MaterialPageRoute(builder: (_) => const AboutPage());
          case settingBackgroundRoute:
            return MaterialPageRoute(builder: (_) => const BackgroundPage());
          case profileRoute:
            return MaterialPageRoute(builder: (_) => const ProfilePage());
          case nfcScanRoute:
            return MaterialPageRoute(
                builder: (_) => NfcScanPage(
                    authBloc: (settings.arguments as List)[0] as AuthBloc,
                    eformBloc: (settings.arguments as List)[1] as EFormBloc));
          case importShiftRoute:
            return MaterialPageRoute(
                builder: (_) => InputShiftPage(
                      eformBloc:
                          (settings.arguments as List).first as EFormBloc,
                    ));
          case importEformRoute:
            return MaterialPageRoute(
                builder: (_) => InputEformPage(
                    bloc: (settings.arguments as List).first,
                    type: (settings.arguments as List).last));
          case warningReportRoute:
            return MaterialPageRoute(
                builder: (_) => WarningReportPage(
                    args: settings.arguments as WarningReportArgs));
          default:
            return MaterialPageRoute(
              builder: (_) {
                return const Scaffold(
                  body: Center(
                    child: Text('Page not found :('),
                  ),
                );
              },
            );
        }
      },
    );
  }
}
