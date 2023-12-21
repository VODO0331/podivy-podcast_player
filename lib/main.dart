import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:podivy/AccessToken.dart';
import 'package:podivy/service/auth/authProvider.dart.dart';
import 'package:podivy/service/auth/bloc/authBLOC.dart';
import 'package:podivy/theme/theme.dart';
import './routes/router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ScreenUtil.ensureScreenSize();
  await initHiveForFlutter();

  final HttpLink httpLink = HttpLink("https://api.podchaser.com/graphql");
  final AuthLink authLink = AuthLink(getToken: () => 'Bearer $myDevelopToken');
  final Link link = authLink.concat(httpLink);
  final ValueNotifier<GraphQLClient> client = ValueNotifier<GraphQLClient>(
    GraphQLClient(
      link: link,
      cache: GraphQLCache(),
    ),
  );
  runApp(MyApp(
    client: client,
  ));
}

class MyApp extends StatelessWidget {
  final ValueNotifier<GraphQLClient>? client;
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
        client: client,
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
