import 'package:authentication_repository/authentication_repository.dart';
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
import 'package:search_service/search_service_repository.dart';

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
            text: 'loading'.tr,
          );
        } else {
          LoadingScreen().hide();
        }
      },
      builder: (context, state) {
        late Widget child;
        final clientController = Get.put(ClientGlobalController());
        // final informationController = Get.find<InformationController>();
        if (state is AuthStateLoggedIn) {
          child = const Tabs();
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

        return GraphQLProvider(
          client: ValueNotifier(clientController.client),
          child: ScreenUtilInit(
            designSize: const Size(393, 852),
            minTextAdapt: true,
            splitScreenMode: true,
            child: child,
          ),
        );
      },
    );
  }
}
