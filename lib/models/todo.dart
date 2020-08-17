import 'package:uuid/uuid.dart';

class Todo {
  String id;
  String title;
  DateTime dueDate;
  String note;

  // コンストラクタは「クラス名＋関数」で複数作成することが可能
  Todo(this.title, this.dueDate, this.note);
  Todo.newTodo() {
    title = "";
    dueDate = DateTime.now();
    note = "";
  }

  Todo clone() {
    Todo newTodo = Todo(title, dueDate, note);
    newTodo.id = id;
    return newTodo;
  }

  assignUUID() {
    id = Uuid().v4();
  }
}
