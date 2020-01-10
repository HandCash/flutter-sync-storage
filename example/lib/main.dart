import 'package:flutter/material.dart';
import 'package:flutter_sync_storage/flutter_sync_storage.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String words = "";
  String readWords = "";
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

  void readFromSyncStorage() async {
    String words = await FlutterSyncStorage().read("words");
    setState(() {
      readWords = words;
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
              RaisedButton(
                onPressed: saveToSyncStorage,
                child: Text("Save to Sync storage"),
              ),
              Text(saved ? "Saved" : "Not saved"),
              RaisedButton(
                onPressed: readFromSyncStorage,
                child: Text("Read from sync storage"),
              ),
              Text("Read Text: $readWords")
            ],
          ),
        ),
      ),
    );
  }
}
