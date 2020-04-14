import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:snaplist/snaplist_view.dart';
import 'package:video_player/video_player.dart';

import 'feature_selection.dart';

class HomePageSelection extends StatefulWidget {
  HomePageSelection({Key key, this.isAdmin})
      : super(key: key);

  final bool isAdmin;
  @override
  _HomePageSelectionState createState() => _HomePageSelectionState();
}

class _HomePageSelectionState extends State<HomePageSelection> {
  VideoPlayerController _controller;
  AudioPlayer audioPlayer = AudioPlayer();
  AudioPlayer audioPlayer1 = new AudioPlayer();
  var ourData;
  //AudioPlayer localAudioPlayer = new AudioPlayer();
  Future snapShot;
  String backAudioPath =
      "https://firebasestorage.googleapis.com/v0/b/motivational-thoughts-one.appspot.com/o/audio%2FbackMusic.mp3?alt=media&token=77f8de09-90eb-4885-b1b9-591b19de3c14";

  bool soundIconOn = true;
  AudioCache player;


  Future getPosts() async {
    var firestore = Firestore.instance;
    QuerySnapshot snapshot = await firestore
        .collection("Posts")
        .orderBy('createdAt', descending: true)
        .getDocuments();
    return snapshot.documents;
  }

  Future<Null> getRefresh() async {
    await Future.delayed(Duration(seconds: 3));
    setState(() {
      getPosts();
    });
  }

  @override
  void initState() {
    super.initState();
    snapShot = getPosts();

    _controller = VideoPlayerController.asset(
        "assets/leaves.mp4")
      ..initialize().then((_) {
        _controller.play();
        _controller.setLooping(true);
        _controller.setVolume(0);
        // Ensure the first frame is shown after the video is initialized
        setState(() {});
      });
  }

  pauseAllVideoAudio() {
    _controller.setVolume(0);

  }

  resumeAllVideoAudio() {
    _controller.setVolume(1);

  }


  @override
  Widget build(BuildContext context) {
    final Size cardSize = Size(MediaQuery.of(context).size.width * 0.97,
        MediaQuery.of(context).size.height * 0.8);
    return Scaffold(

      body : Stack(
        children: <Widget>[
          // _backgroundImage(),
          SizedBox.expand(
            child: FittedBox(
              // If your background video doesn't look right, try changing the BoxFit property.
              // BoxFit.fill created the look I was going for.
              fit: BoxFit.fill,
              child: SizedBox(
                width: _controller.value.size?.width ?? 0,
                height: _controller.value.size?.height ?? 0,
                child: VideoPlayer(_controller),
              ),
            ),
          ),
/*

        new Positioned( //Place it at the top, and not use the entire screen
        top: 0.0,
        left: 0.0,
        right: 0.0,
          child :AppBar(
            backgroundColor: Colors.transparent,
            title: widget.isAdmin == true ? Text("Welcome Dr.Dookie") : Text("You are Awesome"),
            centerTitle: true,
            actions: <Widget>[
              soundIconOn
                  ? IconButton(
                icon: new Image.asset(
                  'assets/soundUnmuted.png',
                  color: Colors.white,
                  fit: BoxFit.scaleDown,
                ),
                onPressed: () {
                  setState(() {
                    soundIconOn = !soundIconOn;
                    pauseAllVideoAudio();
                    localAudioPlayer.pause();
                  });
                },
              )
                  : IconButton(
                icon: new Image.asset(
                  'assets/soundMuted.png',
                  color: Colors.white,
                ),
                tooltip: 'Closes application',
                onPressed: () {
                  setState(() {
                    soundIconOn = !soundIconOn;
                    resumeAllVideoAudio();
                    localAudioPlayer.resume();
                  });
                },
              ),
            ],
          ),
    ),*/



          FutureBuilder(
            future: snapShot,
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
                      String check = ourData.data.toString();
                      return (check.contains("image")
                          ? _getImageTextPosts(index, ourData)
                          : _getAudioPosts(index, ourData));
                    },
                    count: snapshot.data.length,
                  ),
                );
              }
            },
          ),

          Container(
            margin: EdgeInsets.only(top: 30),
            child: Align(
              alignment: Alignment.topLeft,
              child: IconButton(icon: Icon(Icons.arrow_back,color: Colors.white,),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ),
        ],
      ),


      floatingActionButton: widget.isAdmin ? FloatingActionButton(
        onPressed: () {
          // Add your onPressed code here!
          Navigator.of(context).push(
              new MaterialPageRoute(builder: (context) => FeatureSelection()));
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ) : Container(),
    );
  }

  Widget _getImageTextPosts(int index, var ourData) {
    return ClipRRect(
        borderRadius: new BorderRadius.circular(16.0),
        child: Container(
          color: Colors.black26,
          child: Column(
            children: <Widget>[
              index == 0
                  ? Container(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.04),
                  child: Text(
                    "Thought of the Day",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20),
                  ))
                  : Text(""),
              Container(
                height: MediaQuery.of(context).size.height * 0.4,
                width: MediaQuery.of(context).size.width * 0.9,
                padding: EdgeInsets.all(5),
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.02),
                child: ClipRRect(
                  borderRadius: new BorderRadius.circular(16.0),
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
                    padding: EdgeInsets.all(
                        MediaQuery.of(context).size.height * 0.02),
                    child: Column(
                      children: <Widget>[
                        Text(ourData.data['description'],
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontFamily: 'Prata')),
                        SizedBox(
                          height: 1,
                        ),
                        Align(
                            alignment: Alignment.bottomRight,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
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

  Widget _getAudioPosts(int index, var ourData) {
    return ClipRRect(
        borderRadius: new BorderRadius.circular(16.0),
        child: Container(
          color: Colors.black26,
          child: Column(
            children: <Widget>[
              index == 0
                  ? Container(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.04),
                  child: Text(
                    "Thought of the Day",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20),
                  ))
                  : Text(""),
              Container(
                height: MediaQuery.of(context).size.height * 0.4,
                width: MediaQuery.of(context).size.width * 0.9,
                padding: EdgeInsets.all(5),
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.02),
                child: ClipRRect(
                  borderRadius: new BorderRadius.circular(16.0),
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
                    padding: EdgeInsets.all(
                        MediaQuery.of(context).size.height * 0.02),
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
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(80.0)),
                          child: Container(
                            decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  colors: <Color>[
                                    Color(0xFF0D47A1),
                                    Color(0xFF1976D2),
                                    Color(0xFF42A5F5),
                                  ],
                                ),
                                borderRadius:
                                BorderRadius.all(Radius.circular(80.0))),
                            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                            child: const Text('Play',
                                style: TextStyle(fontSize: 20)),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        RaisedButton(
                          onPressed: () {
                            _pauseAudio();
                          },
                          textColor: Colors.white,
                          padding: const EdgeInsets.all(0.0),
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(80.0)),
                          child: Container(
                            decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  colors: <Color>[
                                    Color(0xFF0D47A1),
                                    Color(0xFF1976D2),
                                    Color(0xFF42A5F5),
                                  ],
                                ),
                                borderRadius:
                                BorderRadius.all(Radius.circular(80.0))),
                            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                            child: const Text('Pause',
                                style: TextStyle(fontSize: 20)),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        RaisedButton(
                          onPressed: () {
                            _resumeAudio();
                          },
                          textColor: Colors.white,
                          padding: const EdgeInsets.all(0.0),
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(80.0)),
                          child: Container(
                            decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  colors: <Color>[
                                    Color(0xFF0D47A1),
                                    Color(0xFF1976D2),
                                    Color(0xFF42A5F5),
                                  ],
                                ),
                                borderRadius:
                                BorderRadius.all(Radius.circular(80.0))),
                            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                            child: const Text('Resume',
                                style: TextStyle(fontSize: 20)),
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
      int result = await audioPlayer1.play(url, volume: 0.3);
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
