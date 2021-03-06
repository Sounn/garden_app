import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shortuuid/shortuuid.dart';
class GardenArguments{
  final TimeOfDay timer;
  final String name;
  GardenArguments(this.name,this.timer);
}
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
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) => _TimeSelectPage(),
                        settings: RouteSettings(
                          arguments: gardenName,
                        ),
                      ));
                  },
                ),
              ),
          ],
        ),
      )
    );
  }
}

class _TimeSelectPage extends StatefulWidget{
  @override
  _TimeSelectPageState createState() => _TimeSelectPageState();
}

class _TimeSelectPageState extends State<_TimeSelectPage>{
  TimeOfDay _time = TimeOfDay.now();

  void _selectTime() async {
    final TimeOfDay picked = await showTimePicker(
        context: context,
        initialTime: _time,
        initialEntryMode: TimePickerEntryMode.input,
    );
    if(picked != null) setState(() {
      _time = picked;

    });
  }

  Widget build(BuildContext context) {
    String gardenName = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
          title:Text(gardenName,style: TextStyle(color: Colors.black)),
          centerTitle: true,
          backgroundColor: Colors.white10,
          elevation: 0.0,
          iconTheme: IconThemeData(
              color: Colors.green,
          ),
        ),
      body:Container(
        child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // ignore: unnecessary_brace_in_string_interps
            Center(child:Text("水やりタイマー")),
            Text('Selected time: ${_time.format(context)}'),
            RaisedButton(
              child: Text('時間選択'),
              color: Colors.green,
              textColor: Colors.white,
              shape: const StadiumBorder(),
              onPressed: () {
                _selectTime();
                }
            ),
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 50.0),
                child: ElevatedButton(
                  child: Text('次へ'),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                  ),
                  onPressed: () async {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) => _ImageUploadPage(),
                        settings: RouteSettings(
                          arguments: GardenArguments(
                            gardenName,
                            _time,
                          )
                        ),
                      ));
                  },
                ),
              ),
          ],
        )
      )
    );
  }
}



class _ImageUploadPage extends StatefulWidget{
  @override
  _ImageUploadPageState createState() => _ImageUploadPageState();
}

class _ImageUploadPageState extends State<_ImageUploadPage> {
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

  Future<void> uploadFile() async {
  final shortUuid = ShortUuid.shortv4();
  try {
    await FirebaseStorage.instance
        .ref()
        .child('uploads/')
        .child(shortUuid + '.png')
        .putFile(_image);
  } on FirebaseException catch (e) {
    print("***");
    print(e);
    print("***");
  }
}

  @override
  Widget build(BuildContext context){
    final GardenArguments args = ModalRoute.of(context).settings.arguments;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white10,
          elevation: 0.0,
          iconTheme: IconThemeData(
              color: Colors.green,//change your color here
          ),
        ),
        body:Container(
              child: (() {
                if ( _image == null ){
                  return Center(child:Text('画像が選択されていません。'));
                } else {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        child:Image.file(_image),
                      ),
                      Container(
                        child:Text(args.name),
                      ),
                      Container(
                        child: ElevatedButton(
                          child: Text('保存する'),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                          ),
                          onPressed: () async {
                            // uploadFile();
                            final shortUuid = ShortUuid.shortv4();
                            final storage = FirebaseStorage.instance;
                            final ref = storage
                                  .ref()
                                  .child('uploads/')
                                  .child(shortUuid + '.png');
                            try {
                              await ref.putFile(_image);
                            } on FirebaseException catch (e) {
                              print("***");
                              print(e);
                              print("***");
                            }
                            final downloadURL = await ref.getDownloadURL();
                            await FirebaseFirestore.instance
                            .collection('gardens') // コレクションID指定
                            .doc() // ドキュメントID自動生成
                            // ignore: deprecated_member_use
                            .setData({
                              'uid': FirebaseAuth.instance.currentUser.uid,
                              'vegetable': args.name,
                              'timer': DateTime(2020,1,1,args.timer.hour, args.timer.minute),
                              'imageURL': downloadURL,
                              'createdAt': DateTime.now(),
                            });// データ
                            Navigator.of(context).pushReplacementNamed("/home");
                          },
                        ),
                      )
                    ]
                  );
              }})(),
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
        ),
    );
  }
}