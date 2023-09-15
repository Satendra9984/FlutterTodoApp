import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomTextInput extends StatefulWidget {
  final String text;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool password;
  final Function(String? value) validator;

  const CustomTextInput({
    Key? key,
    required this.text,
    required this.keyboardType,
    required this.password,
    required this.controller,
    required this.validator,
  }) : super(key: key);

  @override
  State<CustomTextInput> createState() => _CustomTextInputState();
}

class _CustomTextInputState extends State<CustomTextInput> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade400,
            offset: const Offset(0.0, 1.5), //(x,y)
            blurRadius: 2.5,
          ),
        ],
      ),
      child: FormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        initialValue: widget.controller,
        validator: (val) {
          String? value = widget.controller.text;
          // debugPrint('value --> ${val.runtimeType}');
          return widget.validator(value);
        },
        builder: (formState) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                // focusNode: FocusNode(),
                controller: widget.controller,
                onChanged: (val) {
                  // _textEditingController.text = val;
                  formState.didChange(widget.controller);
                },
                minLines: 1,
                decoration: InputDecoration(
                  hintText: widget.text,
                  hintStyle: const TextStyle(
                    color: Colors.black45,
                    fontWeight: FontWeight.w600,
                  ),
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  isDense: false, // Added this
                ),
                keyboardType: widget.keyboardType,
              ),
              if (formState.hasError)
                Padding(
                  padding: const EdgeInsets.only(
                      top: 2, bottom: 2, right: 4, left: 4),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: CupertinoColors.systemRed,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        formState.errorText!,
                        style: const TextStyle(
                          fontSize: 14,
                          color: CupertinoColors.systemRed,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
    );
    ;
  }
}
