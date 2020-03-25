import 'dart:io';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:motivationalthoughts/auth/authentication.dart';
import 'package:snaplist/snaplist_view.dart';

import 'about_us.dart';
import 'contact_us.dart';

class HomePageUser extends StatefulWidget {
  HomePageUser({Key key, this.auth, this.userId, this.logoutCallback})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;
  @override
  _HomePageUserState createState() => _HomePageUserState();
}

class _HomePageUserState extends State<HomePageUser> {
  File galleryFile;
  AudioPlayer audioPlayer = new AudioPlayer();
  AudioPlayer audioPlayer1 = new AudioPlayer();

  //static AudioCache player = AudioCache(fixedPlayer: audioPlayer1);
  var ourData;
  String backAudioPath= "https://firebasestorage.googleapis.com/v0/b/motivational-thoughts-one.appspot.com/o/audio%2FbackMusic.mp3?alt=media&token=77f8de09-90eb-4885-b1b9-591b19de3c14";
  playLocal(String localPath) async {
    int result = await audioPlayer.play(localPath, isLocal: true);
  }
  //final VoidCallback loadMore;
  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Please Confirm"),
          content: new Text("Are you Sure you want to Logout"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () {
                Navigator.of(context).pop();
                widget.logoutCallback();
              },
            ),

            new FlatButton(
              child: new Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future getPosts() async {
    var firestore = Firestore.instance;
    QuerySnapshot snapshot = await firestore.collection("Posts").orderBy('createdAt', descending: true).getDocuments();
    return snapshot.documents;
  }

  Future<Null> getRefresh() async {
    await Future.delayed(Duration(seconds: 3));
    setState(() {
      getPosts();
    });
  }

  Widget _backgroundImage() {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: galleryFile != null
              ? Image.file(galleryFile)
              : AssetImage("assets/background.jpeg"),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  imageSelectorGallery() async {
    galleryFile = await ImagePicker.pickImage(
      source: ImageSource.gallery,
      // maxHeight: 50.0,
      // maxWidth: 50.0,
    );
    print("You selected gallery image : " + galleryFile.path);
    setState(() {});
  }

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
          child: new Text(
            'Select Image from Gallery',
            style: TextStyle(color: Colors.black),
          ),
          onPressed: imageSelectorGallery,
        ),
      ],
    );
  }

  
  
  @override
  Widget build(BuildContext context) {
    final Size cardSize = Size(MediaQuery.of(context).size.width * 0.97,
        MediaQuery.of(context).size.height * 0.8);
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      appBar: AppBar(
        backgroundColor: Color(282032),
        title: Text("Yor are Awesome"),
        centerTitle: true,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: InkWell(
                onTap: () {
                  _showDialog();
                },
                child: Icon(Icons.exit_to_app)),
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Image.asset("assets/SplashLogo.png"),
              decoration: BoxDecoration(),
            ),
            Container(
              color: Colors.deepPurple,
              child: ListTile(
                title: Text(
                  'About Us',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.of(context).push(
                      new MaterialPageRoute(builder: (context) => AboutPage()));
                  // Update the state of the app.
                  // ...
                },
              ),
            ),
            Container(
              color: Colors.blue,
              child: ListTile(
                title: Text(
                  'Contact Us',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.of(context).push(
                      new MaterialPageRoute(builder: (context) => ContactUsPage()));
                  // Update the state of the app.
                  // ...
                },
              ),
            ),
            Container(
              color: Colors.deepPurple,
              child: ListTile(
                title: Text('Exit', style: TextStyle(color: Colors.white)),
                onTap: () {
                  exit(0);
                  // SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                  // Update the state of the app.
                  // ...
                },
              ),
            )
          ],
        ),
      ),
      body: Stack(
        children: <Widget>[
          //  _backgroundImage(),
          FutureBuilder(
            future: getPosts(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return RefreshIndicator(
                  onRefresh: getRefresh,
                  child: SnapList(
                    padding: EdgeInsets.only(
                        left: (MediaQuery.of(context).size.width -
                                cardSize.width) /
                            2),
                    sizeProvider: (index, data) => cardSize,
                    separatorProvider: (index, data) => Size(10.0, 10.0),
                    positionUpdate: (int index) {
                      if (index == snapshot.data.length - 1) {
                        // loadMore();
                      }
                    },
                    builder: (context, index, data) {
                      ourData = snapshot.data[index];
                      String check =  ourData.data.toString();
                      return (check.contains("image") ?
                      _getImageTextPosts(index,ourData) :  _getAudioPosts(index,ourData));
                    },
                    count: snapshot.data.length,
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  customDialog(BuildContext context, String img, String des) {
    return showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              height: MediaQuery.of(context).size.height / 1.2,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      Colors.pink,
                      Colors.red,
                      Colors.green,
                      Colors.grey
                    ],
                  )),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    // SizedBox(height: 10,),
                    // Text(title,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 25),),
                    SizedBox(
                      height: 10,
                    ),
                    Image.network(
                      img,
                      height: 250,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                        padding: EdgeInsets.all(5),
                        child: Text(
                          des,
                          style: TextStyle(color: Colors.white, fontSize: 17),
                        ))
                  ],
                ),
              ),
            ),
          );
        });
  }

  Widget _getImageTextPosts(int index,var ourData) {
    return ClipRRect(
        borderRadius: new BorderRadius.circular(16.0),
        child: Container(
          color: Colors.black26,
          child: Column(
            children: <Widget>[
              index == 0
                  ? Container(
                  padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.04),
                  child: Text(
                    "Thought of the Day",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20),
                  ))
                  : Text(""),
              Container(
                height:
                MediaQuery.of(context).size.height * 0.4,
                width:
                MediaQuery.of(context).size.width * 0.9,
                padding: EdgeInsets.all(5),
                margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
                child: ClipRRect(
                  borderRadius:
                  new BorderRadius.circular(16.0),
                  child: Image.network(
                    ourData.data['image'],
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: Container(
                    padding: EdgeInsets.all( MediaQuery.of(context).size.height *
                        0.02),
                    child: Column(
                      children: <Widget>[
                        Text(
                            ourData.data['description'],
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontFamily: 'Prata')
                        ),
                        SizedBox(
                          height: 1,
                        ),
                        Align(
                            alignment: Alignment.bottomRight,
                            child: Padding(
                              padding:
                              const EdgeInsets.all(8.0),
                              child: Text(
                                " \n- Dr.Courtney",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontFamily: 'Prata'),
                              ),
                            ))
                      ],
                    )),
              )
            ],
          ),
        ));
  }

  Widget _getAudioPosts(int index,var ourData) {
    return ClipRRect(
        borderRadius: new BorderRadius.circular(16.0),
        child: Container(
          color: Colors.black26,
          child: Column(
            children: <Widget>[
              index == 0
                  ? Container(
                  padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.04),
                  child: Text(
                    "Thought of the Day",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20),
                  ))
                  : Text(""),
              Container(
                height:
                MediaQuery.of(context).size.height * 0.4,
                width:
                MediaQuery.of(context).size.width * 0.9,
                padding: EdgeInsets.all(5),
                margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
                child: ClipRRect(
                  borderRadius:
                  new BorderRadius.circular(16.0),
                  child: Image.asset(
                    "assets/Courtney.png",
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: Container(
                    padding: EdgeInsets.all( MediaQuery.of(context).size.height *
                        0.02),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        RaisedButton(
                          onPressed: () {
                            _playAudio(ourData.data['audio'].toString());
                          },
                          textColor: Colors.white,
                          padding: const EdgeInsets.all(0.0),
                          elevation: 5,
                          shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
                          child: Container(
                            decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  colors: <Color>[
                                    Color(0xFF0D47A1),
                                    Color(0xFF1976D2),
                                    Color(0xFF42A5F5),
                                  ],
                                ),
                                borderRadius: BorderRadius.all(Radius.circular(80.0))
                            ),
                            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                            child: const Text(
                                'Play',
                                style: TextStyle(fontSize: 20)
                            ),
                          ),

                        ),
                        SizedBox(width: 10,),
                        RaisedButton(
                          onPressed: () {
                            _pauseAudio();
                          },
                          textColor: Colors.white,
                          padding: const EdgeInsets.all(0.0),
                          elevation: 5,
                          shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
                          child: Container(
                            decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  colors: <Color>[
                                    Color(0xFF0D47A1),
                                    Color(0xFF1976D2),
                                    Color(0xFF42A5F5),
                                  ],
                                ),
                                borderRadius: BorderRadius.all(Radius.circular(80.0))
                            ),
                            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                            child: const Text(
                                'Pause',
                                style: TextStyle(fontSize: 20)
                            ),
                          ),

                        ),
                        SizedBox(width: 10,),
                        RaisedButton(
                          onPressed: () {
                            _resumeAudio();
                          },
                          textColor: Colors.white,
                          padding: const EdgeInsets.all(0.0),
                          elevation: 5,
                          shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
                          child: Container(
                            decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  colors: <Color>[
                                    Color(0xFF0D47A1),
                                    Color(0xFF1976D2),
                                    Color(0xFF42A5F5),
                                  ],
                                ),
                                borderRadius: BorderRadius.all(Radius.circular(80.0))
                            ),
                            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                            child: const Text(
                                'Resume',
                                style: TextStyle(fontSize: 20)
                            ),
                          ),
                        )
                      ],
                    )),
              )
            ],
          ),
        ));
  }


  _playAudioLocal(String url) {
    play() async {
      int result = await audioPlayer1.play(url,volume: 0.3);
      if (result == 1) {
        // success
      }
    }

    play();

    //audioPlayer.play(recordFilePath, isLocal: false);
  }

  _playAudio(String url) {
    audioPlayer.release();
    audioPlayer1.release();
    audioPlayer.dispose();
    audioPlayer1.dispose();
    audioPlayer = null;
    audioPlayer1 = null;
     audioPlayer = new AudioPlayer();
    audioPlayer1 = new AudioPlayer();
    play() async {
      int result = await audioPlayer.play(url);
      if (result == 1) {
        // success
      }

    }

    play();
    //audioPlayer.onSeekComplete.listen(onData)

    audioPlayer.onPlayerCompletion.listen((event) {
      audioPlayer1.pause();
    });

    _playAudioLocal(backAudioPath);
    //audioPlayer.play(recordFilePath, isLocal: false);
  }

 
  
  
  _pauseAudio() {
    audioPlayer.pause();
    audioPlayer1.pause();
  }

  _resumeAudio() {
    audioPlayer.resume();
    audioPlayer1.resume();
  }
}
