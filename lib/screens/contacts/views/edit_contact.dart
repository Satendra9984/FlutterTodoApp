import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ivy_contacts_app/utils/app_functions.dart';

import '../../../models/contact_model.dart';
import '../../../widgets/get_profile_image.dart';
import '../../../widgets/submit_button.dart';
import '../../../widgets/text_input.dart';
import '../bloc/contact_cubit.dart';

class EditContact extends StatefulWidget {
  final ContactModel contactModel;
  final int index;
  EditContact({required this.contactModel, required this.index, Key? key})
      : super(key: key);

  @override
  State<EditContact> createState() => _EditContactState();
}

class _EditContactState extends State<EditContact> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  Uint8List? imageData;

  @override
  void initState() {
    _phoneController.text = widget.contactModel.contactNo;
    _nameController.text = widget.contactModel.name;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ContactCubit, ContactState>(listener: (context, state) {
      if (state.editLoadState == LoadState.errorLoading) {
        ScaffoldMessenger.of(context).showSnackBar(getSnackbar(
            Colors.redAccent.shade400,
            "Could Not Update. Something Went Wrong!!!"));
      }
      if (state.editLoadState == LoadState.loaded) {
        ScaffoldMessenger.of(context)
            .showSnackBar(getSnackbar(Colors.green, "Successfully Updated"));
      }
      if (state.deleteLoadState == LoadState.errorLoading) {
        ScaffoldMessenger.of(context).showSnackBar(getSnackbar(
            Colors.redAccent.shade400,
            "Could Not Delete. Something Went Wrong!!!"));
      }
      if (state.deleteLoadState == LoadState.loaded) {
        ScaffoldMessenger.of(context).showSnackBar(
            getSnackbar(Colors.green, "Successfully Deleted Contact"));
      }
    }, builder: (context, state) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          centerTitle: true,
          title: Text(
            'Update Contact',
            style: TextStyle(
              color: Colors.grey.shade800,
              fontSize: 18,
            ),
          ),
          iconTheme: const IconThemeData(
            color: Colors.black, // <= You can change your color here.
          ),
          actions: [
            IconButton(
              onPressed: () async {
                await context
                    .read<ContactCubit>()
                    .deleteContact(widget.contactModel, widget.index)
                    .then((value) {
                  Navigator.pop(context);
                });
              },
              icon: const Icon(
                Icons.delete,
              ),
            ),
          ],
        ),
        bottomNavigationBar: Builder(builder: (ctx) {
          if (state.editLoadState == LoadState.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: SubmitButton(
                color: const Color(0xFF00755E),
                text: 'Update Contacts',
                onPress: () async {
                  ContactModel contactModel = ContactModel.fromJson({
                    "id": widget.contactModel.id,
                    "name": _nameController.text,
                    "contactNo": _phoneController.text,
                    "profilePhoto": "",
                  });
                  await context
                      .read<ContactCubit>()
                      .updateContact(contactModel, widget.index, imageData)
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
                Center(
                  child: GetProfileImageWidget(
                    id: widget.contactModel.id,
                    callBack: (Uint8List? image) {
                      imageData = image;
                    },
                  ),
                ),
                const SizedBox(height: 25),
                Text(
                  'Name',
                  style: TextStyle(
                    color: Colors.grey.shade800,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 5),
                CustomTextInput(
                  controller: _nameController,
                  text: "Name",
                  keyboardType: TextInputType.name,
                  password: false,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Enter the name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 25),
                Text(
                  'Phone Number',
                  style: TextStyle(
                    color: Colors.grey.shade800,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Text(
                      '+91 ',
                      style: TextStyle(
                        color: Colors.grey.shade800,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Expanded(
                      child: CustomTextInput(
                        controller: _phoneController,
                        text: "Phone Number",
                        keyboardType: TextInputType.number,
                        password: false,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter mobile number';
                          } else if (value.length < 10 || value.length > 10) {
                            return 'Number should be of 10 digits';
                          }
                          return null;
                        },
                      ),
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
