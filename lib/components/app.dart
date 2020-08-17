import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_todo_app/configs/const_text.dart';
import 'package:flutter_todo_app/repositories/todo_bloc.dart';
import 'package:flutter_todo_app/components/todo_list/todo_list_view.dart';

class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // DEBUGラベルの消去
      debugShowCheckedModeBanner: false,
      title: ConstText.appTitle,
      theme: ThemeData(
        brightness: Brightness.light,
      ),
      // ダークモード対応
      darkTheme: ThemeData(brightness: Brightness.dark),
      // ProviderからBLoCを下層に渡す
      home: Provider<TodoBloc>(
        create: (context) => new TodoBloc(),
        dispose: (context, bloc) => bloc.dispose(), // dispose記述のため、不要時に削除される
        child: TodoListView(),
      ),
    );
  }
}
