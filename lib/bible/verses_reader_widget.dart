import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class VersesReaderWidget extends StatelessWidget {
  VersesReaderWidget({this.verses});

  final List<dynamic> verses;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: verses.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          margin: EdgeInsets.only(bottom: 10.0),
          child: InkWell(
            onTap: () {
              Clipboard.setData(new ClipboardData(text: '${verses[index]}'));
              final snackBar = SnackBar(
                content: Text('Copied to Clipboard'),
                action: SnackBarAction(
                  label: 'Undo',
                  onPressed: () {},
                ),
              );
              Scaffold.of(context).showSnackBar(snackBar);
              },
            child: RichText(
              text: TextSpan(children: <TextSpan>[
                TextSpan(
                    text: '${index + 1} ',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: '${verses[index]}')
              ], style: DefaultTextStyle.of(context).style),
            ),
          ),
        );
      },
    );
  }
}