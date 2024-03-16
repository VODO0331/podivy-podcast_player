import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:modify_widget_repository/modify_widget_repository.dart';
import 'package:podivy/theme/theme.dart';
import 'package:search_service/search_service_repository.dart';

import './routes/router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await ScreenUtil.ensureScreenSize();
  await initHiveForFlutter();
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final clientController = Get.put(ClientGlobalController());
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return BlocProvider<AuthBloc>(
      create: (context) => AuthBloc(FirebaseAuthProvider()),
      child: GraphQLProvider(
        client: ValueNotifier(clientController.client),
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
