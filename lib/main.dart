import 'package:flutter/material.dart';
import 'package:shared_pref_and_file/auth_page.dart';
import 'package:shared_pref_and_file/test_page.dart';

void main() {
  runApp(const SaveData());
}

class SaveData extends StatefulWidget {
  const SaveData({Key? key}) : super(key: key);

  @override
  _SaveDataState createState() => _SaveDataState();
}

class _SaveDataState extends State<SaveData> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AuthPage(storage: CounterStorage()),
    );
  }
}
