import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';


class CounterStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/counter.txt');
  }

  Future<int> readCounter() async {
    try {
      final file = await _localFile;

      final contents = await file.readAsString();

      return int.parse(contents);
    } catch (e) {

      return 0;
    }
  }

  Future<File> writeCounter(int counter) async {
    final file = await _localFile;
    return file.writeAsString('$counter');
  }

  Future<File> clearCounter(int counter) async {
    final file = await _localFile;
    return file.writeAsString('$counter');
  }


}

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key, required this.storage}) : super(key: key);

  final CounterStorage storage;

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  @override

  String _name = 'name';
  String _text = '';
  TextEditingController nameContoller = TextEditingController();
  int _counter = 0;


  void initState() {
    super.initState();
    widget.storage.readCounter().then((int value) {
      setState(() {
        _counter = value;
        _getName(_name);
      });
    });
  }


    Future<File> _incrementCounter() {
      setState(() {
        _counter++;
      });

      return widget.storage.writeCounter(_counter);
    }



  void _getName(String name) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      if (prefs.containsKey(name) == true) {_text = 'Здравствуйте, '+prefs.getString(name).toString();}
      else {_text = 'Здравствуйте!';}
    });

  }

  void _setName(String name, String text) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(name, text);
  }

  void _clearName(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  String _tryS(int _counter){
    return 'Попыток авторизации: $_counter';
  }
  void upDate(){
    setState(() {
      _getName(_name);
      widget.storage.readCounter();
      print(widget.storage.readCounter().then((value) {
        setState(() {
          _counter = value;
          _getName(_name);
        });
      }));
      _tryS(_counter);
    });
  }


  Widget build(BuildContext context) {

    const borderStyle = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(36)),
      borderSide: BorderSide(color: Color(0xFFECEFF1), width: 2),
    );

    _inputDecoration(String _text) {
      return InputDecoration(
        filled: true,
        fillColor: Color(0xFFECEFF1),
        hintText: _text,
        contentPadding: EdgeInsets.fromLTRB(15, 0, 0, 0),
        hintStyle: TextStyle(fontSize: 16, color: Color.fromRGBO(0, 0, 0, 0.4), ),
        enabledBorder: borderStyle,
        focusedBorder: borderStyle,
      );
    }


    return Scaffold(
      appBar: AppBar(
        actions: [IconButton(onPressed: () {upDate();}, icon: Icon(Icons.update))],
      ),
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
        child: Column(
          children: [
            SizedBox(
              height: 30,
                  child: Text(_text, style: TextStyle(fontSize: 18, color: Color(0x99000000)),),
            ),
            SizedBox(
              height: 15,
              child: Text('Для продолжения авторизуйтесь:', style: TextStyle(fontSize: 16, color: Color(0x99000000))),
            ),
            SizedBox(height: 15,),
            SizedBox(
              height: 34,
              width: 300,
              child: TextFormField(
                controller: nameContoller,
                onSaved: (String? value) async{
                  print(value);
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  prefs.setString('name', value!);
                },
                decoration: _inputDecoration('Логин'),
              ),
            ),
            SizedBox(height: 30,),
            SizedBox(
              height: 34,
              width: 300,
              child: TextFormField(
                obscureText: true,
                decoration: _inputDecoration('Пароль'),
              ),
            ),
            SizedBox(height: 20,),
            SizedBox(
              width: 150,
                child: ElevatedButton( onPressed: (){
                  _setName(_name, nameContoller.text);
                  _incrementCounter();
                  widget.storage.writeCounter(_counter);
                  },
                  child: Text('Запомнить логин'),
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF0079D0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22.0)
                    ),
                  ),
                )
            ),
            SizedBox(height: 20,),
            SizedBox(
                width: 150,
                child: ElevatedButton( onPressed: () {
                  _clearName(_name);
                  widget.storage.clearCounter(0);
                  nameContoller.text='';
                  upDate();
                },
                  child: Text('Очистить'),
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF0079D0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22.0)
                    ),
                  ),
                )
            ),
            SizedBox(height: 10,),
            SizedBox(
              height: 30,
              child: Text(_tryS(_counter), style: TextStyle(fontSize: 16, color: Color(0x99000000))),
            ),
          ],
        ),
      ),
    );
  }
}



