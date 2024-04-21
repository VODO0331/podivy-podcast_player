
import 'auth_user.dart';


abstract class AuthProvider {
  String get loginMethod;
  Future<void> initialize();
  AuthUser? get currentUser;
  Future<AuthUser> login({
    required email,
    required password,
  });
  Future<AuthUser> createUser({
    required String email,
    required String password,
    required String repassword,
  });
  Future<void> logOut();
  Future<void> sendEmailVerification();

  Future<void> sendPasswordReset({required String toEmail});
  Future<void> emailReset({required String newEmail});
  Future<void> deleteUser();
}

