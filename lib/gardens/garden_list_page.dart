import 'package:flutter/material.dart';
import 'garden_model.dart';
import 'garden.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class GardenListPage extends StatefulWidget {
  @override
  _GardenListPageState createState() => _GardenListPageState();
}
class _GardenListPageState extends State<GardenListPage> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  // ignore: unused_field
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      '',
      style: optionStyle,
    ),
    Text(
      '設定ページ',
      style: optionStyle,
    ),
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GardenModel>(
      create: (_) => GardenModel()..fetchGardens(),
      child: Scaffold(
            appBar: AppBar(
            title: Text('野菜一覧'),
            backgroundColor: Colors.green,
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.settings),
                onPressed: (){
                    Navigator.pushNamed(context , '/settings');
                },
              ),
            ],
            ),
            body: Consumer<GardenModel>(
              builder: (context, model, child) {
                final gardens = model.gardens;
                final listTiles = gardens
                  .map(
                    (garden) => Container(
                        color: Colors.white,
                        child: ListTile(
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
            bottomNavigationBar: BottomNavigationBar(
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.settings),
                    label: 'settings',
                  ),
                ],
                currentIndex: _selectedIndex,
                selectedItemColor: Colors.amber[800],
                onTap: _onItemTapped,
              ),
      ),
    );
  }
  Future updateGarden(Garden garden,BuildContext context) async {
    final document = FirebaseFirestore.instance.collection('gardens').doc(garden.documentID);
    await document.delete();
  }
}