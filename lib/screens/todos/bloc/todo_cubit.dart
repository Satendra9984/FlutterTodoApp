import 'dart:typed_data';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ivy_contacts_app/app_services/apicalls.dart';
import 'package:ivy_contacts_app/models/todo_model.dart';
part 'todo_state.dart';

class TodoCubit extends Cubit<TodoState> {
  TodoCubit()
      : super(
          const TodoState(
            listTodoModel: [],
            loadState: LoadState.initial,
          ),
        );

  Future<void> initialiseList() async {
    emit(state.copyWith(loadState: LoadState.loading));
    List<TodoModel> list = [];
    try {
      await ApiCallsUtil.getTodosFromNetwork().then((value) {
        list.addAll(value);
      });
      emit(
        state.copyWith(
          listTodoModel: [...list],
          loadState: LoadState.loaded,
        ),
      );
      // debugPrint(
      //     '[loadstate]: ${state.loadState}\t${state.listTodoModel.length}');
    } catch (e) {
      debugPrint(e.toString());
      emit(state.copyWith(loadState: LoadState.errorLoading));
    }
  }

  Future<void> addTodo({
    required String title,
    required bool completed,
  }) async {
    emit(state.copyWith(addLoadState: LoadState.loading));
    try {
      String userId = FirebaseAuth.instance.currentUser?.uid ?? "#satendrapal";
      TodoModel newtodo = TodoModel({
        "id": state.listTodoModel.length,
        "userId": userId.toString(),
        "title": title,
        "completed": completed,
      });
      List<TodoModel> list = [newtodo, ...state.listTodoModel];

      emit(
        state.copyWith(
          addLoadState: LoadState.loaded,
          listTodoModel: list,
        ),
      );
    } catch (e) {
      debugPrint(e.toString());
      emit(state.copyWith(addLoadState: LoadState.errorLoading));
      await Future.delayed(const Duration(seconds: 2));
      emit(state.copyWith(editLoadState: LoadState.loaded));
    }
  }

  Future<void> updateTodo(TodoModel todoModel) async {
    emit(state.copyWith(editLoadState: LoadState.loading));
    try {
      List<TodoModel> list = state.listTodoModel;

      int index = list.indexWhere(
        (element) => element.id == todoModel.id,
      );

      list[index] = todoModel;
      emit(state.copyWith(
        listTodoModel: [...list],
        editLoadState: LoadState.loaded,
      ));
    } catch (e) {
      debugPrint(e.toString());
      emit(state.copyWith(editLoadState: LoadState.errorLoading));
      await Future.delayed(const Duration(seconds: 2));
      emit(state.copyWith(editLoadState: LoadState.loaded));
    }
  }

  Future<void> deleteTodo(TodoModel todoModel) async {
    emit(state.copyWith(deleteLoadState: LoadState.loading));
    try {
      List<TodoModel> list = state.listTodoModel;

      list.removeWhere((element) => element.id == todoModel.id);
      emit(state.copyWith(listTodoModel: [...list]));
    } catch (e) {
      debugPrint(e.toString());
      emit(state.copyWith(deleteLoadState: LoadState.errorLoading));
      await Future.delayed(const Duration(seconds: 2));
      emit(state.copyWith(editLoadState: LoadState.loaded));
    }
  }

  void sortInCompleted() {
    List<TodoModel> list = [...state.listTodoModel];

    list.sort((a, b) {
      return a.completed == true ? 1 : 0;
    });

    emit(state.copyWith(listTodoModel: list));
  }

  void sortCompleted() {
    List<TodoModel> list = [...state.listTodoModel];

    list.sort((a, b) {
      return a.completed == true ? 0 : 1;
    });

    emit(state.copyWith(listTodoModel: list));
  }
}
