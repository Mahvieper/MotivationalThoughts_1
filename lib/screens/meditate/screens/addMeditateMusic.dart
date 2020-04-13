import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class MeditateMusicAdd extends StatefulWidget {
  MeditateMusicAdd(this.titleHead, this.audiolistName);

  String titleHead;
  String audiolistName;
  @override
  _MeditateMusicAddState createState() => _MeditateMusicAddState();
}

class _MeditateMusicAddState extends State<MeditateMusicAdd> {
  String audioPath;
  String audioTitle,audioDes;
  bool isLoading = false;
  File file;
  void showLoading() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: new Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              new CircularProgressIndicator(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: new Text("Loading"),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _audioSelector() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        file != null
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Audio Selected",
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Please Select an Audio File",
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
              ),
        SizedBox(
          height: 20,
        ),
        RaisedButton(
          color: Colors.cyan,
          textColor: Colors.white,
          child: new Text(
            'Pick an Audio',
            style: TextStyle(color: Colors.white),
          ),
          onPressed: audioSelectorGallery,
        ),
      ],
    );
  }

  void dismissLoading() {
    Navigator.pop(context);
  }

  audioSelectorGallery() async {
    showLoading();
    file = await FilePicker.getFile().whenComplete(() {
      setState(() {});
    });
    // var path = await AudioPicker.pickAudio();
    dismissLoading();
    print("You selected gallery image : " + audioPath);
    setState(() {
      audioPath = file.path;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add a New Meditation Audio"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(15.0),
            padding: const EdgeInsets.all(3.0),
            decoration:
                BoxDecoration(border: Border.all(color: Colors.blueAccent)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _audioSelector(),
                audioPath == null
                    ? Container()
                    : Text(
                        "Audio File Selected",
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                SizedBox(
                  height: 60,
                ),
                Text(
                  "Please Enter the Title of the Audio you want to display",
                  style: TextStyle(color: Colors.black, fontSize: 15),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: TextField(
                    decoration: InputDecoration(
                        hintText: "Enter the Audio Title ...",
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.red, //this has no effect
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        )),
                    onChanged: (text) {
                      setState(() {
                        audioTitle = text;
                      });
                    },
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  //height: MediaQuery.of(context).size.height * 0.8,
                  child: TextField(
                    maxLines: 2,
                    decoration: InputDecoration(
                        hintText: "Enter the Audio Description ...",
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.red, //this has no effect
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        )),
                    onChanged: (text) {
                      setState(() {
                        audioDes = text;
                      });
                    },
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                isLoading
                    ? Center(child: CircularProgressIndicator())
                    : RaisedButton(
                        child: Text("Upload Audio"),
                        color: Colors.cyan,
                        textColor: Colors.white,
                        onPressed: () {
                          setState(() {
                            (file.path.contains(".mp3") && audioTitle != null)
                                ? isLoading = true
                                : isLoading = false;
                          });

                          if (file != null && audioTitle!=null && file.path.contains(".mp3")) {
                            _uploadImageToFirebase(file).whenComplete(() {
                              setState(() {
                                isLoading = false;
                              });
                            });
                          } else {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text("Alert"),
                                    content: file!=null? Text("Please Select an Mp3 File"):Text(
                                        "Please check if Audio is selected and Audio Title have been entered Correctly..!"),
                                  );
                                });
                          }
                        }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _uploadImageToFirebase(File audio) async {
    try {
      // Make random image name.
      int randomNumber = Random().nextInt(100000);
      String imageLocation = 'meditate/audio${randomNumber}.mp3';

      // Upload image to firebase.
      final StorageReference storageReference =
          FirebaseStorage().ref().child(imageLocation);
      final StorageUploadTask uploadTask = storageReference.putFile(audio);
      uploadTask.isInProgress;
      CircularProgressIndicator();
      await uploadTask.onComplete;
      _addPathToDatabase(imageLocation).whenComplete(() {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Alert"),
                content: Text("Post Uploaded"),
              );
            });
      });
    } catch (e) {
      print(e.message);
    }
  }

  Future<void> _addPathToDatabase(String text) async {
    try {
      // Get image URL from firebase
      final ref = FirebaseStorage().ref().child(text);
      var imageString = await ref.getDownloadURL();

      // Add location and url to database
      await Firestore.instance
          .collection(widget.titleHead)
          .document(widget.audiolistName)
          .collection("Audios")
          .document()
          .setData({
        'audioName': audioTitle,
        'audioUrl': imageString,
        'audioDes' : audioDes,
        'createdAt': Timestamp.now()
      });
    } catch (e) {
      print(e.message);
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(e.message),
            );
          });
    }
  }
}
