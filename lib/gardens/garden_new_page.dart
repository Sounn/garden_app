import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class GardenNewPage extends StatefulWidget {
  @override
  _GardenNewPageState createState() => _GardenNewPageState();
}

class _GardenNewPageState extends State<GardenNewPage> {
  String gardenName;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white10,
          elevation: 0.0,
          iconTheme: IconThemeData(
              color: Colors.green,
          ),
        ),
        body: Container(
        child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Text("育てる植物の名前を教えてください",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      color: Colors.black,
                      ),
                    )
            ),
            Container(child:
              TextFormField(
                enabled: true,
                decoration: InputDecoration(
                  icon: Icon(Icons.filter_vintage,color: Colors.green),
                  labelText: '植物の名前 *',
                  labelStyle:TextStyle(color: Colors.green),
                ),
                onChanged: (String value) {
                    gardenName = value;
                },
              ),
            ),
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 50.0),
                child: ElevatedButton(
                  child: Text('次へ'),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                  ),
                  onPressed: () async {
                    Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => _ImageUploadPage()));
                  },
                ),
              ),
          ],
        ),
      )
    );
  }
}

class _ImageUploadPage extends StatefulWidget{
  @override
  __ImageUploadPageState createState() => __ImageUploadPageState();
}

class __ImageUploadPageState extends State<_ImageUploadPage> {
  @override
  Widget build(BuildContext context){
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white10,
          elevation: 0.0,
          iconTheme: IconThemeData(
              color: Colors.green,//change your color here
          ),
        ),
        body:Container(
          child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
            // mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                child: Text("写真",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        color: Colors.black,
                        ),
                      )
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 50.0),
                  child: ElevatedButton(
                    child: Text('次へ'),
                    onPressed: () async {
                      Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => _ImageUploadPage()));
                    },
                  ),
                ),
            ],
          ),
        )
    );
  }
}