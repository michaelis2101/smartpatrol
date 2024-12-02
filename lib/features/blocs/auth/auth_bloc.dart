import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:smart_patrol/data/models/user_model.dart';
import 'package:smart_patrol/data/provider/database_helper.dart';
import 'package:smart_patrol/utils/utils.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({AuthState? initialState}) : super(const AuthState()) {
    on<GetLoginStatusEvent>(_getLoginStatus);
    on<GetLocalUsersEvent>(_getLocalUsers);
    on<GetLocalUsersFromJsonEvent>(_getLocalUsersFromJson);
    on<AuthenticateUserEvent>(_authenticateUser);
    on<LogOutUserEvent>(_logoutUser);
    on<SetSettingShiftEvent>(_setShiftUser);
    on<SetSettingBackgroundEvent>(_setBgBannerUser);
    on<SetSettingPatrolEvent>(_setPatrolUser);
    on<SetSettingUrlServerEvent>(_setUrlServer);
    on<SetApiKeyEvent>(_setApiKey);
    on<ChangeMainPageEvent>(_changeMainPage);
  }

  Future<void> _getLoginStatus(
      GetLoginStatusEvent event, Emitter<AuthState> emitter) async {
    try {
      final data = await DatabaseProvider.getSignedUserJson();
      if (data != null) {
        emitter(state.copyWith(signedUser: data, status: AuthStatus.login));
      } else {
        emitter(state.copyWith(status: AuthStatus.failure));
      }
    } catch (e) {
      debugPrint('GetLoginStatusEvent $e');
      emitter(state.copyWith(status: AuthStatus.failure));
    }
  }

  Future<void> _getLocalUsers(
      GetLocalUsersEvent event, Emitter<AuthState> emitter) async {
    try {
      final data = await DatabaseProvider.getUserJson();
      if (data.isNotEmpty) {
        emitter(state.copyWith(localUsers: data, status: AuthStatus.loaded));
      } else {
        emitter(state.copyWith(status: AuthStatus.empty));
      }
    } catch (e) {
      debugPrint('GetLocalUsersEvent $e');
      emitter(state.copyWith(status: AuthStatus.failure));
    }
  }

  Future<void> _getLocalUsersFromJson(
      GetLocalUsersFromJsonEvent event, Emitter<AuthState> emitter) async {
    try {
      final file = await AppUtil.readFile(['json']);

      if (file != null) {
        String message = 'terbaca  : ' + file.readAsStringSync();
        print(message);

        final data = await json.decode(file.readAsStringSync());
        if (data['user'] != null) {
          List<User> users = ((data['user'] as List?) ?? [])
              .map((e) => User.fromJson(e))
              .toList();
          await DatabaseProvider.putUserJson(users);
          final userDb = await DatabaseProvider.getUserJson();
          if (userDb.isNotEmpty) {
            event.onSuccess();
            emitter(
                state.copyWith(localUsers: userDb, status: AuthStatus.loaded));
          } else {
            event.onFailed('Gagal mengimport data json');
            emitter(state.copyWith(status: AuthStatus.empty));
          }
        } else {
          event.onFailed('Tidak ada data yang tersimpan');
          emitter(state.copyWith(status: AuthStatus.empty));
        }
      } else {
        event.onFailed('Tidak ada file yang di import');
      }
    } catch (e) {
      debugPrint('GetLocalUsersFromJsonEvent $e');
      event.onFailed('Failed get data json file \n$e');
      emitter(state.copyWith(status: AuthStatus.failure));
    }
  }

  Future<void> _authenticateUser(
      AuthenticateUserEvent event, Emitter<AuthState> emitter) async {
    try {
      User? user;
      for (var data in state.localUsers) {
        if (data.username.toLowerCase() == event.username.toLowerCase() &&
            // if (data.username == event.username &&
            data.password == AppUtil.generateMd5(event.password)) {
          user = data;
        }
      }
      if (user != null) {
        await DatabaseProvider.putSignedUserJson(user);
        final signedUser = await DatabaseProvider.getSignedUserJson();
        if (signedUser != null) {
          debugPrint('Signed user successfully saved');
        }
        emitter(state.copyWith(signedUser: user));
        event.onSuccess();
      } else {
        event.onFailed('Username atau kata sandi salah');
      }
    } catch (e) {
      debugPrint('AuthenticateUserEvent $e');
      event.onFailed('Login gagal');
    }
  }

  Future<void> _logoutUser(
      LogOutUserEvent event, Emitter<AuthState> emitter) async {
    try {
      await DatabaseProvider.deleteTableJson('signed');
      event.onSuccess();
    } catch (e) {
      debugPrint('LogOutUserEvent $e');
      event.onFailed('Login gagal');
    }
  }

  Future<void> _setShiftUser(
      SetSettingShiftEvent event, Emitter<AuthState> emitter) async {
    try {
      var user = state.signedUser!.copyWith(shift: event.shift);
      await DatabaseProvider.putSignedUserJson(user);
      final signedUser = await DatabaseProvider.getSignedUserJson();
      emitter(state.copyWith(signedUser: signedUser));
    } catch (e) {
      debugPrint('SetSettingShiftEvent $e');
    }
  }

  Future<void> _setPatrolUser(
      SetSettingPatrolEvent event, Emitter<AuthState> emitter) async {
    try {
      var user = state.signedUser!.copyWith(patrol: event.patrol);
      await DatabaseProvider.putSignedUserJson(user);
      final signedUser = await DatabaseProvider.getSignedUserJson();
      emitter(state.copyWith(signedUser: signedUser));
    } catch (e) {
      debugPrint('SetSettingPatrolEvent $e');
    }
  }

  //digunakan untuk setting url server
  Future<void> _setUrlServer(
      SetSettingUrlServerEvent event, Emitter<AuthState> emitter) async {
    try {
      var user = state.signedUser!.copyWith(urlServer: event.url_server);
      await DatabaseProvider.putSignedUserJson(user);
      final signedUser = await DatabaseProvider.getSignedUserJson();
      emitter(state.copyWith(signedUser: signedUser));
    } catch (e) {
      debugPrint('SetSettingUrlServerEvent $e');
    }
  }

  //digunakan untuk setting api id
  Future<void> _setApiKey(
      SetApiKeyEvent event, Emitter<AuthState> emitter) async {
    try {
      var user = state.signedUser!.copyWith(api_id: event.api_id);
      await DatabaseProvider.putSignedUserJson(user);
      final signedUser = await DatabaseProvider.getSignedUserJson();
      emitter(state.copyWith(signedUser: signedUser));
    } catch (e) {
      debugPrint('SetApiKeyEvent $e');
    }
  }

  Future<void> _changeMainPage(
      ChangeMainPageEvent event, Emitter<AuthState> emitter) async {
    emitter(state.copyWith(indexPage: event.index));
  }

  Future<void> _setBgBannerUser(
      SetSettingBackgroundEvent event, Emitter<AuthState> emitter) async {
    var bytes = await event.image.readAsBytes();
    var encodedImage = base64Encode(bytes);
    try {
      var user = state.signedUser!.copyWith(backgroundCover: encodedImage);
      await DatabaseProvider.putSignedUserJson(user);
      final signedUser = await DatabaseProvider.getSignedUserJson();
      emitter(state.copyWith(signedUser: signedUser));
    } catch (e) {
      debugPrint('SetSettingBackgroundEvent $e');
    }
  }
}
