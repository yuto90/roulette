import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Roulette'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int index = 0;
  bool isStart = false;
  var timer;
  // ルーレットに表示する要素
  List<String> elem = [];

  //@override
  //void initState() {
  //Timer.periodic(
  //Duration(seconds: 1),
  //_onTimer,
  //);
  //super.initState();
  //}

  void startTimer() {
    isStart = !isStart;
    if (isStart) {
      timer = Timer.periodic(Duration(milliseconds: 100), _onTimer);
    } else {
      setState(() {
        timer.cancel();
      });
    }
  }

  void _onTimer(Timer timer) {
    setState(() {
      if (index == elem.length - 1) {
        index = 0;
      } else {
        index++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 4,
              child: Container(
                width: double.infinity,
                // 背景色
                color: Colors.blue,
                child: Center(
                  child: Text(
                    elem.length == 0 ? 'Roulette' : elem[index],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 40,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                width: double.infinity,
                color: Colors.blue[300],
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'add',
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Container(
                width: double.infinity,
                color: Colors.blue[100],
                child: Text('aaa'),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: isStart == true
            ? Icon(
                Icons.whatshot,
                color: Colors.pink,
              )
            : Icon(Icons.whatshot),
        onPressed: () {
          startTimer();
        },
      ),
    );
  }
}
