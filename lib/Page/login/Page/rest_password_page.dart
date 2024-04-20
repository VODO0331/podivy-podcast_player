import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:modify_widget_repository/modify_widget_repository.dart';

import 'dart:developer' as devtool show log;
import 'package:podivy/util/dialogs/error_dialog.dart';
import 'package:podivy/util/dialogs/password_reset_dialog.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
        listener: (context, state) async {
          if (state is AuthStateForgotPassword) {
            devtool.log(state.exception.toString());
            if (state.hasSendEmail) {
              _controller.clear();
              await showPasswordResetSentDialog(context);
              context.mounted
                  ? context.read<AuthBloc>().add(const AuthEventLogOut('Firebase'))
                  : null;
            }
            if (state.exception != null && context.mounted) {
              await showErrorDialog(context, '傳送失敗或格式不符');
            }
          }
        },
        child: Center(
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.black54,
            ),
            padding: const EdgeInsets.all(12.0).r,
            width: 500.w,
            height: 359.h,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text('If you forget your password, enter the email'.tr),
              SizedBox(height: 20.r,),
              TextField(
                style: const TextStyle(color: Colors.white),
                cursorColor: Colors.white,
                controller: _controller,
                enableSuggestions: false,
                autofocus: true,
                autocorrect: false,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  fillColor: Colors.black45,
                  hintStyle: const TextStyle(color: Colors.grey),
                  hintText: 'enter the Email'.tr,
                  focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFABC4AA))),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateColor.resolveWith(
                        (states) => const Color(0xFFABC4AA))),
                child: Text(
                  'reset Password'.tr,
                  style: const TextStyle(color: Colors.black),
                ),
                onPressed: () {
                  final email = _controller.text;
                  context
                      .read<AuthBloc>()
                      .add(AuthEventForgotPassword(email: email));
                },
              ),
              TextButton(
                onPressed: () {
                  context.read<AuthBloc>().add(const AuthEventLogOut('Firebase'));
                },
                child: Text(
                  'back'.tr,
                  style: const TextStyle(color: Colors.white),
                ),
              )
            ]),
          ).asGlass(
              tintColor: Colors.orange,
              clipBorderRadius: BorderRadius.circular(30)),
        ));
  }
}
