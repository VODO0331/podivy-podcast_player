import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:modify_widget_repository/modify_widget_repository.dart';

class VerifyEmailPage extends StatelessWidget {
  const VerifyEmailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
            color: Colors.black54, borderRadius: BorderRadius.circular(30)),
        padding: const EdgeInsets.all(12.0).r,
        width: 500.w,
        height: 450.h,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(
            'Please verify the email'.tr,
            style: const TextStyle(fontSize: 30),
          ),
          const SizedBox(
            height: 30,
          ),
          TextButton(
              onPressed: () {
                context.read<AuthBloc>().add(
                      const AuthEventSendEmailVerification(),
                    );
              },
              child: Text('send verification'.tr)),
          TextButton(
              onPressed: () {
                context.read<AuthBloc>().add(
                      const AuthEventLogOut(),
                    );
              },
              child: Text('back'.tr)),
        ]),
      ),
    );
  }
}
