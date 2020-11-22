import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'users/sign_up.dart';
import 'users/login_page.dart';
import 'users/setting_page.dart';
import 'gardens/garden_list_page.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: CheckAuth(),
      routes: <String, WidgetBuilder> {
      '/home': (BuildContext context) => GardenListPage(),
      '/sign_up': (BuildContext context) => SignUpPage(),
      '/login':(BuildContext context) => LoginPage(),
      '/login_check':(BuildContext context) => CheckAuth(),
      '/settings':(BuildContext context) => UserSettingPage(),
    },
    );
  }
}

class CheckAuth extends StatefulWidget {
  @override
  _CheckAuthState createState() => _CheckAuthState();
}

class _CheckAuthState extends State<CheckAuth> {
  bool isnotLoggedIn = false;
  @override
  void initState() {
    FirebaseAuth.instance.authStateChanges().listen((User user) {
      if (user == null) {
        setState(() {isnotLoggedIn = true;});
      }
    },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isnotLoggedIn ? LoginOrSigninPage() : GardenListPage();
  }
}
class LoginOrSigninPage extends StatefulWidget {
  @override
  _LoginOrSigninPageState createState() => _LoginOrSigninPageState();
}

class _LoginOrSigninPageState extends State<LoginOrSigninPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ホーム'),
        backgroundColor: Colors.green,
      ),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: <Widget>[
          Container(
            height: 50,
            color: Colors.amber[600],
            child: TextButton(
              child: Text('アカウント作成'),
              onPressed: (){
                Navigator.pushNamed(context , '/sign_up');
              }
            ),
          ),
          Container(
            height: 50,
            color: Colors.amber[500],
            child: TextButton(
              child: Text('ログインする'),
              onPressed: (){
                Navigator.pushNamed(context , '/login');
              }
            ),
          ),
        ],
      )
    );
  }
}
