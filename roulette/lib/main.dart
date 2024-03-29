import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Roulette',
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
  // 画面に表示する要素のインデックス番号を格納する用
  int index = 0;
  // ルーレットの起動有無フラグ
  bool isStart = false;
  // Timerオブジェクトを格納する用
  var timer;
  // ルーレットに選択肢として追加した要素を格納する用
  List<String> elem = [];
  // 要素にチェックが入っているかをboolで格納しておく用
  List<bool> checkBox = [];
  // 画面上部に表示する要素を格納する用
  String displayWord = 'READY?';
  // テキストフィールドにアクセスするためのコントローラー
  TextEditingController addController = TextEditingController();
  // チェックされている要素の数を格納しておく用
  int checkCount = 0;
  // 画面でぐるぐるさせる項目を格納
  List<String> displayElem = [];

  void startTimer() {
    // チェックされている要素数を格納
    checkCount = checkBox.where((bool e) => e == true).toList().length;
    // 選択要素がある1つ以上ある かつ 2つ以上チェックが入っている
    if (elem.length > 0 && checkCount > 1) {
      isStart = !isStart;
      if (isStart) {
        // 画面でぐるぐるさせる項目リストを作成
        displayElem = [];
        for (int i = 0; i < elem.length; i++) {
          if (checkBox[i] == true) {
            displayElem.add(elem[i]);
          }
        }
        timer = Timer.periodic(Duration(milliseconds: 100), onTimer);
      } else {
        setState(() {
          timer.cancel();
        });
      }
    }
  }

  void onTimer(Timer timer) {
    setState(() {
      if (index >= displayElem.length) {
        index = 0;
      }
      displayWord = displayElem[index];
      index++;
    });
  }

  void addElem() {
    if (addController.text != '' && !isStart) {
      setState(() {
        elem.add(addController.text);
        checkBox.add(true);
        addController.text = '';
      });
    }
  }

  void resetElem() {
    if (!isStart) {
      setState(() {
        for (int i = 0; i < checkBox.length; i++) {
          checkBox[i] = false;
        }
        displayWord = 'READY?';
      });
    }
  }

  void allSelectElem() {
    if (!isStart) {
      setState(() {
        for (int i = 0; i < checkBox.length; i++) {
          checkBox[i] = true;
        }
        displayWord = 'READY?';
      });
    }
  }

  void deleteElem(int index) {
    if (!isStart) {
      setState(() {
        elem.remove(elem[index]);
        checkBox.removeAt(index);
        displayWord = 'READY?';
      });
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
                      hintText: '項目を入力してね',
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
                    child: Text(
                      '追加',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              flex: 7,
              child: Container(
                color: Colors.blue[100],
                child: Column(
                  children: [
                    Expanded(
                      flex: 4,
                      child: elem.length == 0
                          ? Center(
                              child: Text(
                                '項目を追加してね',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: Colors.black,
                                ),
                              ),
                            )
                          : ListView.builder(
                              itemCount: checkBox.length,
                              itemBuilder: (BuildContext context, int index) {
                                return CheckboxListTile(
                                  value: checkBox[index],
                                  title: Text(
                                    elem[index],
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  secondary: IconButton(
                                    onPressed: () {
                                      deleteElem(index);
                                    },
                                    icon: Icon(Icons.delete_forever),
                                    color: Colors.black,
                                  ),
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  onChanged: (val) {
                                    if (!isStart) {
                                      setState(() {
                                        checkBox[index] = val!;
                                        // チェックした選択肢を追加、削除した際にはRangeErrorを回避するために一旦結果表示をリセット
                                        displayWord = 'READY?';
                                      });
                                    }
                                  },
                                );
                              },
                            ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        color: Colors.white,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: FloatingActionButton(
                                heroTag: 'reset',
                                child: Icon(Icons.toggle_off_outlined),
                                onPressed: () {
                                  resetElem();
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: FloatingActionButton(
                                heroTag: 'allSelect',
                                child: Icon(Icons.toggle_on),
                                onPressed: () {
                                  allSelectElem();
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: FloatingActionButton(
                                backgroundColor: isStart == true
                                    ? Colors.white
                                    : Colors.pink[300],
                                heroTag: 'start',
                                child: isStart == true
                                    ? Icon(
                                        Icons.stop,
                                        color: Colors.pink,
                                      )
                                    : Icon(Icons.play_arrow),
                                onPressed: () {
                                  startTimer();
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
