import 'dart:developer' as devtool show log;
import 'package:authentication_repository/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart' as fba
    show GoogleAuthProvider, FirebaseAuth;
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../exception/auth_error_exception.dart';
import 'auth_provider.dart' as my_provider;
import 'auth_user.dart';

class GoogleAuthProvider implements my_provider.AuthProvider {
  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
    required String repassword,
  }) async {
    return const AuthUser(
        id: '', email: '', isEmailVerified: false, loginMethod: "Google");
  }

  @override
  AuthUser? get currentUser {
    final user = fba.FirebaseAuth.instance.currentUser;
    // final name = user!.displayName;
    if (user != null) {
      return AuthUser.fromFireBase(user, loginMethod);
    } else {
      return null;
    }
  }

  @override
  Future<void> logOut() async {
    final user = fba.FirebaseAuth.instance.currentUser;
    if (user != null) {
      await fba.FirebaseAuth.instance.signOut();
      await GoogleSignIn().signOut();
    } else {
      throw UserNotFindAuthException();
    }
  }

  @override
  Future<AuthUser> login({
    required email,
    required password,
  }) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      if (googleAuth == null) {
        await GoogleSignIn().signOut();
        return AuthUser(
            id: '',
            email: '',
            isEmailVerified: false,
            loginMethod: loginMethod);
      }
      final credential = fba.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await Future.delayed(const Duration(seconds: 2));

      await fba.FirebaseAuth.instance.signInWithCredential(credential);

      return AuthUser(
          id: googleUser!.id,
          email: googleUser.email,
          isEmailVerified: true,
          loginMethod: loginMethod);
    } on Exception catch (e) {
      devtool.log(e.toString());
      throw GenericAuthException();
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    final user = fba.FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.sendEmailVerification();
    } else {
      throw UserNotLogInAuthException();
    }
  }

  @override
  Future<void> initialize() async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
  }

  @override
  Future<void> sendPasswordReset({required String toEmail}) async {
    return;
  }

  @override
  Future<void> emailReset({required String newEmail}) async {
    return;
  }

  @override
  Future<void> deleteUser() async {
    final user = fba.FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.delete();
      await GoogleSignIn().signOut();
    } else {
      throw UserNotFindAuthException();
    }
  }

  @override
  String get loginMethod => 'Google';
}
