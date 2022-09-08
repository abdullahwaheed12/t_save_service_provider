import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:t_save_sp/controller/local_notification.dart';
import 'package:t_save_sp/firebase_options.dart';
import 'package:t_save_sp/modules/sign_up/logic.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'controller/general_controller.dart';
import 'modules/splash/view.dart';
import 'route_generator.dart';
import 'utils/theme.dart';

Future<void> _firebaseMessagingBackgroundHandler(
  RemoteMessage message,
) async {
  // LocalNotificationService.display(message);

  print('background message :  ${message.messageId}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await GetStorage.init();

  Get.put(GeneralController());
  Get.put(SignUpLogic());
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    /// on app closed
    FirebaseMessaging.instance.getInitialMessage();

    ///forground messages
    FirebaseMessaging.onMessage.listen((message) {
      print('A bg message just showed up :  ${message.messageId}');
      try {
        LocalNotificationService.initialize(context);
        LocalNotificationService.display(message);
      } catch (e) {
        print('exception in notification ${e.toString()}');
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      log('Notifications--->>$message');
    });
    SystemChrome.setPreferredOrientations(<DeviceOrientation>[
      DeviceOrientation.portraitUp,
    ]);

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashPage(),
      getPages: routes(),
      themeMode: ThemeMode.light,
      theme: lightTheme(),
    );
  }
}
