import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ivy_contacts_app/models/todo_model.dart';
import 'package:ivy_contacts_app/utils/app_functions.dart';
import '../../../widgets/submit_button.dart';
import '../../../widgets/text_input.dart';
import '../bloc/todo_cubit.dart';

class AddTodo extends StatefulWidget {
  const AddTodo({Key? key}) : super(key: key);

  @override
  State<AddTodo> createState() => _EditTodoState();
}

class _EditTodoState extends State<AddTodo> {
  final TextEditingController _titleController = TextEditingController();
  bool _completed = false;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TodoCubit, TodoState>(listener: (context, state) {
      if (state.addLoadState == LoadState.errorLoading) {
        ScaffoldMessenger.of(context).showSnackBar(getSnackbar(
            Colors.redAccent.shade400,
            "Could Not Add. Something Went Wrong!!!"));
      }
      if (state.addLoadState == LoadState.loaded) {
        ScaffoldMessenger.of(context)
            .showSnackBar(getSnackbar(Colors.green, "Successfully Added"));
      }
    }, builder: (context, state) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          centerTitle: true,
          title: Text(
            'Add Todo',
            style: TextStyle(
              color: Colors.grey.shade800,
              fontSize: 18,
            ),
          ),
          iconTheme: const IconThemeData(
            color: Colors.black, // <= You can change your color here.
          ),
          
        ),
        bottomNavigationBar: Builder(builder: (ctx) {
          if (state.addLoadState == LoadState.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: SubmitButton(
                color: const Color(0xFF00755E),
                text: 'Add Todo',
                onPress: () async {
                  if (formKey.currentState?.validate() == false) {
                    return;
                  }
                  
                  await context
                      .read<TodoCubit>()
                      .addTodo(title: _titleController.text, completed: _completed)
                      .then((value) {
                    Navigator.pop(context);
                  });
                },
              ),
            );
          }
        }),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Title',
                  style: TextStyle(
                    color: Colors.grey.shade800,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 5),
                CustomTextInput(
                  controller: _titleController,
                  text: "Title",
                  keyboardType: TextInputType.name,
                  password: false,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Enter the title';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Completed ',
                      style: TextStyle(
                        color: Colors.grey.shade800,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Switch(
                      value: _completed,
                      onChanged: (newval) {
                        setState(() {
                          _completed = newval;
                        });
                      },
                      activeTrackColor: Colors.green,
                      activeColor: Colors.white,
                      inactiveTrackColor: Colors.red,
                      inactiveThumbColor: Colors.white,
                      trackOutlineColor: MaterialStateColor.resolveWith((states) => Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
