import 'package:flutter/material.dart';
import 'package:flutter_sync_storage/flutter_sync_storage.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String words = "";
  bool saved = false;

  @override
  void initState() {
    super.initState();
  }

  void onTextChanged(String newText) {
    words = newText;
  }

  void saveToSyncStorage() async {
    bool result = await FlutterSyncStorage().write("words", words);
    setState(() {
      saved = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              TextField(
                onChanged: onTextChanged,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter text to be saved and hit save'),
              ),
              Text(words),
              RaisedButton(
                onPressed: saveToSyncStorage,
                child: Text("Save to Sync"),
              ),
              Text(saved ? "Saved" : "Not saved")
            ],
          ),
        ),
      ),
    );
  }
}
