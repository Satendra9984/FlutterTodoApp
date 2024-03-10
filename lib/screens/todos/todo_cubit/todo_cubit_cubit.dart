import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'todo_cubit_state.dart';

class TodoCubitCubit extends Cubit<TodoCubitState> {
  TodoCubitCubit() : super(TodoCubitInitial());
}
