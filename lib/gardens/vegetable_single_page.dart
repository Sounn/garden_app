import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
class VegetableSinglePage extends StatefulWidget {
  @override
  _VegetableSinglePageState createState() => _VegetableSinglePageState();
}

class _VegetableSinglePageState extends State<VegetableSinglePage> {
  @override
  Widget build(BuildContext context) {
    final docId = ModalRoute.of(context).settings.arguments;
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('gardens').doc(docId).snapshots(),
      builder: (context, snapshot) {
        return Scaffold(
          appBar: AppBar(
            title: Text(snapshot.data["vegetable"]),
            centerTitle: true,
            backgroundColor: Colors.green,
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: (){
                  //編集ページに
                  print("編集する");
                },
              ),
              IconButton(
                icon: Icon(Icons.restore_from_trash),
                onPressed: (){
                  //モーダルで消去するかを確認
                  print("消去する");
                },
              ),
            ],
          ),
          body:Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                child: Image.network(snapshot.data["imageURL"]),
              ),
              Container(
                child: Text('次の水やり　：　')
              ),
              Container(
                child: Text('植えてから何日目　：　')
              ),
              Container(
                child: Text('植えた日' + DateFormat('yyyy-MM-dd')
                            .format(snapshot.data["createdAt"].toDate())
                            .toString()
                            ),
              ),
            ]
          ),
        );
    },
  );
  }
}