import 'dart:ui';

import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  Widget _backgroundImage() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(200,300,10,20),
      child: Opacity(
        opacity: 0.7,
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/Courtney.png"),
              fit: BoxFit.scaleDown,
            ),
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
         // _backgroundImage(),
          Column(
            children: <Widget>[
              Image.asset("assets/MindRenewal.png"),
              SizedBox(height: 10,),
              Container(
                  padding: EdgeInsets.all(10),
                  child: Wrap(
                    children: <Widget>[
                      Text("   Mind Renewal Ministry emphasizes on the healing of the mind through a biopsychosocial and Christo-centric perspective. "
                          "We are of the firm belief that true restoration and holistic healing is centered in Jesus Christ and the principles that have been outlined in the scriptures. "
                          "Using up to date and ground-breaking scientific research about the mind to transform lives on earth and to prepare us for our future home."
                          "Mind Renewal Ministry provide daily inspirational thoughts, biblical mediations and devotionals.\n\n"

                          "    Mind Renewal Ministry was founded by Dr Courtney Dookie, a leader and reputable psychotherapist."
                          "He is a Registered Provisional Psychologist. Has a wealth of experience working in Addictions and Mental Health Services, as well as a doctorate clinical psychologist (PsyD)."
                          "He helped people in their journey of overcoming addictions and gaining victory over their mental health issues."
                        ,
                        style: TextStyle(fontSize: 18,fontStyle: FontStyle.italic),),

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
