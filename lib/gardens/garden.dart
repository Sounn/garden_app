import 'package:cloud_firestore/cloud_firestore.dart';
class Garden{
  Garden(QueryDocumentSnapshot doc){
    // ignore: deprecated_member_use
    documentID = doc.documentID;
    uid = doc['uid'];
    vegetable = doc['vegetable'];
    imageURL = doc['imageURL'];
  }

  String documentID;
  String uid;
  String vegetable;
  String imageURL;
}