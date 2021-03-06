import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// ignore: unused_shown_name
import 'dart:io' show File, Platform;
import 'package:rxdart/subjects.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

final BehaviorSubject<ReceiveNotification>didReceivedLocalNotficationSubject =
    BehaviorSubject<ReceiveNotification>();

final BehaviorSubject<String> selectNotificationSubject =
    BehaviorSubject<String>();
class NotificationPlugin{
  var initializationSettings;
  //初期化
  NotificationPlugin._(){
    init();
  }

  init() async{
    if(Platform.isIOS){
      _requestIOSPermission();
    }
    initialzePlatformSpecifics();
  }

  initialzePlatformSpecifics() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('app_icon');
    final IOSInitializationSettings initializationSettingsIOS =
    IOSInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      onDidReceiveLocalNotification: (int id, String title, String body, String payload) async {
          ReceiveNotification receivedNotification = 
          ReceiveNotification(id: id, title: title, body: body, payload: payload);
          didReceivedLocalNotficationSubject.add(receivedNotification);
      },
    );
    const MacOSInitializationSettings initializationSettingsMacOS =
        MacOSInitializationSettings(
            requestAlertPermission: false,
            requestBadgePermission: false,
            requestSoundPermission: false);
    final InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
        macOS: initializationSettingsMacOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String payload) async {
      if (payload != null) {
        debugPrint('notification payload: $payload');
      }
      selectNotificationSubject.add(payload);
    });
  }

  //通知権限リクエスト
  _requestIOSPermission() async {
      flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
  }

  // ignore: non_constant_identifier_names
  SetListenerForLowerVersions(Function onNotificationInLowerVersions){
    didReceivedLocalNotficationSubject.listen((receivedNotification){
      onNotificationInLowerVersions(receivedNotification);
    });
  }

  // setOnNotificationClick(Function onNotificationClik) async {
  //   await flutterLocalNotificationsPlugin.initialize(initializationSettings,
  //   onSelectNotification:(String payload) async {
  //     onNotificationClik(payload);
  //   });
  // }

  Future<void> repeatNotification() async {
      var androidChannelSpecifics = AndroidNotificationDetails(
        'CHANNEL_ID 3',
        'CHANNEL_NAME 3',
        "CHANNEL_DESCRIPTION 3",
        importance: Importance.max,
        priority: Priority.high,
        styleInformation: DefaultStyleInformation(true, true),
      );
      var platformChannelSpecifics =
          NotificationDetails(android: androidChannelSpecifics);
      await flutterLocalNotificationsPlugin.periodicallyShow(
            0,
            'Repeating Test Title',
            'Repeating Test Body',
            RepeatInterval.everyMinute,
        platformChannelSpecifics,
        payload: 'Test Payload',
      );
    }
  Future<void> showNotification() async {
      const androidChannelSpecifics = AndroidNotificationDetails(
        'CHANNEL_ID',
        'CHANNEL_NAME',
        "CHANNEL_DESCRIPTION",
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker',
        styleInformation: DefaultStyleInformation(true, true),
      );
      const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidChannelSpecifics);
      await flutterLocalNotificationsPlugin.show(
        0,  // Notification ID
        'Test Title', // Notification Title
        'Test Body', // Notification Body, set as null to remove the body
        platformChannelSpecifics,
        payload: 'New Payload', // Notification Payload
      );
  }
}

NotificationPlugin notificationPlugin = NotificationPlugin._();



class ReceiveNotification{
  ReceiveNotification({
    @required this.id,
    @required this.title,
    @required this.body,
    @required this.payload,
  });

  final int id;
  final String title;
  final String body;
  final String payload;
}