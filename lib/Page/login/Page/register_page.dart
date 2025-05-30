import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:modify_widget_repository/modify_widget_repository.dart';
import 'package:podivy/util/dialogs/error_dialog.dart';

import '../../../theme/custom_theme.dart';

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
          style: const TextStyle(color: Colors.white),
          cursorColor: Colors.white,
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
            border: const OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFABC4AA))),
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        TextField(
          controller: _password,
          style: const TextStyle(color: Colors.white),
          cursorColor: Colors.white,
          obscureText: true,
          enableSuggestions: false,
          autocorrect: false,
          autofocus: true,
          keyboardType: TextInputType.visiblePassword,
          decoration: InputDecoration(
            hintStyle: const TextStyle(color: Colors.grey),
            fillColor: Colors.black45,
            hintText: 'enter the Password'.tr,
            focusedBorder: OutlineInputBorder(
              borderSide:
                  const BorderSide(color: Color(0xFFABC4AA), width: 2.0),
              borderRadius: BorderRadius.circular(10.0),
            ),
            border: const OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFABC4AA))),
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        TextField(
          controller: _repassword,
          style: const TextStyle(color: Colors.white),
          cursorColor: Colors.white,
          obscureText: true,
          enableSuggestions: false,
          autocorrect: false,
          keyboardType: TextInputType.visiblePassword,
          decoration: InputDecoration(
            hintStyle: const TextStyle(color: Colors.grey),
            fillColor: Colors.black45,
            hintText: 'enter the password again'.tr,
            focusedBorder: OutlineInputBorder(
              borderSide:
                  const BorderSide(color: Color(0xFFABC4AA), width: 2.0),
              borderRadius: BorderRadius.circular(10.0),
            ),
            border: const OutlineInputBorder(
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
            'register'.tr,
            style: const TextStyle(color: Colors.black),
          ),
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

            // await showGenericDialog(
            //   context: context,
            //   title: '郵件驗證',
            //   content: '驗證郵件已發送...',
            //   optionBuilder: () => {'ok': null},
            // );
          },
        ),
        TextButton(
          onPressed: () {
            context.read<AuthBloc>().add(
                const  AuthEventLogOut("Firebase"),
                );
          },
          child: Text(
            "Already have an account? Log in here".tr,
            style: const TextStyle(color: Colors.white),
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
                'The password strength is too weak, please re-enter'.tr,
              );
            } else if (state.exception is InvalidEmailAuthException) {
              await showErrorDialog(
                context,
                'Invalid email'.tr,
              );
            } else if (state.exception is EmailAlreadyUserInUseAuthException) {
              await showErrorDialog(
                context,
                'This email has been registered'.tr,
              );
            } else if (state.exception is PasswordsNotSameAuthException) {
              await showErrorDialog(
                context,
                'The passwords are not the same'.tr,
              );
            } else if (state.exception is GenericAuthException) {
              await showErrorDialog(
                context,
                'Other errors, failure to register'.tr,
              );
            }
          }
        }
      },
      child: Center(
        child: Container(
          decoration: const BoxDecoration(color: Colors.black54),
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
        ).asGlass(
            tintColor: Colors.orange,
            clipBorderRadius: BorderRadius.circular(30)),
      ),
    );
  }
}
