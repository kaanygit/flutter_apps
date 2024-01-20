class Todo {
  String? id;
  String? todoText;
  bool isDone;

  Todo({required this.id, required this.todoText, this.isDone = false});

  static List<Todo> todoList() {
    return [
      Todo(id: '01', todoText: 'günaydın', isDone: true),
      Todo(id: '02', todoText: 'koş', isDone: true),
      Todo(id: '03', todoText: 'laptop topla'),
      Todo(id: '04', todoText: 'okula git'),
      Todo(id: '05', todoText: 'eve gel', isDone: true),
    ];
  }
}
