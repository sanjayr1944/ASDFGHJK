import 'package:flutter/foundation.dart';
import '../models/todo.dart';
import '../services/todo_storage.dart';

class TodoProvider extends ChangeNotifier {
  final TodoStorage _storage = TodoStorage();
  List<Todo> _todos = [];
  bool _isLoading = true;

  List<Todo> get todos => _todos;
  bool get isLoading => _isLoading;

  TodoProvider() {
    _loadTodos();
  }

  Future<void> _loadTodos() async {
    _isLoading = true;
    notifyListeners();
    _todos = await _storage.loadTodos();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addTodo(String title) async {
    if (title.trim().isEmpty) return;
    final newTodo = Todo(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title.trim(),
    );
    _todos.add(newTodo);
    notifyListeners();
    await _storage.saveTodos(_todos);
  }

  Future<void> toggleTodo(String id) async {
    final index = _todos.indexWhere((todo) => todo.id == id);
    if (index != -1) {
      _todos[index] = _todos[index].copyWith(isCompleted: !_todos[index].isCompleted);
      notifyListeners();
      await _storage.saveTodos(_todos);
    }
  }

  Future<void> deleteTodo(String id) async {
    _todos.removeWhere((todo) => todo.id == id);
    notifyListeners();
    await _storage.saveTodos(_todos);
  }
}