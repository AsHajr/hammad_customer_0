
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hammad_customer_0/home/home_screen.dart';
import 'package:hammad_customer_0/services/AuthState.dart';
import 'package:hammad_customer_0/services/auth.dart';
import 'package:hammad_customer_0/services/cartProvider.dart';
import 'package:hammad_customer_0/services/notificationService.dart';
import 'package:hammad_customer_0/splash_screen.dart';
import 'package:hammad_customer_0/theme.dart';
import 'package:hammad_customer_0/translations/codegen_loader.g.dart';

import 'package:provider/provider.dart';
void _enablePlatformOverrideForDesktop() {
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux)) {
    debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  }
}
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseDatabase.instance.setPersistenceEnabled(true);
  _enablePlatformOverrideForDesktop();
  await EasyLocalization.ensureInitialized();
  await NotificationService().init();
  NotificationService().listenAndDisplay();
  // await NotificationService().requestIOSPermissions();

  runApp(
      EasyLocalization(
      supportedLocales: [Locale('en', ''), Locale('ar', '')],
      path: 'assets/translations', // <-- change the path of the translation files
      fallbackLocale: Locale('en', ''),
      assetLoader: CodegenLoader(),
      child:
      MyApp()
  )
  );
}
class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {

    return
      MultiProvider(
        providers: [
          StreamProvider.value(
            value: AuthService().user,
            initialData: null,
          ),
          ChangeNotifierProvider<AuthUpdating>(
            create: (_) => AuthUpdating(),
          ),
          StreamProvider(
              initialData: null,
              create: (context) => Connectivity().onConnectivityChanged
          ),
          ChangeNotifierProvider<CartProvider>(
              create: (context) => CartProvider(),
            child: HomeScreen(),
          ),
        ],
        child: MaterialApp(
          theme: theme(),
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          home: SplashScreen(),
        ),
      );
  }
  // Future<void> setupInteractedMessage() async {
  //   // Get any messages which caused the application to open from
  //   // a terminated state.
  //   RemoteMessage initialMessage =
  //   await FirebaseMessaging.instance.getInitialMessage();
  //
  //   // If the message also contains a data property with a "type" of "chat",
  //   // navigate to a chat screen
  //   if (initialMessage != null) {
  //     _handleMessage(initialMessage);
  //   }
  //
  //   // Also handle any interaction when the app is in the background via a
  //   // Stream listener
  //   FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  // }
  //
  // void _handleMessage(RemoteMessage message) {
  //   if (message.data['type'] == 'chat') {
  //     Navigator.pushNamed(context, '/chat',
  //       arguments: ChatArguments(message),
  //     );
  //   }
  // }
}


