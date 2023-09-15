import 'package:flutter/material.dart';

import '../../../models/contact_model.dart';
import '../../../utils/app_functions.dart';
import '../../../widgets/submit_button.dart';
import '../../../widgets/text_input.dart';
import 'edit_contact.dart';

class ViewContact extends StatelessWidget {
  final ContactModel contactModel;
  ViewContact({required this.contactModel, Key? key}) : super(key: key);

  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // navigatePush(context, EditContact());
        },
        backgroundColor: const Color(0xFF29AB87),
        child: const Icon(
          Icons.edit,
          color: Colors.white,
          size: 34,
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Name ${contactModel.name}',
                style: TextStyle(
                  color: Colors.grey.shade800,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
