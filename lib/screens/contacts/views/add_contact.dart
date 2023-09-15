import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ivy_contacts_app/widgets/get_profile_image.dart';

import '../../../app_services/database/firestore_services.dart';
import '../../../utils/app_functions.dart';
import '../../../utils/pick_file.dart';
import '../../../widgets/submit_button.dart';
import '../../../widgets/text_input.dart';
import '../bloc/contact_cubit.dart';

class AddContact extends StatelessWidget {
  AddContact({Key? key}) : super(key: key);

  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  Uint8List? imageData;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ContactCubit, ContactState>(
      listener: (context, state) {
        if (state.editLoadState == LoadState.errorLoading) {
          ScaffoldMessenger.of(context).showSnackBar(getSnackbar(
              Colors.redAccent.shade400,
              "Could Not Add. Something Went Wrong!!!"));
        } else if (state.editLoadState == LoadState.loaded) {
          ScaffoldMessenger.of(context)
              .showSnackBar(getSnackbar(Colors.green, "Successfully Added"));
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0.0,
            centerTitle: true,
            title: Text(
              'Add Contact',
              style: TextStyle(
                color: Colors.grey.shade800,
                fontSize: 18,
              ),
            ),
            iconTheme: const IconThemeData(
                color: Colors.black // <= You can change your color here.
                ),
          ),
          bottomNavigationBar: Builder(builder: (ctx) {
            if (state.addLoadState == LoadState.loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: SubmitButton(
                  color: const Color(0xFF00755E),
                  text: 'Add Contact',
                  onPress: () async {
                    await context
                        .read<ContactCubit>()
                        .addContact(
                          name: _nameController.text,
                          contactNo: _phoneController.text,
                          url: "",
                          image: imageData,
                        )
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
      },
    );
  }
}
