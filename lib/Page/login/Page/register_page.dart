import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:modify_widget_repository/modify_widget_repository.dart';
import 'package:podivy/util/dialogs/error_dialog.dart';
import 'package:podivy/util/dialogs/generic_dialog.dart';
import 'package:podivy/util/recommend_bt.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  late final TextEditingController _repassword;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    _repassword = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _repassword.dispose();
    super.dispose();
  }

  Widget textFieldGroup() {
    return Column(
      children: [
        TextField(
          controller: _email,
          enableSuggestions: false,
          autocorrect: false,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            hintText: '輸入電子郵件',
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFABC4AA))
            ),
          ),
        ),
        const SizedBox(
                      height: 15,
                    ),
        TextField(
          controller: _password,
          obscureText: true,
          enableSuggestions: false,
          autocorrect: false,
          autofocus: true,
          keyboardType: TextInputType.visiblePassword,
          decoration: const InputDecoration(
            hintText: '輸入密碼',
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFABC4AA))
            ),
          ),
        ),
        const SizedBox(
                      height: 15,
                    ),
        TextField(
          controller: _repassword,
          obscureText: true,
          enableSuggestions: false,
          autocorrect: false,
          keyboardType: TextInputType.visiblePassword,
          decoration: const InputDecoration(
            hintText: '再次輸入密碼',
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFABC4AA))
            ),
          ),
        ),
      ],
    );
  }

  Widget buttonGroup() {
    return Column(
      children: [
        RecommendButton(
          text: '註冊',
          onPressed: () async {
            final email = _email.text;
            final password = _password.text;
            final repassword = _repassword.text;
            context.read<AuthBloc>().add(
                  AuthEventRegister(
                    email,
                    password,
                    repassword,
                  ),
                );
                
            await showGenericDialog(
              context: context,
              title: '郵件驗證',
              content: '驗證郵件已發送...',
              optionBuilder: () => {'ok': null},
            );
          },
        ),
        TextButton(
          onPressed: () {
            context.read<AuthBloc>().add(
                  const AuthEventLogOut(),
                );
          },
          child: const Text(
            "已有帳號? 在這登入",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateRegistering) {
          final exception = state.exception;

          if (exception != null) {
            if (state.exception is WeakPasswordAuthException) {
              await showErrorDialog(
                context,
                '密碼強度太弱，重新輸入',
              );
            } else if (state.exception is InvalidEmailAuthException) {
              await showErrorDialog(
                context,
                '無效電子郵件',
              );
            } else if (state.exception is EmailAlreadyUserInUseAuthException) {
              await showErrorDialog(
                context,
                '此郵件已被註冊',
              );
            } else if (state.exception is PasswordsNotSameAuthException) {
              await showErrorDialog(
                context,
                '密碼不相同',
              );
            } else if (state.exception is GenericAuthException) {
              await showErrorDialog(
                context,
                '其他錯誤，註冊失敗',
              );
            }
          }
        }
      },
      child: Center(
        child: Container(
          decoration:const BoxDecoration(
              color: Colors.black54),
          padding: const EdgeInsets.all(12.0).r,
          width: 500.w,
          height: 450.h,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                  padding: const EdgeInsets.only(bottom: 20).h,
                  child: Text(
                    'Registration',
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
        ).asGlass(tintColor: Colors.orange,clipBorderRadius: BorderRadius.circular(30)),
      ),
    );
  }
}
