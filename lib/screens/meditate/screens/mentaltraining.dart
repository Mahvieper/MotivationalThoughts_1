import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'addMeditateMusic.dart';
import 'playarea.dart';

class MentalTraining extends StatefulWidget {
  MentalTraining({this.titleHead, this.audiolistName, this.isAdmin});
  String titleHead;
  String audiolistName;
  final bool isAdmin;
  @override
  _MentalTrainingState createState() => _MentalTrainingState();
}

class _MentalTrainingState extends State<MentalTraining> {
  Future snapShot;
  Future getPosts() async {
    var firestore = Firestore.instance;
    QuerySnapshot snapshot = await firestore
        .collection(widget.titleHead)
        .document(widget.audiolistName)
        .collection("Audios")
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

  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    return SafeArea(
      child: Scaffold(
        /*appBar: AppBar(
          backgroundColor: Colors.transparent,
          bottomOpacity: 0.0,
          elevation: 0.0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
              size: 19.0,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: Container(
              margin:
                  EdgeInsets.only(left: MediaQuery.of(context).size.width / 5),
              child: Text(
                "Popular",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 25.0),
              )),
        ),*/
        body: Stack(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/blur.png'), fit: BoxFit.fill)),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top:15.0),
                child: Text("Popular",style: TextStyle(color: Colors.white,fontSize: 20),),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: IconButton(icon: Icon(Icons.arrow_back,color: Colors.white,),
              onPressed: () {
                Navigator.of(context).pop();
              },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 50),
              child: StreamBuilder(
                  stream: Firestore.instance
                      .collection(widget.titleHead)
                      .document(widget.audiolistName)
                      .collection("Audios")
                      .snapshots(),
                  builder: (_, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: Text("Loading...",style: TextStyle(color: Colors.white),),
                      );
                    } else {
                      return (snapshot.data.documents.length != 0)
                          ? ListView.builder(
                          itemCount: snapshot.data.documents.length,
                          itemBuilder: (_, index) {
                            DocumentSnapshot mydata =
                            snapshot.data.documents[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            PlayArea(mydata)));
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.black, width: 0.1000)),
                                width: MediaQuery.of(context).size.width,
                                height: 90.0,
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Image(
                                        image:
                                        AssetImage('assets/images/il1.png'),
                                      ),
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.only(left: 30),
                                          child: Text(
                                            "${mydata['audioName']}",
                                            style: TextStyle(
                                                fontSize: 13.0,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                        /*  Text("${mydata['time']}",style: TextStyle(
                                                                    fontWeight: FontWeight.w300
                                                                ),),*/
                                      ],
                                    ),
                                    SizedBox(
                                      width:
                                      MediaQuery.of(context).size.width / 4.5,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          })
                          : Center(
                        child: Text("No Audios Available",style: TextStyle(color: Colors.white),),
                      );
                    }
                  }),
            ),
          ],
        ),
        floatingActionButton: widget.isAdmin
            ? FloatingActionButton(
                onPressed: () {
                  // Add your onPressed code here!
                  Navigator.of(context).push(new MaterialPageRoute(
                      builder: (context) => MeditateMusicAdd(
                          widget.titleHead, widget.audiolistName)));
                },
                child: Icon(Icons.add),
                backgroundColor: Colors.green,
              )
            : Container(),
      ),
    );
  }
}
