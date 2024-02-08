import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:podivy/Controller/ClientGlobalController.dart';
import 'package:podivy/service/auth/authProvider.dart.dart';
import 'package:podivy/service/auth/bloc/authBLOC.dart';
import 'package:podivy/theme/theme.dart';
import './routes/router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ScreenUtil.ensureScreenSize();
  await initHiveForFlutter();

  final ClientGlobalController clientController = ClientGlobalController();
  Get.put(clientController);
  runApp(MyApp(client: clientController.client));
}

class MyApp extends StatelessWidget {
  final GraphQLClient? client;
  const MyApp({super.key, required this.client});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp, // 竖屏向上
      DeviceOrientation.portraitDown, // 竖屏向下
    ]);

    return BlocProvider<AuthBloc>(
      create: (context) => AuthBloc(FirebaseAuthProvider()),
      child: GraphQLProvider(
        client: ValueNotifier(client!),
        child: ScreenUtilInit(
          designSize: const Size(393, 852),
          minTextAdapt: true,
          splitScreenMode: true,
          child: GetMaterialApp(
            title: 'Podivy',
            theme: myTheme,
            initialRoute: '/',
            unknownRoute: GetPage(
                name: '/notfound', page: () => const UnknownRoutePage()),
            getPages: RouterPage.routes,
          ),
        ),
      ),
    );
  }
}

class UnknownRoutePage extends StatelessWidget {
  const UnknownRoutePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        width: 500,
        height: 500,
        child: Text(
          'Page not find!!!!!!!!',
          style: TextStyle(color: Colors.red),
        ),
      ),
    );
  }
}
