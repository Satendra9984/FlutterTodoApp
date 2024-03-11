//  {
// "userId": 1,
// "id": 1,
// "title": "delectus aut autem",
// "completed": false
// },

class TodoModel {
  final int id;
  final String userId;
  final String title;
  final bool completed;

  TodoModel._({
    required this.id,
    required this.userId,
    required this.title,
    this.completed = false,
  });

  factory TodoModel(Map json) {
    return TodoModel._(
      id: json["id"],
      userId: json["userId"].toString(),
      title: json["title"],
      completed: json["completed"],
    );
  }
}
