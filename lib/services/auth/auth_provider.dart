import 'package:notes_app/services/auth/auth_user.dart';

abstract class AuthProvider {
  Future<void> initialize();

  AuthUser? get currentUser;

  Future<AuthUser> logIn({
    required email,
    required password,
  });

  Future<AuthUser> createUser({
    required email,
    required password,
  });

  Future<void> logOut();
  Future<void> sendEmailVerification();
}
