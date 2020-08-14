import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // 右上に表示されている"debug"ラベルの削除
      debugShowCheckedModeBanner: false,
      // アプリ名
      title: 'Flutter ToDo App',
      theme: ThemeData(
        // テーマカラー
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: TodoListPage(),
    );
  }
}

// リスト一覧画面用Widget
class TodoListPage extends StatefulWidget {
  @override
  _TodoListPageState createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  // Todoリストのデータ
  List<String> todoList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBarを表示し、タイトルを設定
      appBar: AppBar(
        title: Text("リスト一覧"),
      ),
      // データをもとにListViewを作成する
      body: ListView.separated(
        itemCount: todoList.length,
        itemBuilder: (context, index) {
          // Dissimissible を利用してスワイプでリスト項目を扱うようにする
          return Dismissible(
            key: ObjectKey(todoList[index]),
            // 削除したら、removeする
            onDismissed: (direction) {
              setState(() {
                todoList.removeAt(index);
              });
            },
            // =>スワイプでの処理
            background: Container(
              color: Colors.green,
              child: Icon(Icons.check),
            ),
            // <=スワイプでの処理
            secondaryBackground: Container(
              color: Colors.red,
              child: Icon(Icons.cancel),
            ),
            child: ListTile(
              title: Text(todoList[index]),
              // 既にあるリストを選択した際、編集できるようにする
              // async/awaitをpush()に付け加えると、popの引数で設定したデータを
              // push以降の部分で受け取ることができる
              onTap: () async {
                // リスト編集画面から渡される値を受け取る
                final editListText = await Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) {
                    // 遷移先の画面として、リスト編集画面を指定する
                    // TodoEditPageクラスに引数を持たせて、編集画面にリスト文字を渡す
                    return TodoEditPage(oldText: todoList[index]);
                  }),
                );
                if (editListText != null) {
                  // キャンセルした場合は、editListTextがnullとなるので注意
                  setState(() {
                    todoList[index] = editListText;
                  });
                }
              },
            ),
          );
        },
        // ListView.separatedと組み合わせて、リスト間に区切りを作成
        separatorBuilder: (BuildContext context, int index) => const Divider(),
      ),
      floatingActionButton: FloatingActionButton(
        // async/awaitをpush()に付け加えると、popの引数で設定したデータを
        // push以降の部分で受け取ることができる
        onPressed: () async {
          // "push"で新規画面に遷移(MaterialPageRouteはアニメーション指定)
          // リスト追加画面から渡される値を受け取る
          final newListText = await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) {
              // 遷移先の画面としてリスト追加画面を指定
              return TodoAddPage();
            }),
          );
          if (newListText != null) {
            // キャンセルした場合はnewListTextがnullとなるので注意
            setState(() {
              // リスト追加
              todoList.add(newListText);
            });
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class TodoAddPage extends StatefulWidget {
  @override
  _TodoAddPageState createState() => _TodoAddPageState();
}

class _TodoAddPageState extends State<TodoAddPage> {
  // 入力されたテキストをデータとして持つ
  String _text = "";

  // データをもとに表示するWidget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("リスト追加")),
        body: Container(
          // 余白を付ける
          padding: EdgeInsets.all(64),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // 入力されたテキストを表示
              Text(_text, style: TextStyle(color: Colors.blue)),
              // テキスト入力
              TextField(
                // 入力されたテキストの値を受け取る（valueが入力されたテキスト）
                onChanged: (String value) {
                  // データが変更したことを知らせる（画面を更新する）
                  setState(() {
                    // データを変更
                    _text = value;
                  });
                },
              ),
              Container(
                // 横幅いっぱいに広げる
                width: double.infinity,
                // リスト追加ボタン
                child: RaisedButton(
                  color: Colors.blue,
                  onPressed: () {
                    // "pop"で前の画面に戻る
                    // "pop"の引数から前の画面にデータを渡す
                    Navigator.of(context).pop(_text);
                  },
                  child: Text("リスト追加", style: TextStyle(color: Colors.white)),
                ),
              ),
              Container(
                // 横幅いっぱいに広げる
                width: double.infinity,
                // キャンセルボタン
                child: FlatButton(
                  // ボタンをクリックしたときの処理
                  onPressed: () {
                    // "pop"で前の画面に戻る
                    Navigator.of(context).pop();
                  },
                  child: Text("キャンセル"),
                ),
              )
            ],
          ),
        ));
  }
}

class TodoEditPage extends StatefulWidget {
  // リスト一覧画面からリスト編集画面に文字列を渡すために、Stateを経由する必要があるため、
  // 冗長だが一度値を受け取るようにする
  TodoEditPage({Key key, @required this.oldText}) : super(key: key);
  final String oldText;

  @override
  _TodoEditPageState createState() => _TodoEditPageState(
        oldText: this.oldText,
      );
}

class _TodoEditPageState extends State<TodoEditPage> {
  // リスト一覧画面からリスト編集画面に文字を渡すようにする
  _TodoEditPageState({Key key, @required this.oldText});
  final String oldText;

  // 新規に入力したテキスト内容
  String _newText = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("リスト編集"),
        ),
        body: Container(
            padding: EdgeInsets.all(64),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // リスト一覧画面で入力済みのテキストを表示
                Text(oldText, style: TextStyle(color: Colors.blue)),
                // テキスト入力
                TextField(
                  // 入力されたテキストの値を受け取る
                  onChanged: (String value) {
                    // データが変更したことを受け取る
                    setState(() {
                      // 入力済みの文字列を変更する
                      _newText = value;
                    });
                  },
                ),
                Container(
                  // 横幅いっぱいに広げる
                  width: double.infinity,
                  // リスト追加ボタン
                  child: RaisedButton(
                    color: Colors.blue,
                    onPressed: () {
                      // "pop"の引数から前の画面にデータを渡しながら戻る
                      Navigator.of(context).pop(_newText);
                    },
                    child: Text(
                      "リスト更新",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Container(
                    // 横幅いっぱいに広げる
                    width: double.infinity,
                    // キャンセルボタン
                    child: FlatButton(
                      // ボタンをクリックしたときの処理
                      onPressed: () {
                        // "pop"で前の画面に戻る
                        Navigator.of(context).pop();
                      },
                      child: Text("キャンセル"),
                    )),
              ],
            )));
  }
}
