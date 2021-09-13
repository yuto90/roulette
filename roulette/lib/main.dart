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
  List<String> member = ['gako', 'yuto', 'tika'];

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
      timer = Timer.periodic(Duration(seconds: 1), _onTimer);
    } else {
      timer.cancel();
    }
  }

  void _onTimer(Timer timer) {
    setState(() {
      if (index == 2) {
        index = 0;
      } else {
        index++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Container(
                width: double.infinity,
                // 背景色
                color: Colors.blue,
                child: Center(
                  child: Text(
                    member[index],
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
              child: Container(
                child: Text('aaa'),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.close),
        onPressed: () {
          startTimer();
        },
      ),
    );
  }
}
