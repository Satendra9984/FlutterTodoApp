part of 'todo_cubit.dart';

class TodoState extends Equatable {
  final LoadState? loadState;
  final List<TodoModel> listTodoModel;
  final LoadState? addLoadState;
  final LoadState? editLoadState;
  final LoadState? deleteLoadState;

  const TodoState({
    this.loadState,
    required this.listTodoModel,
    this.addLoadState,
    this.editLoadState,
    this.deleteLoadState,
  });

  TodoState copyWith({
    LoadState? loadState,
    List<TodoModel>? listTodoModel,
    LoadState? addLoadState,
    LoadState? editLoadState,
    LoadState? deleteLoadState,
  }) {
    return TodoState(
      loadState: loadState ?? this.loadState,
      listTodoModel: listTodoModel ?? this.listTodoModel,
      addLoadState: addLoadState ?? this.addLoadState,
      editLoadState: editLoadState ?? this.editLoadState,
      deleteLoadState: deleteLoadState ?? this.deleteLoadState,
    );
  }

  @override
  List<Object?> get props => [
        loadState,
        listTodoModel,
        addLoadState,
        editLoadState,
        deleteLoadState,
      ];
}

enum LoadState {
  initial,
  loading,
  loaded,
  errorLoading,
}
