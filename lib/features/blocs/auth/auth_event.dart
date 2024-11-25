part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class GetLoginStatusEvent extends AuthEvent {
  const GetLoginStatusEvent();
}

class GetLocalUsersEvent extends AuthEvent {
  const GetLocalUsersEvent();
}

class GetLocalUsersFromJsonEvent extends AuthEvent {
  final Function onSuccess;
  final Function(String) onFailed;

  const GetLocalUsersFromJsonEvent(
      {required this.onFailed, required this.onSuccess});
}

class AuthenticateUserEvent extends AuthEvent {
  final String username, password;
  final Function onSuccess;
  final Function(String) onFailed;

  const AuthenticateUserEvent(
      {required this.onSuccess,
      required this.onFailed,
      required this.password,
      required this.username});
}

class LogOutUserEvent extends AuthEvent {
  final Function onSuccess;
  final Function(String) onFailed;

  const LogOutUserEvent({required this.onSuccess, required this.onFailed});
}

class SetSettingBackgroundEvent extends AuthEvent {
  final XFile image;
  const SetSettingBackgroundEvent({required this.image});
}

class SetSettingShiftEvent extends AuthEvent {
  final String shift;
  const SetSettingShiftEvent({required this.shift});
}

class SetSettingPatrolEvent extends AuthEvent {
  final int patrol;
  const SetSettingPatrolEvent({required this.patrol});
}

class SetSettingUrlServerEvent extends AuthEvent {
  final String url_server;
  const SetSettingUrlServerEvent({required this.url_server});
}

class SetApiKeyEvent extends AuthEvent {
  final String api_id;
  const SetApiKeyEvent({required this.api_id});
}

class ChangeMainPageEvent extends AuthEvent {
  final int index;
  const ChangeMainPageEvent({required this.index});
}
