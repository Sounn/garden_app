import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'user/sign_up.dart';
import 'user/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
      routes: <String, WidgetBuilder> {
      '/home': (BuildContext context) => HomePage(),
      '/sign_up': (BuildContext context) => SignUpPage(),
      '/login':(BuildContext context) => LoginPage(),
    },
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
        Container(
          height: 50,
          color: Colors.amber[100],
          child: TextButton(
            child: Text('ログアウト'),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              print('ログアウトしました');
            }
          ),
        ),
      ],
      )
    );
  }
}