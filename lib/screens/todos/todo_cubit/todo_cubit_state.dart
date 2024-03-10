part of 'todo_cubit_cubit.dart';

sealed class TodoCubitState extends Equatable {
  const TodoCubitState();

  @override
  List<Object> get props => [];
}

final class TodoCubitInitial extends TodoCubitState {}
