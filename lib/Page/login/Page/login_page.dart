import 'dart:typed_data';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:modify_widget_repository/modify_widget_repository.dart';
import 'package:podivy/util/img_compress.dart';
import 'package:podivy/util/dialogs/error_dialog.dart';
import 'package:podivy/util/recommend_bt.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  late final ImageCompressor imageCompressor;
  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    imageCompressor = ImageCompressor();
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
          cursorColor: Colors.white,
          controller: _email,
          enableSuggestions: false,
          autocorrect: false,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            hintText: '輸入電子郵件',
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFABC4AA))),
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        TextField(
          cursorColor: Colors.white,
          controller: _password,
          obscureText: true,
          enableSuggestions: false,
          autocorrect: false,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            hintText: '輸入密碼',
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFABC4AA))),
          ),
        ),
      ],
    );
  }

  Widget buttonGroup() {
    return Column(
      children: [
        RecommendButton(
          text: '登入',
          size: 15,
          onPressed: () async {
            final email = _email.text;
            final password = _password.text;
            context.read<AuthBloc>().add(AuthEventLogIn(email, password));
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {
                context.read<AuthBloc>().add(const AuthEventShouldRegister());
              },
              child: Text(
                "註冊",
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
                "忘記密碼?",
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

  Future<Uint8List?> vineImage() async {
    final list = await imageCompressor.compressImage(
        'images/background/bkvine3.png',
        minh: 80,
        minw: 80,
        quality: 60,
        format: ImageFormat.png);
    return list;
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
                '此用戶不存在或密碼錯誤',
              );
            } else if (state.exception is InvalidEmailAuthException) {
              await showErrorDialog(
                context,
                '無效電子郵件',
              );
            } else if (state.exception is ChannelWrongAuthException) {
              await showErrorDialog(
                context,
                '輸入多次，請稍後再試',
              );
            } else if (state.exception is WrongPasswordAuthException) {
              await showErrorDialog(
                context,
                'Email 或 密碼 錯誤',
              );
            } else if (state.exception is GenericAuthException) {
              await showErrorDialog(
                context,
                '其他錯誤',
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
            decoration: BoxDecoration(
                color: Colors.black54, borderRadius: BorderRadius.circular(30)),
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
          ).asGlass(tintColor: Colors.orange),
        ],
      ),
    );
  }
}
