

import 'package:flutter/material.dart' show immutable;
@immutable
abstract class AuthEvent{
  const AuthEvent();
}

class AuthEventInitialize extends AuthEvent{
  
  const AuthEventInitialize();
}

class AuthEventLogIn extends AuthEvent{
  final String email;
  final String password;
  final String loginMethod;
  const AuthEventLogIn(this.email, this.password,this.loginMethod);

}

class AuthEventLogOut extends AuthEvent{
  final String loginMethod;
  const AuthEventLogOut(this.loginMethod);
}

class AuthEventSendEmailVerification extends AuthEvent{
  final String loginMethod;
  const AuthEventSendEmailVerification(this.loginMethod);
  
}

class AuthEventRegister extends AuthEvent{
  final String email;
  final String password;
  final String repassword;
  const AuthEventRegister(this.email, this.password, this.repassword);
}
class AuthEventShouldRegister extends AuthEvent{
  
  const AuthEventShouldRegister();
}

class AuthEventForgotPassword extends AuthEvent{
  final String? email;

  const AuthEventForgotPassword({ this.email});
}
class AuthEventDeleteUser extends AuthEvent{
  final String loginMethod;

  const AuthEventDeleteUser(this.loginMethod);
}