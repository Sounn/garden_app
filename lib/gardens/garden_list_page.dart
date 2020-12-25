import 'package:flutter/material.dart';
import 'garden_model.dart';
import 'garden.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GardenListPage extends StatefulWidget {
  @override
  _GardenListPageState createState() => _GardenListPageState();
}
class _GardenListPageState extends State<GardenListPage> {
  int _selectedIndex = 0;

  List<Widget> _widgetOptions = <Widget>[
    Center(child: _HomeOption(),
    ),
    Center(child: _AlertOption(),
    ),
    Center(child: _AccountOption(),
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center( child: _widgetOptions.elementAt(_selectedIndex),),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'ホーム',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_alert_outlined),
            label: 'お知らせ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_box),
            label: 'マイページ',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
        ),
    );
  }
  Future updateGarden(Garden garden,BuildContext context) async {
    final document = FirebaseFirestore.instance.collection('gardens').doc(garden.documentID);
    await document.delete();
  }
}

class _HomeOption extends StatelessWidget{ //ホームページ
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('野菜一覧'),
        backgroundColor: Colors.green,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.restore_from_trash),
            onPressed: (){
              print("消去する");
            },
          ),
        ],
      ),
      body: ChangeNotifierProvider<GardenModel>(
        create: (_) => GardenModel()..fetchGardens(),
        child: Consumer<GardenModel>(
          builder: (context, model, child) {
            final gardens = model.gardens;
            final listTiles = gardens
              .map(
                (garden) => Container(
                    color: Colors.white,
                    child: ListTile(
                            leading: Image.network(garden.imageURL),
                            title: Text(garden.vegetable),
                            onTap: (){
                              Navigator.of(context).pushNamed("/vegetable", arguments: garden.documentID);
                            },
                          ),
                  ),
              ).toList();
            return ListView(
              children: listTiles,
            ); 
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.of(context).pushNamed("/new");
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }
}

class _AlertOption extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('通知  |  ニュース'),
        backgroundColor: Colors.green,
      ),
      body:Center(
        child: FlatButton(
        onPressed: (){

        },
        child:Text("通知の送信"),
      ),)
    );
  }
}

class _AccountOption extends StatelessWidget{
  @override
  Widget build(BuildContext context){
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