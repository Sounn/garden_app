import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'garden.dart';

class GardenModel extends ChangeNotifier {
  List<Garden> gardens = [];
  String todoText = ''; 

  Future fetchGardens() async {
    // ignore: deprecated_member_use
    final docs = await FirebaseFirestore.instance.collection('gardens').getDocuments();
    // ignore: deprecated_member_use
    final gardens = docs.documents.map((doc) => Garden(doc)).toList();
    this.gardens = gardens;
    notifyListeners();
  }
}