part of 'auth_bloc.dart';

enum AuthStatus { initial, loading, empty, failure, loaded, login }

class AuthState extends Equatable {
  const AuthState(
      {this.status = AuthStatus.initial,
      this.signedUser,
      this.localUsers = const [],
      this.indexPage = 0});

  final AuthStatus status;
  final List<User> localUsers;
  final User? signedUser;
  final int indexPage;

  AuthState copyWith(
      {AuthStatus? status,
      User? signedUser,
      List<User>? localUsers,
      int? indexPage}) {
    return AuthState(
        status: status ?? this.status,
        signedUser: signedUser ?? this.signedUser,
        localUsers: localUsers ?? this.localUsers,
        indexPage: indexPage ?? this.indexPage);
  }

  @override
  List<Object?> get props => [status, localUsers, signedUser, indexPage];
}
