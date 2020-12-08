import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

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
  File _image;
  final picker = ImagePicker();

  Future chooseImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

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
        body:Center(
              child: _image == null
                  ? Text('画像が選択されていません。')
                  : Image.file(_image),
            ),
            floatingActionButton: Column(
              verticalDirection: VerticalDirection.up, // childrenの先頭を下に配置
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                FloatingActionButton(
                  heroTag: "hero1",
                  onPressed: getImage,
                  tooltip: 'Pick Image',
                  child: Icon(Icons.add_a_photo)
                  // backgroundColor: Colors.redAccent,
                ),
                Container( // 余白のためContainerでラップ
                  margin: EdgeInsets.only(bottom: 16.0), 
                  child: FloatingActionButton(
                    heroTag: "hero2",
                    onPressed: chooseImage,
                    tooltip: 'Pick Image',
                    child: Icon(Icons.photo_album),
                    // backgroundColor: Colors.amberAccent,
                  ),
                ),
              ], 
            )
    );
  }
}
// Container(
//           child:Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             // mainAxisSize: MainAxisSize.min,
//             children: <Widget>[
//               Container(
//                 child: Text("写真",
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 25,
//                         color: Colors.black,
//                         ),
//                       )
//               ),
//               Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 50.0),
//                   child: ElevatedButton(
//                     child: Text('次へ'),
//                     onPressed: () async {
//                       Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => _ImageUploadPage()));
//                     },
//                   ),
//                 ),
//             ],
//           ),
//         )