import 'package:authentication_repository/authentication_repository.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:modify_widget_repository/modify_widget_repository.dart';
import 'package:podivy/theme/theme.dart';
import 'package:search_service/search_service_repository.dart';

import './routes/router.dart';


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
      create: (context) =>  AuthBloc(FirebaseAuthProvider()),
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
                name: '/notFound', page: () => const UnknownRoutePage()),
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
