import 'NotificationPlugin.dart';
import 'package:flutter/material.dart';

class SendNotification extends StatefulWidget{
  @override
  _SendNotificationState createState() => _SendNotificationState();
}

class _SendNotificationState extends State<SendNotification> {
  void initState(){
    super.initState();
    // notificationPlugin
    //   .SetListenerForLowerVersions(onNotificationInLowerVersions);
    // notificationPlugin.setOnNotificationClick(onNotificationClick);
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('通知'),
        backgroundColor: Colors.green,
      ),
      body:Center(
        child: ElevatedButton(
          child: Text('通知の送信する'),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
          ),
          onPressed: () async {
            await notificationPlugin.showNotification();
          }
      ),)
    );
  }

  onNotificationInLowerVersions(ReceiveNotification rececedNotification){}

  //通知をクリックした時の処理
  onNotificationClick(String payload){}
}