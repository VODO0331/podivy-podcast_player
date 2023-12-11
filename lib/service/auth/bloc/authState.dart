
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart' show immutable;
import 'package:podivy/service/auth/authUser.dart';

@immutable
abstract class AuthState {
  final bool isLoading;
  final String? loadingText;
  const AuthState({required this.isLoading, this.loadingText = '加載中...'});
}

class AuthStateUnInitialized extends AuthState {
  const AuthStateUnInitialized({required bool isLoading})
      : super(isLoading: isLoading);
}

class AuthStateLoggedIn extends AuthState {
  final AuthUser user;
  const AuthStateLoggedIn({
    required bool isLoading,
    required this.user,
  }) : super(isLoading: isLoading);
}

class AuthStateNeedVerification extends AuthState {
  const AuthStateNeedVerification({required bool isLoading})
      : super(isLoading: isLoading);
}

class AuthStateLoggedOut extends AuthState with EquatableMixin {
  final Exception? exception;
  const AuthStateLoggedOut({
    required this.exception,
    required bool isLoading,
    String? loadingText,
  }) : super(
          isLoading: isLoading,
          loadingText: loadingText,
        );

  @override
  List<Object?> get props => [exception, isLoading];
}

class AuthStateRegistering extends AuthState {
  final Exception? exception;
  const AuthStateRegistering({
    required bool isLoading,
    required this.exception,
  }) : super(isLoading: isLoading);
}

class AuthStateForgotPassword extends AuthState {
  final Exception? exception;
  final bool hasSendEmail;

  const AuthStateForgotPassword({
    required bool isLoading,
    required this.exception,
    required this.hasSendEmail,
  }) : super(isLoading: isLoading);
}
