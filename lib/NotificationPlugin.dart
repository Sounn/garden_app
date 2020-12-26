import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// ignore: unused_shown_name
import 'dart:io' show File, Platform;
import 'package:rxdart/subjects.dart';

class NotificationPlugin{
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  var initializationSettings;

  final BehaviorSubject<ReceiveNotification>
    didReceivedLocalNotficationSubject =
     BehaviorSubject<ReceiveNotification>();
  //初期化
  NotificationPlugin._(){
    init();
  }

  init() async{
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    if(Platform.isIOS){
      _requestIOSPermission();
    }
    initialzePlatformSpecifics();
  }

  initialzePlatformSpecifics(){
    const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('app_icon');
    final IOSInitializationSettings initializationSettingsIOS =
    IOSInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: true,
      requestAlertPermission: true,
      onDidReceiveLocalNotification: (id, title, body, payload) async {
          ReceiveNotification receivedNotification = 
          ReceiveNotification(id: id, title: title, body: body, payload: payload);
          didReceivedLocalNotficationSubject.add(receivedNotification);
      },
    );

    // final MacOSInitializationSettings initializationSettingsMacOS =
    //     MacOSInitializationSettings(
    //         requestAlertPermission: true,
    //         requestBadgePermission: true,
    //         requestSoundPermission: false);

    initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
      // macOS: initializationSettingsMacOS
    );
  }

  //通知権限リクエスト
  _requestIOSPermission() async {
      flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: false,
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

  setOnNotificationClick(Function onNotificationClik) async {
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
    onSelectNotification:(String payload) async {
      onNotificationClik(payload);
    });
  }

  Future<void> repeatNotification() async {
      var androidChannelSpecifics = AndroidNotificationDetails(
        'CHANNEL_ID 3',
        'CHANNEL_NAME 3',
        "CHANNEL_DESCRIPTION 3",
        importance: Importance.max,
        priority: Priority.high,
        styleInformation: DefaultStyleInformation(true, true),
      );
      var iosChannelSpecifics = IOSNotificationDetails();
      var platformChannelSpecifics =
          NotificationDetails(android: androidChannelSpecifics, iOS: iosChannelSpecifics);
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
      var androidChannelSpecifics = AndroidNotificationDetails(
        'CHANNEL_ID',
        'CHANNEL_NAME',
        "CHANNEL_DESCRIPTION",
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        timeoutAfter: 5000,
        styleInformation: DefaultStyleInformation(true, true),
      );
      var iosChannelSpecifics = IOSNotificationDetails();
      var platformChannelSpecifics =
          NotificationDetails(android: androidChannelSpecifics, iOS: iosChannelSpecifics);
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
  final int id;
  final String title;
  final String body;
  final String payload;

  ReceiveNotification({
    @required this.id,
    @required this.title,
    @required this.body,
    @required this.payload,
  });
}