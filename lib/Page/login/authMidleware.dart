import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:podivy/Page/login/Page/loginPage.dart';
import 'package:podivy/Page/login/Page/passwordRestPage.dart';
import 'package:podivy/Page/login/Page/registerPage.dart';
import 'package:podivy/Page/login/Page/verigyPage.dart';
import 'package:podivy/Page/login/loginBackGround.dart';
import 'package:podivy/Page/tabs.dart';
import 'package:podivy/loading/loading_screen.dart';
import 'package:podivy/service/auth/bloc/authBLOC.dart';
import 'package:podivy/service/auth/bloc/authEvent.dart';
import 'package:podivy/service/auth/bloc/authState.dart';

class AuthMiddleWare extends StatelessWidget {
  const AuthMiddleWare({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventInitialize());
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.isLoading) {
          LoadingScreen().show(
            context: context,
            text: state.loadingText ?? '加載中...',
          );
        } else {
          LoadingScreen().hide();
        }
      },
      builder: (context, state) {
        if (state is AuthStateLoggedIn) {
          return const Tabs();
        } else if (state is AuthStateNeedVerification) {
          return const LoginBackGround(child: VerifyEmailPage());
        } else if (state is AuthStateLoggedOut) {
          return const LoginBackGround(child:  LoginPage());
        } else if (state is AuthStateRegistering) {
          return const LoginBackGround(child:RegisterPage());
        } else if (state is AuthStateForgotPassword) {
          return const LoginBackGround(child: ForgotPasswordPage());
        } else {
          return const Scaffold(
            body: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
