import 'package:authentication_repository/authentication_repository.dart';
import 'package:authentication_repository/src/models/auth_google_provider.dart';
import 'package:authentication_repository/src/models/auth_provider.dart';

class AuthService implements AuthProvider {
  final AuthProvider provider;

  const AuthService(this.provider);

  factory AuthService.firebase() => AuthService(FirebaseAuthProvider());
  factory AuthService.google()=>AuthService(GoogleAuthProvider());
  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
    required String repassword,
  }) =>
      provider.createUser(
        email: email,
        password: password,
        repassword: repassword,
      );

  @override
  AuthUser? get currentUser => provider.currentUser;

  @override
  Future<void> logOut() => provider.logOut();

  @override
  Future<AuthUser> login({
    required email,
    required password,
  }) =>
      provider.login(
        email: email,
        password: password,
      );

  @override
  Future<void> sendEmailVerification() => provider.sendEmailVerification();

  @override
  Future<void> initialize() => provider.initialize();

  @override
  Future<void> sendPasswordReset({required String toEmail}) =>
      provider.sendPasswordReset(toEmail: toEmail);

  @override
  Future<void> emailReset({required String newEmail}) =>
      provider.emailReset(newEmail: newEmail);

  @override
  Future<void> deleteUser() => provider.deleteUser();
  
  @override
  String get loginMethod => provider.loginMethod;
}
