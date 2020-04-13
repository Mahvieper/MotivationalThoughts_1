import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';

class PlayArea extends StatefulWidget {
  PlayArea(this.mydata);

  DocumentSnapshot mydata;

  @override
  _PlayAreaState createState() => _PlayAreaState();
}

class _PlayAreaState extends State<PlayArea> {
  bool playing = false;
  AudioCache audioCache; //To play Local Assets
  AudioPlayer audioPlayer;  //To play network Audio and Controls
  AudioPlayerState _audioPlayerState;
  Duration  _duration;
  Duration _position;
  double onTapPosition;
  StreamSubscription _durationSubscription;
  StreamSubscription _positionSubscription;


  @override
  void initState() {
    // TODO: implement initState
   play();
    initPlayer();
    super.initState();
  }

  initPlayer() async {
    audioPlayer = AudioPlayer();
    audioCache = AudioCache(fixedPlayer: audioPlayer);
   /* _durationSubscription = audioPlayer.onDurationChanged.listen((d){
       setState(() {
          this._duration = d;
       });
    });
    _positionSubscription= audioPlayer.onAudioPositionChanged.listen((p){
        setState(() {
          this._position=p;
        });
    });
*/


  }

  Widget slider() {
    return Slider(
        value: (_position!=null)?_position.inSeconds.toDouble():0.0,
        activeColor: Colors.white,
        inactiveColor: Colors.blueAccent,
        /* position.inSeconds.toDouble(),*/
        min: 0.0,
     //   max: 100,

        max: _duration !=null?_duration.inSeconds.toDouble():100,
        onChanged: (double newValue) {
          setState(() {
            onTapPosition = newValue;
            Duration newDuration = Duration(seconds:newValue.toInt());
            _position = newDuration;
            audioPlayer.seek(newDuration);
          });
        });
  }

  play() async {
    audioPlayer.play(widget.mydata["audioUrl"], volume: 0.3,);
    _durationSubscription = audioPlayer.onDurationChanged.listen((d){
      setState(() {
        this._duration = d;
      });
    });
    _positionSubscription= audioPlayer.onAudioPositionChanged.listen((p){
      setState(() {
        this._position=p;
      });
    });



    print(_duration.toString().split('.').first);
    print(_position.toString().split('.').first);

  }

  pause() async {
    audioPlayer.pause();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/music_back.png'), fit: BoxFit.fill)),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Container(
                padding: EdgeInsets.all(10),
                //margin: EdgeInsets.fromLTRB(40,20,0,0),
                child: IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                 /* SizedBox(
                    width: MediaQuery.of(context).size.width / 8.5,
                  ),*/
                  Container(
                      margin: EdgeInsets.only(top: 30.0),
                      child: Text(
                        widget.mydata['audioName'],
                        style: TextStyle(color: Colors.white, fontSize: 30.0),
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  widget.mydata['audioDes']!=null? Container(
                      margin: EdgeInsets.only(top: 20.0),
                      child: Text(
                        widget.mydata['audioDes'],
                        style: TextStyle(color: Colors.white, fontSize: 18.0),
                      )) : Container(),

                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(16),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[

                          IconButton(
                            icon: this.playing
                                ? Icon(
                                    Icons.pause_circle_outline,
                                    color: Colors.white,
                                    size: 35.0,
                                  )
                                : Icon(
                                    Icons.play_circle_outline,
                                    color: Colors.white,
                                    size: 35.0,
                                  ),
                            onPressed: () async {
                              if (!this.playing) {
                                await play();
                                setState(() {
                                  this.playing = true;
                                });
                              } else if (this.playing) {
                                await pause();
                                setState(() {
                                  this.playing = false;
                                });
                              }
                            },
                          ),
                        ],
                      ),
                      slider()
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    audioPlayer.stop();
    super.dispose();
  }
}
