import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:glass/glass.dart';

import 'dart:developer' as devtool show log;

import 'package:podivy/service/auth/bloc/authBLOC.dart';
import 'package:podivy/service/auth/bloc/authEvent.dart';
import 'package:podivy/service/auth/bloc/authState.dart';
import 'package:podivy/util/dialogs/error_dialog.dart';
import 'package:podivy/util/dialogs/password_reset_dialog.dart';
import 'package:podivy/util/recommendButton.dart';

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
          devtool.log('hasSendEmail' + state.hasSendEmail.toString());
          devtool.log(state.exception.toString());
          if (state.hasSendEmail) {
            _controller.clear();
            await showPasswordResetSentDialog(context);
          }
          if (state.exception != null) {
            await showErrorDialog(context, '傳送失敗或找不到使用者');
          }
        }
      },
      child:  Center(
        child: Container(
          decoration: BoxDecoration(
                  color: Colors.black54, borderRadius: BorderRadius.circular(30)),
              padding: const EdgeInsets.all(12.0).r,
              width: 500.w,
              height: 359.h,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
                const Text('如果你忘記密碼，請輸入帳號的電子郵件'),
                TextField(
                  controller: _controller,
                  enableSuggestions: false,
                  autofocus: true,
                  autocorrect: false,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    hintText: '請輸入電子郵件',
                    focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFABC4AA))
            ),
                  ),
                ),
                const SizedBox(
                      height: 30,
                    ),
                RecommendButton(text: '重設密碼',
                onPressed: () {
                    final email = _controller.text;
                    context
                        .read<AuthBloc>()
                        .add(AuthEventForgotPassword(email: email));
                  },),
                TextButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(const AuthEventLogOut());
                  },
                  child: const Text('返回',style: TextStyle(color: Colors.white),),
                )
              ]),
        ).asGlass(tintColor: Colors.orange),
      )
    );
  }
}
