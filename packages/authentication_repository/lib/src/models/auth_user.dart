
import 'package:flutter/material.dart';

import 'models.dart';

@immutable
class AuthUser {
  final String id;
  final bool isEmailVerified;
  final String email;
  final String loginMethod;
  const AuthUser( {
    required this.id,
    required this.email,
    required this.isEmailVerified,
    required this.loginMethod,
  });

  factory AuthUser.fromFireBase(User user, String loginMethod) => AuthUser(
        id: user.uid,
        email: user.email!,
        isEmailVerified: user.emailVerified,
        loginMethod: loginMethod,
      );

}
