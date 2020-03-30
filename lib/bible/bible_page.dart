import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

import 'book_list_page.dart';

class BiblePage extends StatefulWidget {
  @override
  _BiblePageState createState() => _BiblePageState();
}

class _BiblePageState extends State<BiblePage> {
  List<dynamic> data = [];

  @override
  void initState() {
    super.initState();

    loadBibleData().then((String d) => {
          setState(() {
            data = jsonDecode(d);
          })
        });
  }

  Future<String> loadBibleData() async {
    return await rootBundle.loadString('assets/en_kjv.json');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BookListPage(title: 'Book List', books: this.data),
    );
  }
}
