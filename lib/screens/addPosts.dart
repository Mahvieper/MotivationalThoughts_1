import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddPost extends StatefulWidget {
  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  //save the result of gallery file
  File galleryFile;
  final textAreaController = TextEditingController();
//save the result of camera file
  File cameraFile;

  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    //display image selected from gallery
    imageSelectorGallery() async {
      galleryFile = await ImagePicker.pickImage(
        source: ImageSource.gallery,
        // maxHeight: 50.0,
        // maxWidth: 50.0,
      );
      print("You selected gallery image : " + galleryFile.path);
      setState(() {});
    }

    //Button to slect image from gallary
    Widget _imageSelector() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Please Select an Image",
            style: TextStyle(color: Colors.black),
          ),
          SizedBox(
            width: 30,
          ),
          RaisedButton(
            color: Colors.cyan,
            textColor: Colors.white,
            child: new Text(
              'Select Image from Gallery',
            ),
            onPressed: imageSelectorGallery,
          ),
        ],
      );
    }

    Widget _textArea() {
      return Container(
        padding: EdgeInsets.all(20),
        child: TextField(
          controller: textAreaController,
          maxLines: 8,
          decoration: InputDecoration(
              border: new OutlineInputBorder(
                borderSide: new BorderSide(color: Colors.teal),
              ),
              hintText: 'Enter the Motivational Thought'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Add Motivational Thought"),
      ),
      body: Center(
        child: Container(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _imageSelector(),
                SizedBox(
                  height: 20,
                ),
                displaySelectedFile(galleryFile),
                SizedBox(
                  height: 10,
                ),
                _textArea(),
                SizedBox(
                  height: 10,
                ),
                isLoading
                    ? Center(child: CircularProgressIndicator())
                    : RaisedButton(
                        color: Colors.cyan,
                        textColor: Colors.white,
                        child: Text("Add thought"),
                        onPressed: () {
                          setState(() {
                            isLoading = true;
                          });
                          if (galleryFile != null &&
                              textAreaController.text.isNotEmpty) {
                            _uploadImageToFirebase(galleryFile)
                                .whenComplete(() {
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
                                    content: Text(
                                        "Please check if Image and Quote have been entered Correctly..!"),
                                  );
                                });
                          }
                        },
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget displaySelectedFile(File file) {
    return new SizedBox(
//child: new Card(child: new Text(''+galleryFile.toString())),
//child: new Image.file(galleryFile),
      child: file == null
          ? new Text('Sorry nothing selected!!')
          : new Image.file(
              file,
              height: 200.0,
              width: 300.0,
            ),
    );
  }

  Future<void> _uploadImageToFirebase(File image) async {
    try {
      // Make random image name.
      int randomNumber = Random().nextInt(100000);
      String imageLocation = 'image${randomNumber}.jpg';

      // Upload image to firebase.
      final StorageReference storageReference =
          FirebaseStorage().ref().child(imageLocation);
      final StorageUploadTask uploadTask = storageReference.putFile(image);
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
      await Firestore.instance.collection('Posts').document().setData({
        'image': imageString,
        'description': textAreaController.text.toString(),
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
