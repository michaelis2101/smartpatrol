import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_patrol/features/blocs/auth/auth_bloc.dart';
import 'package:smart_patrol/features/screens/settings/settings_page.dart';
import 'package:smart_patrol/utils/styles/colors.dart';
import 'package:smart_patrol/utils/styles/text_styles.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthBloc bloc = AuthBloc();

  @override
  void initState() {
    bloc.add(const GetLoginStatusEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: containerToolbarDecoration,
        ),
        title: const Text(
          'Profil',
          style: kToolbarHeader,
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(8.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(10.0),
                color: kGreen,
                child: const Text("PRODUCTION",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w700)),
              ),
              const Padding(padding: EdgeInsets.only(top: 20.0)),
              Container(
                padding: const EdgeInsetsDirectional.all(10.0),
                child: BlocBuilder<AuthBloc, AuthState>(
                  bloc: bloc,
                  builder: (context, state) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Usermame', style: textStyleSubtitle),
                      Text(state.signedUser?.username ?? '-',
                          style: textStyleHeader),
                      const Padding(
                        padding: EdgeInsets.only(top: 12.0),
                        child: Text('Full Name', style: textStyleSubtitle),
                      ),
                      Text(state.signedUser?.name ?? '-',
                          style: textStyleHeader),
                      const Padding(
                        padding: EdgeInsets.only(top: 12.0),
                        child: Text('Departement', style: textStyleSubtitle),
                      ),
                      Text(state.signedUser?.department ?? '-',
                          style: textStyleHeader),
                      // const Padding(
                      //   padding: EdgeInsets.only(top: 12.0),
                      //   child: Text('Jabatan', style: textStyleSubtitle),
                      // ),
                      // Text(state.signedUser?.jabatan ?? '-',
                      //     style: textStyleHeader),
                      const Padding(
                        padding: EdgeInsets.only(top: 12.0),
                        child: Text('Level', style: textStyleSubtitle),
                      ),
                      Text((state.signedUser?.level ?? '-').toUpperCase(),
                          style: textStyleHeader),
                      const Padding(
                        padding: EdgeInsets.only(top: 12.0),
                        child: Text('NIK', style: textStyleSubtitle),
                      ),
                      Text(state.signedUser?.nik ?? '-',
                          style: textStyleHeader),
                    ],
                  ),
                ),
              )
            ]),
      ),
    );
  }
}
