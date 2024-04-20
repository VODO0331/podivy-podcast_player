
import 'package:flutter/material.dart';

import 'models.dart';

@immutable
class AuthUser {
  final String id;
  final bool isEmailVerified;
  final String email;
  const AuthUser({
    required this.id,
    required this.email,
    required this.isEmailVerified,
    
  });

  factory AuthUser.fromFireBase(User user) => AuthUser(
        id: user.uid,
        email: user.email!,
        isEmailVerified: user.emailVerified,
      );

}
