import 'package:flutter/material.dart';
import 'package:motivationalthoughts/screens/AudioPage.dart';
import 'package:motivationalthoughts/screens/addPosts.dart';

class FeatureSelection extends StatefulWidget {
  @override
  _FeatureSelectionState createState() => _FeatureSelectionState();
}

class _FeatureSelectionState extends State<FeatureSelection> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Selection a Feature"),
      centerTitle: true,),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                direction: Axis.horizontal,
                children: <Widget>[
                  Text("Please Select the choice of Content you want to upload",style: TextStyle(fontSize:14,fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            SizedBox(height: 30,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  child: Text("Image/Text"),
                  onPressed: () {
                    Navigator.of(context).push(new MaterialPageRoute(builder: (context) => AddPost()));
                  },
                ),
                SizedBox(width: 30,),
                RaisedButton(
                  child: Text("Audio"),
                  onPressed: () {
                    Navigator.of(context).push(new MaterialPageRoute(builder: (context) => AddAudio()));
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
