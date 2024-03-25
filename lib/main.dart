import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:internationalization_repository/internationalization.dart';
import 'package:modify_widget_repository/modify_widget_repository.dart';
import 'package:my_audio_player/my_audio_player.dart';
import 'package:search_service/search_service_repository.dart';

import './routes/router.dart';
import 'theme/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  final storage = GetStorage();
  final test = Locale.fromSubtags(
      languageCode: storage.read('language') ?? 'en',
      countryCode: storage.read('location') ?? "US");

  await ScreenUtil.ensureScreenSize();
  await initHiveForFlutter();

  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
  runApp(MyApp(locale: test));
}

class MyApp extends StatelessWidget {
  final Locale locale;
  MyApp({
    super.key,
    required this.locale,
  });
  final clientController = Get.put(ClientGlobalController());
  final storage = GetStorage();

  final RxBool isDarkMode = true.obs;

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
            onInit: () {
              isDarkMode.value = storage.read('darkMode') ?? true;
          
            },
            translations: TranslationService(),
            locale: locale,
            fallbackLocale: const Locale('en', 'US'),
            title: 'Podivy',
            themeMode: isDarkMode.value ? ThemeMode.dark : ThemeMode.light,
            theme: lightTheme,
            darkTheme: darkTheme,
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
