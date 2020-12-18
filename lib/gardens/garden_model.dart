import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'garden.dart';
import 'package:firebase_auth/firebase_auth.dart';
class GardenModel extends ChangeNotifier {
  List<Garden> gardens = []; 
  final user = FirebaseAuth.instance.currentUser;

  Future fetchGardens() async {
    // ignore: deprecated_member_use
    final docs = await FirebaseFirestore.instance.collection('gardens').where('uid', isEqualTo: user.uid).getDocuments();
    // ignore: deprecated_member_use
    final gardens = docs.documents.map((doc) => Garden(doc)).toList();
    this.gardens = gardens;
    notifyListeners();
  }
}