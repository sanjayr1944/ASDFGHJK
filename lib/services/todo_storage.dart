import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/todo.dart';

class TodoStorage {
  static const String _key = 'todos_list';

  Future<List<Todo>> loadTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final String? todosJson = prefs.getString(_key);
    if (todosJson == null) return [];

    final List<dynamic> decoded = jsonDecode(todosJson);
    return decoded.map((item) => Todo.fromJson(item)).toList();
  }

  Future<void> saveTodos(List<Todo> todos) async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded = jsonEncode(todos.map((e) => e.toJson()).toList());
    await prefs.setString(_key, encoded);
  }
}