import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_patrol/features/blocs/auth/auth_bloc.dart';
import 'package:smart_patrol/utils/assets.dart';
import 'package:smart_patrol/utils/image_asset.dart';
import 'package:smart_patrol/utils/routes.dart';
import 'package:smart_patrol/utils/utils.dart';

class InitScreen extends StatefulWidget {
  const InitScreen({super.key});

  @override
  State<InitScreen> createState() => _InitScreen();
}

class _InitScreen extends State<InitScreen> {
  late final AuthBloc bloc;

  @override
  void initState() {
    bloc = AuthBloc()..add(const GetLoginStatusEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      bloc: bloc,
      child: AppImage(
        ImageAssets.splash,
        width: AppUtil.width,
        height: AppUtil.height,
      ),
      listener: (context, state) {
        Future.delayed(const Duration(seconds: 3), () {
          if (state.status == AuthStatus.login) {
            Navigator.pushReplacementNamed(context, homeRoute, arguments: bloc);
          } else {
            Navigator.pushReplacementNamed(context, loginRoute,
                arguments: bloc);
          }
        });
      },
    );
  }
}
