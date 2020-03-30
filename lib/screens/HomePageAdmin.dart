import 'dart:io';
//import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:motivationalthoughts/auth/authentication.dart';

import 'package:video_player/video_player.dart';

import 'about_us.dart';
import '../bible/bible_page.dart';
import 'contact_us.dart';
import 'home_selection_screen.dart';

class HomePageAdmin extends StatefulWidget {
  HomePageAdmin(
      {Key key, this.auth, this.userId, this.logoutCallback, this.isAdmin})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;
  final bool isAdmin;

  @override
  _HomePageAdminState createState() => _HomePageAdminState();
}

class _HomePageAdminState extends State<HomePageAdmin> {
  VideoPlayerController _controller, _controller1, _controller2, _controller3,_controller4;
  var ourData;
  AudioPlayer localAudioPlayer = new AudioPlayer();
  Future snapShot;
  bool soundIconOn = true;
  AudioCache player;
  List<String> assetsList = [
    "assets/RainDown.mp4",
    "assets/OceanBackground.mp4",
    "assets/CalmNature.mp4",
    "assets/MountNature.mp4",
    "assets/fire.mp4"
  ];

  VideoPlayerController _controllerSwiper;

  int oneTime = 0;

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
                widget.auth.signOut();
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

  Widget _backgroundImage() {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/background.jpeg"),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // Pointing the video controller to our local asset.

    player = AudioCache(fixedPlayer: localAudioPlayer);
    player.loop('oceanSound.mp3');
    //player.play('oceanSound.mp3');
    _controller1 = VideoPlayerController.asset("assets/RainDown.mp4")
      ..initialize().then((_) {
        // Once the video has been loaded we play the video and set looping to true.

        _controller1.setLooping(true);

        // Ensure the first frame is shown after the video is initialized.
      });
    _controller2 = VideoPlayerController.asset("assets/CalmNature.mp4")
      ..initialize().then((_) {
        // Once the video has been loaded we play the video and set looping to true.
        ////_controller.play();
        _controller2.setLooping(true);
        // Ensure the first frame is shown after the video is initialized.
        // setState(() {});
      });
    _controller3 = VideoPlayerController.asset("assets/MountNature.mp4")
      ..initialize().then((_) {
        // Once the video has been loaded we play the video and set looping to true.
        //_controller.play();
        _controller3.setLooping(true);
        // Ensure the first frame is shown after the video is initialized.
        // setState(() {});
      });
    _controller4 = VideoPlayerController.asset("assets/fire.mp4")
      ..initialize().then((_) {
        // Once the video has been loaded we play the video and set looping to true.
        ////_controller.play();
        _controller4.setLooping(true);
        // Ensure the first frame is shown after the video is initialized.
        // setState(() {});
      });
    _controller = VideoPlayerController.asset("assets/OceanBackground.mp4")
      ..initialize().then((_) {
         _controller.play();
        _controller.setLooping(true);
        _controllerSwiper = _controller;
        localAudioPlayer.resume();
         setState(() {});
      });
    _controllerSwiper = _controller;
  }

  pauseAllVideoAudio() {
    localAudioPlayer.setVolume(0);
    _controller.setVolume(0);
    _controller1.setVolume(0);
    _controller2.setVolume(0);
    _controller3.setVolume(0);
    _controller4.setVolume(0);
  }

 resumeAllVideoAudio() {
   localAudioPlayer.setVolume(1);
    _controller.setVolume(1);
    _controller1.setVolume(1);
    _controller2.setVolume(1);
    _controller3.setVolume(1);
    _controller4.setVolume(1);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

        drawer: Drawer(
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: Image.asset("assets/MindRenewal.png"),
                decoration: BoxDecoration(
                  color: Colors.white
                ),
              ),
              //Home Page
             /* Container(
                color: Colors.white,
                child: ListTile(
                  leading: Icon(Icons.home),
                  title: Text(
                    'Home',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Navigator.of(context).push(new MaterialPageRoute(
                        builder: (context) =>
                            HomePageSelection(isAdmin: widget.isAdmin)));
                    // Update the state of the app.
                    // ...
                  },
                ),
              ),*/
              //About Us Page
              Container(
                color: Colors.blue,
                child: ListTile(
                  title: Text(
                    'About Us',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Navigator.of(context).push(new MaterialPageRoute(
                        builder: (context) => AboutPage()));
                    // Update the state of the app.
                    // ...
                  },
                ),
              ),
              //Contact Us Page
              Container(
                color: Colors.blue,
                child: ListTile(
                  title: Text(
                    'Contact Us',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Navigator.of(context).push(new MaterialPageRoute(
                        builder: (context) => ContactUsPage()));
                    // Update the state of the app.
                    // ...
                  },
                ),
              ),
              //Exit Option
              Container(
                color: Colors.blue,
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
            Swiper(
              itemBuilder: (BuildContext context, int index) {
                /*switch (index) {
                  case 0:
                    _controllerSwiper = _controller;
                    _controllerSwiper.play();
                    localAudioPlayer.resume();
                    break;
                  case 1:
                    _controllerSwiper.pause();
                    _controllerSwiper = _controller1;
                    _controllerSwiper.play();

                    break;
                  case 2:
                    _controllerSwiper.pause();
                    _controllerSwiper = _controller2;
                    _controllerSwiper.play();
                    break;
                  case 3:
                    _controllerSwiper.pause();
                    _controllerSwiper = _controller3;
                    _controllerSwiper.play();
                    break;
                  case 4:
                    _controllerSwiper.pause();
                    _controllerSwiper = _controller4;
                    _controllerSwiper.play();
                    break;
                }*/


                return new SizedBox.expand(
                    child: FittedBox(
                  // If your background video doesn't look right, try changing the BoxFit property.
                  // BoxFit.fill created the look I was going for.
                  fit: BoxFit.fill,
                  child: SizedBox(
                    width: _controllerSwiper.value.size?.width ?? 0,
                    height: _controllerSwiper.value.size?.height ?? 0,
                    child: VideoPlayer(_controllerSwiper),
                  ),
                ));
              },
              //indicatorLayout: PageIndicatorLayout.COLOR

              onIndexChanged: (int index) {
                //_controllerSwiper.pause();
                if(index == 0) {
                  _controllerSwiper.pause();
                  _controllerSwiper.setVolume(0);
                  _controllerSwiper = _controller;
                  _controllerSwiper.setVolume(1);
                  _controllerSwiper.play();
                  localAudioPlayer.setVolume(1);
                  localAudioPlayer.resume();
                }

                if(index == 1) {
                  localAudioPlayer.pause();
                  _controllerSwiper.pause();
                  _controllerSwiper.setVolume(0);
                  _controllerSwiper = _controller1;
                  _controllerSwiper.setVolume(1);
                  _controllerSwiper.play();
                }
                else if(index ==2) {
                  _controllerSwiper.pause();
                  _controllerSwiper.setVolume(0);
                  _controllerSwiper = _controller2;
                  _controllerSwiper.setVolume(1);
                  _controllerSwiper.play();
                } else if(index == 3) {
                  _controllerSwiper.pause();
                  _controllerSwiper.setVolume(0);
                  _controllerSwiper = _controller3;
                  _controllerSwiper.setVolume(1);
                  _controllerSwiper.play();
                } else if(index ==4) {
                  _controllerSwiper.pause();
                  _controllerSwiper.setVolume(0);
                  _controllerSwiper = _controller4;
                  _controllerSwiper.setVolume(1);
                  _controllerSwiper.play();
                } else {
                  localAudioPlayer.resume();
                  _controllerSwiper.setVolume(0);
                  _controllerSwiper = _controller;
                  _controllerSwiper.setVolume(1);
                  _controllerSwiper.play();
                }
                setState(() {});
              },
              autoplay: false,
              itemCount: assetsList.length,
              //pagination: new SwiperPagination(),
              //control: new SwiperControl(),
            ),

            new Positioned( //Place it at the top, and not use the entire screen
              top: 0.0,
              left: 0.0,
              right: 0.0,
              child: AppBar(
                backgroundColor: Colors.transparent,
                title: widget.isAdmin
                    ? Text("Welcome Dr.Dookie")
                    : Text("You are Awesome"),
                centerTitle: true,
                actions: <Widget>[
               /*   //Logout
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
                  ),*/
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: InkWell(
                        onTap: () {
                          pauseAllVideoAudio();
                          _showDialog();
                        },
                        child: Icon(Icons.exit_to_app)),
                  )
                ],
              ),),

            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    decoration: new BoxDecoration(
                      borderRadius:
                      BorderRadius.all(Radius.circular(85.0)),
                      color: Colors.white60
                    ),
                    margin: EdgeInsets.fromLTRB(30, 0, 30, 20),
                    child: ListTile(
                      leading: Icon(Icons.bubble_chart),
                      title: Text(
                        "Meditation",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Prata'),
                      ),
                      subtitle: Text(
                        "Focus",
                        style: TextStyle(color: Colors.black, fontSize: 15 ,fontFamily: 'Prata'),
                      ),
                    ),
                  ),
                  Divider(), //
                  InkWell(
                    onTap: () {
                      pauseAllVideoAudio();
                      setState(() {});
                      Navigator.of(context).push(new MaterialPageRoute(
                          builder: (context) {
                           return HomePageSelection(isAdmin: widget.isAdmin);
                          }
                      ));
                    },
                    child: Container(
                      margin: EdgeInsets.fromLTRB(30, 0, 30, 20),
                      decoration: new BoxDecoration(
                        borderRadius:
                        BorderRadius.all(Radius.circular(85.0)),
                          color: Colors.white60
                      ),
                      child: ListTile(
                        leading: Icon(Icons.bubble_chart),
                        title: Text(
                          "Thoughts",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold, fontFamily: 'Prata'),
                        ),
                        subtitle: Text(
                          "Get Daily Thoughts",
                          style: TextStyle(color: Colors.black, fontSize: 15, fontFamily: 'Prata'),
                        ),
                      ),
                    ),
                  ),

                  InkWell(
                    onTap: () {
                      pauseAllVideoAudio();
                      setState(() {});
                      Navigator.of(context).push(new MaterialPageRoute(
                          builder: (context) {
                            return BiblePage();
                          }
                      ));
                    },
                    child: Container(
                      margin: EdgeInsets.fromLTRB(30, 0, 30, 20),
                      decoration: new BoxDecoration(
                          borderRadius:
                          BorderRadius.all(Radius.circular(85.0)),
                          color: Colors.white60
                      ),
                      child: ListTile(
                        leading: Icon(Icons.bubble_chart),
                        title: Text(
                          "Bible",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold, fontFamily: 'Prata'),
                        ),
                        subtitle: Text(
                          "Get Daily Bible verses",
                          style: TextStyle(color: Colors.black, fontSize: 15, fontFamily: 'Prata'),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
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
}
