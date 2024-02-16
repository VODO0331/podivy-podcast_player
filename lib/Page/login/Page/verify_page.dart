import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          
            const Text('請驗證電子郵件',style: TextStyle(fontSize: 30),),
            const SizedBox(height: 30,),
            TextButton(
                onPressed: () {
                  context.read<AuthBloc>().add(
                        const AuthEventSendEmailVerification(),
                      );
                },
                child: const Text('傳送驗證')),
            TextButton(
                onPressed: () {
                  context.read<AuthBloc>().add(
                        const AuthEventLogOut(),
                      );
                },
                child: const Text('返回')),
          ]),
      ),
    );
    
  }
}
