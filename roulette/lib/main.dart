import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int index = 0;
  bool isStart = false;
  var timer;

  List<String> elem = [];
  List<String> checkedElem = [];
  List<bool> checkBox = [];

  String displayWord = 'Roulette';

  var addController = TextEditingController();

  void startTimer() {
    isStart = !isStart;
    if (isStart) {
      timer = Timer.periodic(Duration(milliseconds: 100), onTimer);
    } else {
      setState(() {
        timer.cancel();
      });
    }
  }

  void onTimer(Timer timer) {
    setState(() {
      if (index == checkedElem.length - 1) {
        index = 0;
      } else {
        index++;
      }
      changeDisplayWord();
    });
  }

  // 要素を追加する用の関数
  void addElem() {
    setState(() {
      elem.add(addController.text);
      checkBox.add(false);
      addController.text = '';
    });
  }

  void changeDisplayWord() {
    if (checkedElem.length == 0) {
      displayWord = 'Roulette';
    } else {
      displayWord = checkedElem[index];
    }
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
                color: Colors.blue,
                child: Center(
                  child: Text(
                    displayWord,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 40,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  flex: 1,
                  child: Icon(
                    Icons.playlist_add_outlined,
                    color: Colors.blue,
                    size: 40.0,
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: TextField(
                    controller: addController,
                    decoration: InputDecoration(
                      hintText: 'input elem',
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.blue),
                    ),
                    onPressed: () {
                      addElem();
                    },
                    child: Text('Add'),
                  ),
                ),
              ],
            ),
            Expanded(
              flex: 7,
              child: Container(
                width: double.infinity,
                color: Colors.blue[100],
                child: Center(
                  child: Column(
                    children: [
                      Flexible(
                        flex: 1,
                        child: ListView.builder(
                          itemCount: checkBox.length,
                          itemBuilder: (BuildContext context, int index) {
                            return (CheckboxListTile(
                              value: checkBox[index],
                              title: Text(
                                elem[index],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              controlAffinity: ListTileControlAffinity.leading,
                              onChanged: (val) {
                                setState(() {
                                  checkBox[index] = val!;
                                  if (val) {
                                    checkedElem.add(elem[index]);
                                  } else {
                                    checkedElem.remove(elem[index]);
                                  }
                                  // チェックした選択肢を追加、削除した際にはRangeErrorを回避するために一旦結果表示をリセット
                                  displayWord = 'Roulette';
                                });
                              },
                            ));
                          },
                        ),
                      ),
                    ],
                  ),
                ),
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
