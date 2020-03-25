import 'dart:io';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:record_mp3/record_mp3.dart';

class AddAudio extends StatefulWidget {
  @override
  _AddAudioState createState() => _AddAudioState();
}

class _AddAudioState extends State<AddAudio> {
  String statusText = "";
  bool isComplete = false;
  bool isRecorded = false;
  Directory dir;
  File file;

  String audioDirectory = "";

  bool isLoading = false;


   _showDialog(String textShow) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Alert"),
          content: new Text(textShow),
          actions: <Widget>[

            new FlatButton(
              child: new Text("Ok"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
    title: Text('Add Motivational Audio'),
    ),
    body : Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: GestureDetector(
                  child: Container(
                    height: 48.0,
                    decoration: BoxDecoration(color: Colors.red.shade300),
                    child: Center(
                      child:
                      Text(
                        'Start Recording',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  onTap: () async {
                    isRecorded ? _showDialog("Please click on Reset button to Start the new Audio Recording") : startRecord();
                  },
                ),
              ),
              Expanded(
                child: GestureDetector(
                  child: Container(
                    height: 48.0,
                    decoration: BoxDecoration(color: Colors.blue.shade300),
                    child: Center(
                      child: Text(
                        RecordMp3.instance.status == RecordStatus.PAUSE
                            ? 'Resume Recording'
                            : 'Pause Recording',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  onTap: () {
                    pauseRecord();
                  },
                ),
              ),
              Expanded(
                child: GestureDetector(
                  child: Container(
                    height: 48.0,
                    decoration: BoxDecoration(color: Colors.green.shade300),
                    child: Center(
                      child: Text(
                        'Stop Recording',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  onTap: () {
                    stopRecord();
                  },
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Text(
              statusText,
              style: TextStyle(color: Colors.red, fontSize: 20),
            ),
          ),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              play();
            },
            child: Container(
              margin: EdgeInsets.only(top: 30),
              alignment: AlignmentDirectional.center,
              width: 100,
              height: 50,
              child: isComplete && recordFilePath != null
                  ? RaisedButton(child : Text( "Play",
                style: TextStyle(fontSize: 20,color: Colors.black),),

              )
                  : Container(),
            ),
          ),
          SizedBox(height: 40,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
            Container(
              child:   isLoading ? Center(child: CircularProgressIndicator()) : RaisedButton(
                child: Text("Upload Audio"),
                onPressed: () {

                  if(file != null) {
                    setState(() {
                      isLoading = true;
                    });
                    _uploadAudiotoFirebase(file).whenComplete(() {
                      setState(() {
                        isLoading = false;
                      });
                    });
                  } else {
                    _showDialog("Please Record an Audio First in order to Upload");
                  }
                },
              ),
            ),
            SizedBox(width: 30,),
            RaisedButton(
              child: Text("Reset"),
              onPressed: () {
                _resetFiles();
                isRecorded = false;
                isComplete = false;
                recordFilePath = null;
                file = null;
                statusText= "";
                _showDialog("Reset Complete..!");
                setState(() {});
              },
            )


          ],)

        ]),
      );
  }

  Future<bool> checkPermission() async {
    Map<PermissionGroup, PermissionStatus> map = await new PermissionHandler()
        .requestPermissions(
        [PermissionGroup.storage, PermissionGroup.microphone]);
    print(map[PermissionGroup.microphone]);
    return map[PermissionGroup.microphone] == PermissionStatus.granted;
  }

  void startRecord() async {
    bool hasPermission = await checkPermission();
    if (hasPermission) {
      statusText = "Recording...";
      isRecorded = true;
      recordFilePath = await getFilePath();
      isComplete = false;
      RecordMp3.instance.start(recordFilePath, (type) {
        statusText = "Recording failed --->$type";
        setState(() {});
      });
    } else {
      statusText = "No recording rights";
    }
    setState(() {});
  }

  void pauseRecord() {
    if (RecordMp3.instance.status == RecordStatus.PAUSE) {
      bool s = RecordMp3.instance.resume();
      if (s) {
        statusText = "Recording ...";
        setState(() {});
      }
    } else {
      bool s = RecordMp3.instance.pause();
      if (s) {
        statusText = "Recording paused ...";
        setState(() {});
      }
    }
  }

  void stopRecord() {
    bool s = RecordMp3.instance.stop();
    if (s) {
      statusText = "Recording is complete";

      isComplete = true;
      setState(() {
        file = new File('$recordFilePath');
      });
    }
  }

  void resumeRecord() {
    bool s = RecordMp3.instance.resume();
    if (s) {
      statusText = "Recording ...";
      setState(() {});
    }
  }

  String recordFilePath;

  void play() {
    if (recordFilePath != null && File(recordFilePath).existsSync()) {
      file = new File('$recordFilePath');
      AudioPlayer audioPlayer = AudioPlayer();
      audioPlayer.play(recordFilePath, isLocal: true);
    }
  }

  int i = 0;

  _resetFiles() async{
    recordFilePath = await getFilePath();
    final dir = Directory(audioDirectory);
    dir.deleteSync(recursive: true);
    i = 0;
  }

  Future<void> _uploadAudiotoFirebase(File audio) async {
    try {
      // Make random image name.
      int randomNumber = Random().nextInt(100000);
      String audioLocation = 'audio/audio${randomNumber}.mp3';

      // Upload image to firebase.
      final StorageReference storageReference = FirebaseStorage().ref().child(audioLocation);
      final StorageUploadTask uploadTask = storageReference.putFile(audio);
      uploadTask.isInProgress;
      CircularProgressIndicator();
      await uploadTask.onComplete;
      _addPathToDatabase(audioLocation).whenComplete(() {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Alert"),
                content: Text("Audio Uploaded"),
              );
            }
        );
      });
    }catch(e){
      print(e.message);
    }
  }

  Future<void> _addPathToDatabase(String text) async {
    try {
      // Get image URL from firebase
      final ref = FirebaseStorage().ref().child(text);
      var audioString = await ref.getDownloadURL();

      // Add location and url to database
     // await Firestore.instance.collection('Posts').document().setData({'image':imageString , 'description':textAreaController.text.toString(),'createdAt' : Timestamp.now()});
      await Firestore.instance.collection('Posts').document().setData({'audio':audioString , 'createdAt' : Timestamp.now()});
    }catch(e){
      print(e.message);
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(e.message),
            );
          }
      );
    }
  }

  Future<String> getFilePath() async {
    Directory storageDirectory = await getApplicationDocumentsDirectory();
    String sdPath = storageDirectory.path + "/record";
    var d = Directory(sdPath);
    if (!d.existsSync()) {
      d.createSync(recursive: true);
    }
    audioDirectory = sdPath;
    return sdPath + "/test_${i++}.mp3";
  }
}

