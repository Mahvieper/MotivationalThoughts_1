import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  Widget _backgroundImage() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(200,300,10,20),
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/Courtney.png"),
            fit: BoxFit.scaleDown,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text("About Us"),),
      body: Stack(
        children: <Widget>[
          _backgroundImage(),
          Column(
            children: <Widget>[
              Image.asset("assets/MindRenewal.png"),
              SizedBox(height: 10,),
              Container(
                  padding: EdgeInsets.all(10),
                  child: Wrap(
                    children: <Widget>[
                      Text("Inspirational quotes can offer fresh insights and perspectives "
                          "on problems that everyone faces at one time or another. "
                          "If you are looking for some quotes that might help you feel motivated or energized, you might"
                          " want to start by taking a closer look at these quotes on this application on daily basis",
                        style: TextStyle(fontSize: 18),),

                    ],
                  )
              )
            ],
          ),
        ],
      ),
    );
  }
}
