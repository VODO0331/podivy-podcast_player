import 'package:authentication_repository/authentication_repository.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modify_widget_repository/modify_widget_repository.dart';
import 'package:podivy/Page/login/Page/login_page.dart';
import 'package:podivy/Page/login/Page/rest_password_page.dart';
import 'package:podivy/Page/login/Page/register_page.dart';
import 'package:podivy/Page/login/Page/verify_page.dart';
import 'package:podivy/Page/login/login_background.dart';
import 'package:podivy/Page/tabs.dart';
import 'package:podivy/loading/loading_screen.dart';

class AuthMiddleWare extends StatefulWidget {
  const AuthMiddleWare({super.key});

  @override
  State<AuthMiddleWare> createState() => _AuthMiddleWareState();
}

class _AuthMiddleWareState extends State<AuthMiddleWare> {
  OverlayEntry? _overlayEntry;
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(const AuthEventInitialize());
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        _showOverlay();
      } else {
        _removeOverlay();
      }
    });
  }

  void _showOverlay() {
    _overlayEntry = OverlayEntry(
      builder: (context) =>  Material(
        color: Colors.black87,
        child: Center(
          child: SizedBox(
            height: 100.h,
            width: 300.w,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const CircularProgressIndicator(),
                Text('Connecting to the Internet'.tr,style: TextStyle(fontSize: 15.sp),)
              ],
            ),
            
          ),
        ),
      ),
    );
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.isLoading) {
          LoadingScreen().show(
            context: context,
            text: 'loading'.tr,
          );
        } else {
          LoadingScreen().hide();
        }
      },
      builder: (context, state) {
        late Widget child;

        if (state is AuthStateLoggedIn) {
          switch (state) {
            case AuthStateLoggedInFormEmail():
              child = const Tabs(loginMethod: 'Firebase');
            case AuthStateLoggedInFormGoogle():
              child = const Tabs(loginMethod: 'Google');
          }
        } else if (state is AuthStateNeedVerification) {
          child = const LoginBackGround(child: VerifyEmailPage());
        } else if (state is AuthStateLoggedOut) {
          child = const LoginBackGround(child: LoginPage());
        } else if (state is AuthStateRegistering) {
          child = const LoginBackGround(child: RegisterPage());
        } else if (state is AuthStateForgotPassword) {
          child = const LoginBackGround(child: ForgotPasswordPage());
        } else {
          child = const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        return ScreenUtilInit(
          designSize: const Size(393, 852),
          minTextAdapt: true,
          splitScreenMode: true,
          child: child,
        );
      },
    );
  }
}
