import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'addMeditateMusic.dart';
import 'mentaltraining.dart';
import 'profile.dart';


class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.isAdmin})
      : super(key: key);

  final bool isAdmin;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future snapShot;
  List<DocumentSnapshot> documents;
  List<String> mentalHealth = ["Managing Anxiety","Managing Depression","Managing traumatic feelings"
  ,"Focus attention meditation for ADHD","Anger management","Healing from porn addictions",
  "Healing from substance addictions","Stress management"];

  List<String> personalGrowth = ["Empowering Men","Empowering Women","Empowering Boys","Empowering Girls",
  "Self-care","Living your powerful life now","Finding meaning","Understanding your identity",
  "Valuing your self","Building self-image","The power of thoughts"];

  List<String> relationshipEmpowerment = ["Guidance for husband","Guidance for wife","Loving your wife",
  "Loving your husband","Parental empowerment","Strengthen your marriage","Improving relationship with children",
  "Improving relationship with parents"];

  List<String> biblicalMindfulness = ["Scriptures for peace","Scriptures for sleep",
  "Scriptures for comfort","Scriptures for loneliness","Scriptures for mind transformation",
  "Focusing on the Lord's prayer","Forgiving yourself","Forgiving others","See yourself through the eyes of God"];

  List<String> managingCrises = ["Hope in disappointment","Dealing with failures","Triumph and tragedy"];

  List<String> backAssets = ["assets/back/auntm.png","assets/back/cloud.png","assets/back/flowers.png","assets/back/green.png","assets/back/leaves.png"
  ,"assets/back/road.png","assets/back/sunRiseWater.png","assets/back/sunset.png","assets/back/sunWoods.png",
  "assets/back/way.png"];

  Future getPosts() async {
    var firestore = Firestore.instance;
    QuerySnapshot snapshot = await firestore
        .collection("Anxiety")
        .orderBy('createdAt', descending: true)
        .getDocuments();
    return snapshot.documents;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    snapShot = getPosts();
  }

  Widget _buildAudioTiles(String tileName,int index) {
    if(index!=null) {
      var rng = new Random();
      index = rng.nextInt(backAssets.length);
    }

    int newIndex = index % backAssets.length;
    return  Container(
      margin: EdgeInsets.only(right: 15.0),
      height: 150.0,
      width: 250.0,
      decoration: BoxDecoration(

          borderRadius: BorderRadius.only(
            topRight:Radius.circular(10.0),
            topLeft:Radius.circular(10.0),
            bottomRight:Radius.circular(10.0),
            bottomLeft: Radius.circular(10.0),
          ),
          image: DecorationImage(
              image: AssetImage(backAssets[newIndex]),
              fit: BoxFit.fill
          )

      ),
      child: Stack(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
             // SizedBox(height: 10.0,),

              /*SizedBox(
                height: 10.0,
              ),*/

              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: ColorFiltered(
                  colorFilter: ColorFilter.mode(Colors.white70.withOpacity(0.7), BlendMode.dstATop),
                  child: Container(
                    padding: EdgeInsets.all(10),
                    //margin: EdgeInsets.only(left: 10.0),
                    child: Text(
                      tileName,
                      style: TextStyle(
                          color: Colors.black, fontSize: 18.0),
                    ),
                  ),
                ),
              ),
            /*  Container(
                margin: EdgeInsets.only(left: 10.0,top:10.0),
                child: Text(
                  "Turn down the streets",
                  style: TextStyle(
                      color: Colors.white54, fontSize: 15.0),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 10.0,top:20.0),
                child: Text(
                  "7 Steps | 5-11 min",
                  style: TextStyle(
                      color: Colors.white54, fontSize: 13.0),
                ),
              ),*/
            ],
          ),
        /*  Align(
            alignment: Alignment.bottomRight,
            child: Container(
              height: 100.0,
              width: 90.0,
              decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/tree.png'),
                  )
              ),
            ),
          )*/
        ],
      ),
    );
  }
  Widget _buildTitleHeading(String heading) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
       // SizedBox(width: MediaQuery.of(context).size.width/50.0,),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text(heading,textAlign:TextAlign.left,style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 22.0
          ),),
        ),
      //  SizedBox(width: MediaQuery.of(context).size.width/1.6,),

      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     // appBar: AppBar(title: Text("Meditiate"),centerTitle: true,),
        body: SingleChildScrollView(
            child: Column(
                    children: <Widget>[
                      //Stack of Images with Girl and Love and Accept Yourself
                      Stack(
                        children: <Widget>[
                          Container(
                            height: MediaQuery.of(context).size.height / 3,
                            width: MediaQuery.of(context).size.width / 1,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage('assets/images/Background.png'),
                                  fit: BoxFit.fill),
                            ),
                            child: Stack(
                              children: <Widget>[
                                Align(
                                  alignment: Alignment.topRight,
                                  child: Container(
                                    margin: EdgeInsets.only(top: 30.0),
                                    height: MediaQuery.of(context).size.height / 3.9,
                                    width: MediaQuery.of(context).size.width / 6.2,
                                    child: Image(
                                      image: AssetImage('assets/images/nat1.png'),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                                Align(alignment: Alignment.topRight,
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(0,30,30,0),
                                    child: IconButton(
                                      icon: Icon(Icons.arrow_back,color: Colors.white,size: 30,),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ),),
                                Container(
                                  margin: EdgeInsets.only(
                                      top: MediaQuery.of(context).size.height / 20,
                                      left: 10.0),
                                  height: MediaQuery.of(context).size.height / 5.5,
                                  width: MediaQuery.of(context).size.width / 1.5,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          SizedBox(
                                            height: 10.0,
                                          ),
                                          Text(
                                            "Love And Accept",
                                            style: TextStyle(
                                                color: Colors.white, fontSize: 25.0),
                                          ),
                                          Text(
                                            "Yourself",
                                            style: TextStyle(
                                                color: Colors.white, fontSize: 25.0),
                                          ),
                                        ],
                                      ),

                                    ],
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Container(
                                    height: MediaQuery.of(context).size.height / 5.8,
                                    width: MediaQuery.of(context).size.width / 3.5,
                                    child: Image(
                                      image: AssetImage('assets/images/nature.png'),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Container(
                              margin: EdgeInsets.only(top: 100.0, right: 10.0),
                              height: MediaQuery.of(context).size.height / 3.8,
                              width: MediaQuery.of(context).size.width / 2,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage('assets/images/girl.png'),
                                    fit: BoxFit.fill,
                                  )),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height/90.0,
                      ),

                      _buildTitleHeading("Mental Health"),
                      SingleChildScrollView(
                        padding: EdgeInsets.only(top: 5.0),
                        child: Row(
                          children: <Widget>[
                            SizedBox(width: MediaQuery.of(context).size.height/60,),
                            for(String item in mentalHealth ) InkWell(
                                onTap: () {
                                  Navigator.of(context).push(new MaterialPageRoute(builder: (context)=> MentalTraining(titleHead: "Mental Health",audiolistName: item,isAdmin: widget.isAdmin,)));
                                },
                                child: _buildAudioTiles(item,mentalHealth.indexOf(item))
                            ),
                          ],
                        ),
                        scrollDirection: Axis.horizontal,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height/90.0,
                      ),

                     _buildTitleHeading("Personal Growth"),
                      SingleChildScrollView(
                        padding: EdgeInsets.only(top: 5.0),
                        child: Row(
                          children: <Widget>[
                            SizedBox(width: MediaQuery.of(context).size.height/60,),
                            for(String item in personalGrowth ) InkWell(
                onTap: () {
                Navigator.of(context).push(new MaterialPageRoute(builder: (context)=> MentalTraining(titleHead: "Personal Growth",audiolistName: item,isAdmin: widget.isAdmin,)));
                },
                                child:_buildAudioTiles(item,personalGrowth.indexOf(item))),
                          ],
                        ),
                        scrollDirection: Axis.horizontal,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height/90.0,
                      ),

                      _buildTitleHeading("Relationship Empowerment"),
                      SingleChildScrollView(
                        padding: EdgeInsets.only(top: 5.0),
                        child: Row(
                          children: <Widget>[
                            SizedBox(width: MediaQuery.of(context).size.height/60,),
                            for(String item in relationshipEmpowerment ) InkWell(
                                onTap: () {
                                  Navigator.of(context).push(new MaterialPageRoute(builder: (context)=> MentalTraining(titleHead: "Relationship Empowerment",audiolistName: item,isAdmin: widget.isAdmin,)));
                                },
                                child: _buildAudioTiles(item,relationshipEmpowerment.indexOf(item))),
                          ],
                        ),
                        scrollDirection: Axis.horizontal,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height/90.0,
                      ),

                      _buildTitleHeading("Biblical Mindfulness"),
                      SingleChildScrollView(
                        padding: EdgeInsets.only(top: 5.0),
                        child: Row(
                          children: <Widget>[
                            SizedBox(width: MediaQuery.of(context).size.height/60,),
                            for(String item in biblicalMindfulness ) InkWell(
                                onTap: () {
                                  Navigator.of(context).push(new MaterialPageRoute(builder: (context)=> MentalTraining(titleHead: "Biblical Mindfulness",audiolistName: item,isAdmin: widget.isAdmin,)));
                                },
                                child: _buildAudioTiles(item,biblicalMindfulness.indexOf(item))),
                          ],
                        ),
                        scrollDirection: Axis.horizontal,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height/90.0,
                      ),

                      _buildTitleHeading("Managing Crises"),
                      SingleChildScrollView(
                        padding: EdgeInsets.only(top: 5.0),
                        child: Row(
                          children: <Widget>[
                            SizedBox(width: MediaQuery.of(context).size.height/60,),
                            for(String item in managingCrises ) InkWell(
                                onTap: () {
                                  Navigator.of(context).push(new MaterialPageRoute(builder: (context)=> MentalTraining(titleHead: "Managing Crises",audiolistName: item,isAdmin: widget.isAdmin,)));
                                },
                                child: _buildAudioTiles(item,managingCrises.indexOf(item))),
                          ],
                        ),
                        scrollDirection: Axis.horizontal,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height/90.0,
                      ),
                    ],
                  )),
                 );
                }

  }

