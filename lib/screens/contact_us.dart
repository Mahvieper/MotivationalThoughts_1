import 'package:flutter/material.dart';

class ContactUsPage extends StatelessWidget {
  Widget _backgroundImage() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(150,300,10,20),
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/Courtney.png"),
            fit: BoxFit.contain,
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
        title: Text("Contact Us"),),
      body: Stack(
        children: <Widget>[
          _backgroundImage(),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Image.asset("assets/SplashLogo.png"),
                SizedBox(height: 10,),
                Container(
                    padding: EdgeInsets.all(10),
                    child: Wrap(
                      children: <Widget>[
                        Text("---------Contact Us--------",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
                        SizedBox(height: 40,),
                        Text("Email : prdookie@gmail.com",
                          style: TextStyle(fontSize: 18),),
                        SizedBox(height: 40,),
                        Text("Phone : 506 639-0363",
                          style: TextStyle(fontSize: 18),),


                      ],
                    )
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
