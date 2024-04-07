import 'package:authentication_repository/src/exception/auth_error_exception.dart';
import 'package:authentication_repository/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'auth_user.dart';
import 'dart:developer' as devtool show log;

abstract class AuthProvider {
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

class FirebaseAuthProvider implements AuthProvider {
  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
    required String repassword,
  }) async {
    try {
      if (password != repassword) throw PasswordsNotSameAuthException();
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = currentUser;
      if (user != null) {
        return user;
      } else {
        throw UserNotFindAuthException();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        throw InvalidEmailAuthException();
      } else if (e.code == 'weak-password') {
        throw WeakPasswordAuthException();
      } else if (e.code == 'email-already-in-use') {
        throw EmailAlreadyUserInUseAuthException();
      } else {
        throw GenericAuthException();
      }
    } catch (_) {
      throw GenericAuthException();
    }
  }

  @override
  AuthUser? get currentUser {
    final user = FirebaseAuth.instance.currentUser;
    // final name = user!.displayName;
    if (user != null) {
      return AuthUser.fromFireBase(user);
    } else {
      return null;
    }
  }

  @override
  Future<void> logOut() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseAuth.instance.signOut();
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
      await Future.delayed(const Duration(seconds: 4));
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = currentUser;

      if (user != null) {
        return user;
      } else {
        throw UserNotFindAuthException();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'INVALID_LOGIN_CREDENTIALS') {
        throw UserNotFindAuthException();
      } else if (e.code == 'invalid-email') {
        throw InvalidEmailAuthException();
      } else if (e.code == 'channel-error') {
        throw ChannelWrongAuthException();
      } else if (e.code == 'too-many-requests') {
        throw TooManyRequestsAuthException();
      } else if (e.code == 'invalid-credential') {
        throw WrongPasswordAuthException();
      } else {
        devtool.log(e.code);
        throw GenericAuthException();
      }
    } catch (_) {
      throw GenericAuthException();
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    final user = FirebaseAuth.instance.currentUser;
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
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: toEmail);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email':
          throw InvalidEmailAuthException();
        case 'user-not-found':
        case 'channel-error':
          throw UserNotFindAuthException();
        default:
          devtool.log('error code: ${e.code}');
          throw GenericAuthException();
      }
    } catch (e) {
      devtool.log('Unexpected error: $e');
      throw GenericAuthException();
    }
  }

  @override
  Future<void> emailReset({required String newEmail}) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
        if (!emailRegex.hasMatch(newEmail)) throw NewEmailInvalid();
        await user.verifyBeforeUpdateEmail(newEmail);
      } on FirebaseAuthException catch (e) {
        switch (e.code) {
          case 'requires-recent-login':
            throw RequiresRecentLoginException();

          default:
            devtool.log("FirebaseAuthException : ${e.code}、${e.message}");
            throw GenericAuthException();
        }
      } on NewEmailInvalid catch (_) {
        throw NewEmailInvalid();
      } catch (_) {
        devtool.log('Unexpected error: $_');
        throw GenericAuthException();
      }
    } else {
      throw UserNotFindAuthException();
    }
  }

  @override
  Future<void> deleteUser() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.delete();
    } else {
      throw UserNotFindAuthException();
    }
  }
}
