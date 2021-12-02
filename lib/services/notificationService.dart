
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';



class NotificationService {
  //Singleton pattern
  static final NotificationService _notificationService =
  NotificationService._internal();
  factory NotificationService() {
    return _notificationService;
  }
  NotificationService._internal();

  //instance of FlutterLocalNotificationsPlugin
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  Future<void> init() async {

    //Initialization Settings for Android
    final AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    //Initialization Settings for iOS
    final IOSInitializationSettings initializationSettingsIOS =
    IOSInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );

    //InitializationSettings for initializing settings for both platforms (Android & iOS)
    final InitializationSettings initializationSettings =
    InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,onSelectNotification:(String payload) async {
      if (payload != null) {
        print('notification payload: $payload');
      }
    }
    );

  }
  void requestIOSPermissions(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }
  static const AndroidNotificationDetails _androidNotificationDetails =
  AndroidNotificationDetails(
    'channel ID',
    'channel name',
    playSound: true,
    priority: Priority.high,
    importance: Importance.high,
    channelAction: AndroidNotificationChannelAction.createIfNotExists,

  );
  // IOSNotificationDetails _iosNotificationDetails = IOSNotificationDetails(
  //     presentAlert: true,
  //     presentBadge: true,
  //     presentSound: bool,
  //     badgeNumber: int?
  //     attachments: List<IOSNotificationAttachment>?
  //     subtitle: String?,
  //     threadIdentifier: String?
  // );
  static const NotificationDetails platformChannelSpecifics =
  NotificationDetails(
    android: _androidNotificationDetails,);

  Future<void> showNotifications(RemoteMessage message) async {
    await flutterLocalNotificationsPlugin.show(
        message.hashCode,
        message.notification.title,
        message.notification.body,
        platformChannelSpecifics,
        payload: "${message.data["order_id"]}",
    );
  }
  void listenAndDisplay(){
    FirebaseMessaging.instance.isAutoInitEnabled;
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null) {
        NotificationService().showNotifications(message);
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      print("onMessageOpenedApp: ${message.data["order_id"]}");
    });
  }
}