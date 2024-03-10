//  {
// "userId": 1,
// "id": 1,
// "title": "delectus aut autem",
// "completed": false
// },

class TodoModel {
  final String userId;
  final String id;
  final String title;
  final bool completed;

  TodoModel({
    required this.id,
    required this.userId,
    required this.title,
    this.completed = false,
  });
}
