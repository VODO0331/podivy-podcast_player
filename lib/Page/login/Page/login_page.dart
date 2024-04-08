import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:modify_widget_repository/modify_widget_repository.dart';
import 'package:podivy/util/dialogs/error_dialog.dart';

import '../../../theme/custom_theme.dart';
import '../../../util/dialogs/language_dialog.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Widget textFieldGroup() {
    return Column(
      children: [
        TextField(
          style: const TextStyle(
            color: Colors.white,
          ),
          cursorColor: Colors.white,
          cursorErrorColor: const Color(0xFFABC4AA),
          controller: _email,
          enableSuggestions: false,
          autocorrect: false,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            hintStyle: const TextStyle(color: Colors.grey),
            fillColor: Colors.black45,
            hintText: 'enter the Email'.tr,
            focusedBorder: OutlineInputBorder(
              borderSide:
                  const BorderSide(color: Color(0xFFABC4AA), width: 2.0),
              borderRadius: BorderRadius.circular(10.0),
            ),
            // border: const OutlineInputBorder(
            //     borderSide: BorderSide(color: Color(0xFFABC4AA))),
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        TextField(
          style: const TextStyle(
            color: Colors.white,
          ),
          cursorColor: Colors.white,
          controller: _password,
          obscureText: true,
          enableSuggestions: false,
          autocorrect: false,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            hintStyle: const TextStyle(color: Colors.grey),
            fillColor: Colors.black45,
            hintText: 'enter the Password'.tr,
            focusedBorder: OutlineInputBorder(
              borderSide:
                  const BorderSide(color: Color(0xFFABC4AA), width: 2.0),
              borderRadius: BorderRadius.circular(10.0),
            ),
            border: const UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFABC4AA))),
          ),
        ),
      ],
    );
  }

  Widget buttonGroup() {
    return Column(
      children: [
        TextButton(
          style: textButtonForRecommend,
          child: Text(
            'logIn'.tr,
            style: TextStyle(fontSize: 15.sp, color: Colors.black),
          ),
          onPressed: () async {
            final email = _email.text;
            final password = _password.text;
            if (email.trim().isEmpty || password.trim().isEmpty) {
              await showErrorDialog(
                context,
                'Email or password cannot be empty'.tr,
              );
            } else {
              context.read<AuthBloc>().add(AuthEventLogIn(email, password));
            }
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton.filled(
                style: ButtonStyle(
                    backgroundColor: MaterialStateColor.resolveWith(
                        (states) => const Color(0xFFABC4AA))),
                onPressed: () async {
                  await languageDialog();
                },
                icon: const Icon(
                  Icons.language,
                  color: Colors.black87,
                )),
            TextButton(
              onPressed: () {
                context.read<AuthBloc>().add(const AuthEventShouldRegister());
              },
              child: Text(
                "register".tr,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: ScreenUtil().setSp(12),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                context.read<AuthBloc>().add(const AuthEventForgotPassword());
              },
              child: Text(
                "forget the password?".tr,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: ScreenUtil().setSp(12),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateLoggedOut) {
          final exception = state.exception;
          if (exception != null) {
            if (state.exception is UserNotFindAuthException) {
              await showErrorDialog(
                context,
                'This user does not exist'.tr,
              );
            } else if (state.exception is InvalidEmailAuthException) {
              await showErrorDialog(
                context,
                'Invalid email'.tr,
              );
            } else if (state.exception is ChannelWrongAuthException) {
              await showErrorDialog(
                context,
                'Entered multiple times, please try again later'.tr,
              );
            } else if (state.exception is WrongPasswordAuthException) {
              await showErrorDialog(
                context,
                'Email or password wrong'.tr,
              );
            } else if (state.exception is GenericAuthException) {
              await showErrorDialog(
                context,
                'Other wrong'.tr,
              );
            }
          }
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            children: [
              Text(
                'Podivy',
                style: GoogleFonts.borel(
                  fontSize: 70,
                  foreground: Paint()
                    ..style = PaintingStyle.stroke
                    ..strokeWidth = 2.0
                    ..color = Colors.white38,
                ),
              ),
              Text(
                'Podivy',
                style: GoogleFonts.borel(
                  fontSize: 70,
                  color: const Color(0xFF1D1E18),
                ),
              ),
            ],
          ),
          Container(
            decoration: const BoxDecoration(
              color: Colors.black54,
            ),
            padding: const EdgeInsets.all(12.0).r,
            width: 500.w,
            height: 395.h,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                    padding: const EdgeInsets.only(bottom: 20).h,
                    child: Text(
                      'Login',
                      style: GoogleFonts.lora(
                          fontSize: 30, color: const Color(0xFFABC4AA)),
                    )),
                textFieldGroup(),
                const SizedBox(
                  height: 30,
                ),
                buttonGroup(),
              ],
            ),
          ).asGlass(
              tintColor: Colors.orange,
              clipBorderRadius: BorderRadius.circular(30)),
        ],
      ),
    );
  }
}
