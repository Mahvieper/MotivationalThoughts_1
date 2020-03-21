
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:motivationalthoughts/auth/authentication.dart';
import 'package:snaplist/snaplist_view.dart';

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
  var ourData ;
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
    QuerySnapshot snapshot = await firestore.collection("Posts").getDocuments();
    return snapshot.documents;
  }

  Future<Null> getRefresh() async {
    await Future.delayed( Duration(seconds: 3) );
    setState(() {
      getPosts();
    });
  }

  Widget _backgroundImage() {
    return  Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/background.jpeg"),
          fit: BoxFit.cover,
        ),
      ),);
  }

  @override
  Widget build(BuildContext context) {
    final Size cardSize = Size(MediaQuery.of(context).size.width*0.99, MediaQuery.of(context).size.height*0.8);
    return Scaffold(
      appBar: AppBar(title: Text("Home"),
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
        ],),

      body : Stack(
        children: <Widget>[
          _backgroundImage(),
          FutureBuilder(
            future: getPosts(),
            builder: (context,snapshot) {
              if(snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return RefreshIndicator(
                  onRefresh: getRefresh,
                  child: SnapList(
                    padding: EdgeInsets.only(
                        left: (MediaQuery.of(context).size.width - cardSize.width) / 2),
                    sizeProvider: (index, data) => cardSize,
                    separatorProvider: (index, data) => Size(10.0, 10.0),
                    positionUpdate: (int index) {
                      if (index == snapshot.data.length - 1) {
                        // loadMore();
                      }
                    },
                    builder: (context, index, data) {
                      ourData = snapshot.data[index];
                      return ClipRRect(
                          borderRadius: new BorderRadius.circular(16.0),
                          child: Container(
                            color: Colors.black38,
                            child: Column(
                              children: <Widget>[
                                Container(
                                  height : MediaQuery.of(context).size.height * 0.4,
                                  width:MediaQuery.of(context).size.width*0.9 ,
                                  padding: EdgeInsets.all(5),
                                  margin: EdgeInsets.only(top: 30),
                                  child: ClipRRect(
                                    borderRadius: new BorderRadius.circular(16.0),
                                    child: Image.network(
                                      ourData.data['image'],
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10,),
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.all(20),
                                    child: Text(ourData.data['description'],style: TextStyle(color: Colors.white,fontSize: 20,fontFamily: 'Prata'),),
                                  ),
                                )
                              ],
                            ),

                          )
                      );
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


  customDialog(BuildContext context,String img,String des) {
    return showDialog(context: context,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),),
            child: Container(
              height: MediaQuery.of(context).size.height/1.2,
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
                  )
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    // SizedBox(height: 10,),
                    // Text(title,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 25),),
                    SizedBox(height: 10,),
                    Image.network(img,height: 250,),
                    SizedBox(height: 10,),
                    Container(
                        padding: EdgeInsets.all(5),
                        child: Text(des,style: TextStyle(color: Colors.white,fontSize: 17),))
                  ],
                ),
              ),
            ),
          );
        });
  }
}
