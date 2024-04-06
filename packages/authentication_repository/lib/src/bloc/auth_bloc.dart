import 'package:authentication_repository/src/bloc/auth_bloc_event.dart';
import 'package:authentication_repository/src/bloc/auth_bloc_state.dart';
import 'package:authentication_repository/src/models/auth_provider.dart.dart';
import 'package:bloc/bloc.dart';


class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthProvider provider)
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
        return ; // 用户只是导航到 forgotPasswordPage
      }

      Exception? exception;
      try {
        await provider.sendPasswordReset(toEmail: email);
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
      await provider.sendEmailVerification();
      emit(state);
    });
    //註冊
    on<AuthEventRegister>((event, emit) async {
      final email = event.email;
      final password = event.password;
      final repassword = event.repassword;
      try {
        await provider.createUser(
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
      await provider.initialize(); 
      final user = provider.currentUser;
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
        emit(AuthStateLoggedIn(
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
      try {
        final user = await provider.login(
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
        }
        emit(AuthStateLoggedIn(
          isLoading: false,
          user: user,
        ));
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
        await provider.logOut();
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
