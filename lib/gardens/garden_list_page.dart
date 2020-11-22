import 'package:flutter/material.dart';
import 'garden_model.dart';
import 'garden.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
class GardenListPage extends StatelessWidget {
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
                            Navigator.of(context).pushNamed("/update", arguments: garden);
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
    );
  }
  Future updateGarden(Garden garden,BuildContext context) async {
    final document = FirebaseFirestore.instance.collection('gardens').doc(garden.documentID);
    await document.delete();
  }
}