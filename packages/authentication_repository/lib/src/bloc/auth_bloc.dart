import 'package:authentication_repository/src/bloc/auth_bloc_event.dart';
import 'package:authentication_repository/src/bloc/auth_bloc_state.dart';
import 'package:authentication_repository/src/models/auth_user.dart';
import 'package:bloc/bloc.dart';

import '../service/auth_service.dart';

import 'dart:developer' as dev show log;

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final Map<String, AuthService> providers;
  AuthBloc(this.providers)
      : super(const AuthStateUnInitialized(isLoading: true)) {
    //忘記密碼
    on<AuthEventForgotPassword>((event, emit) async {
      emit(const AuthStateForgotPassword(
        isLoading: false,
        exception: null,
        hasSendEmail: false,
      ));

      final email = event.email;
      if (email == null) {
        emit(const AuthStateForgotPassword(
          isLoading: false,
          exception: null,
          hasSendEmail: false,
        ));
        return; // 用户只是导航到 forgotPasswordPage
      }

      Exception? exception;
      try {
        await providers['Firebase']!.sendPasswordReset(toEmail: email);
        exception = null;
      } on Exception catch (e) {
        exception = e;
      }

      emit(AuthStateForgotPassword(
        isLoading: false,
        exception: exception,
        hasSendEmail: exception == null,
      ));
    });
    //郵件驗證
    on<AuthEventSendEmailVerification>((event, emit) async {
      await providers[event.loginMethod]!.sendEmailVerification();
      emit(const AuthStateLoggedOut(exception: null, isLoading: false));
    });
    //註冊
    on<AuthEventRegister>((event, emit) async {
      final email = event.email;
      final password = event.password;
      final repassword = event.repassword;
      try {
        await providers['Firebase']!.createUser(
          email: email,
          password: password,
          repassword: repassword,
        );
        // await provider.sendEmailVerification();
        emit(const AuthStateNeedVerification(isLoading: false));
      } on Exception catch (e) {
        emit(AuthStateRegistering(
          isLoading: false,
          exception: e,
        ));
      }
    });
    on<AuthEventShouldRegister>(
        (event, emit) => emit(const AuthStateRegistering(
              isLoading: false,
              exception: null,
            )));
    //初始化
    on<AuthEventInitialize>((event, emit) async {
      await providers['Firebase']!.initialize();
      final user = providers['Firebase']!.currentUser;
      if (user == null) {
        emit(
          const AuthStateLoggedOut(
            exception: null,
            isLoading: false,
          ),
        );
      } else if (!user.isEmailVerified) {
        emit(const AuthStateNeedVerification(isLoading: false));
      } else {
        emit(AuthStateLoggedInFormEmail(
          isLoading: false,
          user: user,
        ));
      }
    });
    //登入
    on<AuthEventLogIn>((event, emit) async {
      emit(
        const AuthStateLoggedOut(
          exception: null,
          isLoading: true,
          loadingText: '登入中請稍後...',
        ),
      );
      final email = event.email;
      final password = event.password;
      final loginMethod = event.loginMethod;

      try {
        late final AuthUser user;
        switch (loginMethod) {
          case 'Firebase':
            user = await providers['Firebase']!.login(
              email: email,
              password: password,
            );
            if (!user.isEmailVerified) {
              emit(
                const AuthStateLoggedOut(
                  exception: null,
                  isLoading: false,
                ),
              );
              emit(const AuthStateNeedVerification(
                isLoading: false,
              ));
            } else {
              emit(AuthStateLoggedInFormEmail(
                isLoading: false,
                user: user,
              ));
            }
          case 'Google':
            user = await providers['Google']!.login(
              email: email,
              password: password,
            );
            if (user.id == '') {
              emit(const AuthStateLoggedOut(
                exception: null,
                isLoading: false,
              ));
            } else {
              emit(AuthStateLoggedInFormGoogle(
                isLoading: false,
                user: user,
              ));
            }

          default:
            emit(
              AuthStateLoggedOut(
                exception: Exception(['logMethod error']),
                isLoading: false,
              ),
            );
        }
      } on Exception catch (e) {
        emit(
          AuthStateLoggedOut(
            exception: e,
            isLoading: false,
          ),
        );
      }
    });
    //登出
    on<AuthEventLogOut>((event, emit) async {
      try {
        await providers[event.loginMethod]!.logOut();
        emit(
          const AuthStateLoggedOut(
            exception: null,
            isLoading: false,
          ),
        );
      } on Exception catch (e) {
        emit(AuthStateLoggedOut(
          exception: e,
          isLoading: false,
        ));
      }
    });
    //註銷
    on<AuthEventDeleteUser>((event, emit) async {
      try {
        dev.log(event.loginMethod, name: 'DeleteUser : loginMethod');
        await providers[event.loginMethod]!.deleteUser();

        emit(
          const AuthStateLoggedOut(
            exception: null,
            isLoading: false,
          ),
        );
      } on Exception catch (e) {
        emit(AuthStateLoggedOut(
          exception: e,
          isLoading: false,
        ));
      }
    });
  }
}
