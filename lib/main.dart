import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:internationalization_repository/internationalization.dart';
import 'package:modify_widget_repository/modify_widget_repository.dart';
import 'package:my_audio_player/my_audio_player.dart';
import 'package:podivy/Page/login/auth_middleware.dart';
import 'package:provider/provider.dart';
import 'package:search_service/search_service_repository.dart';

import './routes/router.dart';
import 'theme/theme.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Provider.debugCheckInvalidValueType = null;
  await GetStorage.init();
  final storage = GetStorage();
  final locale = Locale.fromSubtags(
      languageCode: storage.read('language') ?? 'en',
      countryCode: storage.read('location') ?? "US");
  final isDarkMode = storage.read('darkMode') ?? true;

  await dotenv.load(fileName: '.env');

  final ValueNotifier<GraphQLClient> client =
      ClientController().initialize(dotenv.get('myDevelopToken'));
  runApp(MyApp(
    locale: locale,
    isDarkMode: isDarkMode,
    client: client,
  ));
}

class MyApp extends StatelessWidget {
  final Locale locale;
  final bool isDarkMode;
  final ValueNotifier<GraphQLClient> client;
  const MyApp({
    super.key,
    required this.locale,
    required this.isDarkMode,
    required this.client,
  });

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
            create: (context) => AuthBloc({
              'Firebase': AuthService.firebase(),
              'Google': AuthService.google(),
            })),
        Provider(
          create: (context) => MyAudioPlayer(),
          dispose: (context, value) => value.dispose(),
          lazy: true,
        ),
      ],
      child: GraphQLProvider(
        client: client,
        child: GetMaterialApp(
          builder: BotToastInit(),
          home: const AuthMiddleWare(),
          navigatorObservers: [BotToastNavigatorObserver()],
          initialBinding: MainBinding(),
          translations: TranslationService(),
          locale: locale,
          fallbackLocale: const Locale('en', 'US'),
          title: 'Podivy',
          themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
          theme: lightTheme,
          darkTheme: darkTheme,
          initialRoute: '/',
          unknownRoute:
              GetPage(name: '/notFound', page: () => const UnknownRoutePage()),
          getPages: RouterPage.routes,
        ),
      ),
    );
  }
}

class MainBinding implements Bindings {
  @override
  void dependencies() async {
    await JustAudioBackground.init(
      androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
      androidNotificationChannelName: 'Audio playback',
      androidNotificationOngoing: true,
    );
    await initHiveForFlutter();
    await ScreenUtil.ensureScreenSize();
  }
}

class UnknownRoutePage extends StatelessWidget {
  const UnknownRoutePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 500,
        height: 500,
        child: Text(
          'PageError'.tr,
          style: const TextStyle(color: Colors.red),
        ),
      ),
    );
  }
}
