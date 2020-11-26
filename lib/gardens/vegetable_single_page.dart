import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
            backgroundColor: Colors.green,
          ),
          body:Text(snapshot.data["vegetable"])
        );
    },
  );
  }
}