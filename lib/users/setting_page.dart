import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserSettingPage extends StatefulWidget {
  @override
  _UserSettingPageState createState() => _UserSettingPageState();
}

class _UserSettingPageState extends State<UserSettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('設定'),
        backgroundColor: Colors.green,
      ),
      body:Center( 
        child: TextButton(
          child: Text('ログアウト'),
          onPressed: () async {
            await FirebaseAuth.instance.signOut();
            print('ログアウトしました');
            Navigator.pushNamed(context , '/login_check');
          }
        ),
      )
    );
  }
}