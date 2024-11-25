import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_patrol/data/models/user_model.dart';
import 'package:smart_patrol/features/blocs/auth/auth_bloc.dart';
import 'package:smart_patrol/utils/assets.dart';
import 'package:smart_patrol/utils/image_asset.dart';
import 'package:smart_patrol/utils/routes.dart';
import 'package:smart_patrol/utils/styles/colors.dart';
import 'package:smart_patrol/utils/utils.dart';

class UserLoginPage extends StatefulWidget {
  const UserLoginPage({super.key, required this.bloc});

  final AuthBloc bloc;

  @override
  State<UserLoginPage> createState() => _UserLoginPage();
}

class _UserLoginPage extends State<UserLoginPage> {
  final TextEditingController usernameField = TextEditingController(),
      passwordField = TextEditingController();
  AuthBloc blocAuth = AuthBloc();

  @override
  void initState() {
    super.initState();
    blocAuth.add(const GetLocalUsersEvent());
    widget.bloc.add(const GetLocalUsersEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          AppImage(
            ImageAssets.bgGedung,
            // ImageAssets.bgLogin,
            width: AppUtil.width,
            height: AppUtil.height,
          ),
          BlocBuilder<AuthBloc, AuthState>(
              bloc: widget.bloc,
              builder: (context, state) => Column(
                    children: [
                      const SizedBox(height: 65),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 50),
                        child: AppImage(
                          ImageAssets.logoItasoft,
                          height: 70,
                        ),
                      ),
                      const SizedBox(height: 50),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 50),
                        child: _LoginTextField(
                            enable: state.localUsers.isNotEmpty,
                            radius: const BorderRadius.only(
                                topLeft: Radius.circular(5),
                                topRight: Radius.circular(5)),
                            controller: usernameField,
                            hint: 'Username/Email',
                            icon: Icons.person),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 50),
                        child: _LoginTextField(
                            enable: state.localUsers.isNotEmpty,
                            radius: const BorderRadius.only(
                                bottomLeft: Radius.circular(5),
                                bottomRight: Radius.circular(5)),
                            controller: passwordField,
                            hint: 'Password',
                            icon: Icons.lock,
                            obscureText: true),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 50),
                        child: _LoginButton(
                          onPressed: () => authenticateUser(state.localUsers),
                          buttonColor: kBlueItasoft,
                          // buttonColor: kRedBlack,
                          child: const Text(
                            'Log In',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
                      /*
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 25, horizontal: 50),
                        child: Text(
                          'Atau',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 50),
                        child: _LoginButton(
                          onPressed: () {
                            AppUtil.snackBar(message: 'Masih dalam tahap pengembangan');
                          },
                          buttonColor: kGreen,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.fingerprint, color: Colors.white),
                              SizedBox(width: 10),
                              Text(
                                'SIDIK JARI',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      */
                      const SizedBox(height: 10),
                      if (state.localUsers.isEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 50),
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(3)),
                            margin: EdgeInsets.zero,
                            color: Colors.white,
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 4),
                              child: Row(
                                children: [
                                  Icon(Icons.close, color: Colors.red),
                                  SizedBox(width: 15),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'WARNING!',
                                        style: TextStyle(
                                            color: Colors.red, fontSize: 12),
                                      ),
                                      Text(
                                        'You have not set up the User File',
                                        style: TextStyle(
                                            color: textBlack, fontSize: 12),
                                      ),
                                      Text(
                                        'Tap the File settings button below',
                                        style: TextStyle(
                                            color: kGreyLight, fontSize: 10),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      const SizedBox(height: 70),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 25),
                          child: InkWell(
                            onTap: () => getJsonFile(),
                            child: const Text(
                              'Pengaturan File User',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 14),
                            ),
                          ),
                        ),
                      )
                    ],
                  ))
        ],
      ),
    );
  }

  Future<void> getJsonFile() async {
    AppUtil.showLoading();
    widget.bloc.add(GetLocalUsersFromJsonEvent(onSuccess: () {
      Navigator.of(context).pop();
    }, onFailed: (msg) {
      Navigator.of(context).pop();
      AppUtil.snackBar(message: msg);
    }));
  }

  void authenticateUser(List<User> localUsers) {
    if (widget.bloc.isClosed) {
      if (localUsers.isNotEmpty) {
        AppUtil.showLoading();
        blocAuth.add(AuthenticateUserEvent(
            username: usernameField.value.text,
            password: passwordField.value.text,
            onFailed: (msg) {
              Navigator.of(context).pop();
              AppUtil.snackBar(message: msg, textColor: Colors.white);
            },
            onSuccess: () {
              Navigator.of(context).pop();
              Navigator.pushReplacementNamed(context, homeRoute,
                  arguments: blocAuth);
            }));
      }
    } else {
      if (localUsers.isNotEmpty) {
        AppUtil.showLoading();
        widget.bloc.add(AuthenticateUserEvent(
            username: usernameField.value.text,
            password: passwordField.value.text,
            onFailed: (msg) {
              Navigator.of(context).pop();
              AppUtil.snackBar(message: msg);
            },
            onSuccess: () {
              Navigator.of(context).pop();
              Navigator.pushReplacementNamed(context, homeRoute,
                  arguments: widget.bloc);
            }));
      }
    }
  }
}

class _LoginButton extends ElevatedButton {
  _LoginButton({super.onPressed, super.child, required Color buttonColor})
      : super(
          style: ButtonStyle(
            backgroundColor: MaterialStatePropertyAll<Color>(buttonColor),
            minimumSize:
                const MaterialStatePropertyAll<Size>(Size(double.infinity, 41)),
          ),
        );
}

class _LoginTextField extends StatefulWidget {
  final TextEditingController controller;
  final BorderRadius radius;
  final String hint;
  final IconData icon;
  final bool obscureText;
  final bool enable;

  const _LoginTextField(
      {required this.radius,
      required this.controller,
      required this.hint,
      required this.icon,
      required this.enable,
      this.obscureText = false});

  @override
  State<_LoginTextField> createState() => _LoginTextFieldState();
}

class _LoginTextFieldState extends State<_LoginTextField> {
  final _obscureNotifier = ValueNotifier<bool>(true);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _obscureNotifier,
      builder: (context, value, child) => TextField(
        enabled: widget.enable,
        controller: widget.controller,
        obscureText: widget.obscureText ? _obscureNotifier.value : false,
        style: const TextStyle(color: Colors.black87),
        decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white70,
            disabledBorder: OutlineInputBorder(
              borderRadius: widget.radius,
              borderSide:
                  const BorderSide(style: BorderStyle.solid, color: kGreyLight),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: widget.radius,
              borderSide:
                  const BorderSide(style: BorderStyle.solid, color: kGreyLight),
            ),
            hintText: widget.hint,
            hintStyle: const TextStyle(color: Colors.grey),
            prefixIcon: Icon(widget.icon, color: Colors.grey),
            suffixIcon: widget.obscureText
                ? IconButton(
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.zero,
                    icon: Icon(
                        value
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: Colors.grey),
                    onPressed: () {
                      _obscureNotifier.value = !value;
                    },
                  )
                : null),
      ),
    );
  }
}
