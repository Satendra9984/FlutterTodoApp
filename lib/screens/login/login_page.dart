import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ivy_contacts_app/utils/colors.dart';

import '../../app_services/shared_pref_services.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/submit_button.dart';
import '../../widgets/text_input.dart';

class LogInPage extends ConsumerStatefulWidget {
  const LogInPage({Key? key}) : super(key: key);

  @override
  ConsumerState<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends ConsumerState<LogInPage> {
  late String id;
  final SPServices prefs = SPServices();

  late CustomAuthProvider _provider;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _provider = ref.read(customAuthProvider);
    super.didChangeDependencies();
  }

  final TextEditingController _phoneController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        backgroundColor: const Color(0XFFf0f5ff),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          margin: const EdgeInsets.all(15),
          child: _provider.isLoading
              ? SubmitButton(
                  color: tropicalRainforestGreen,
                  text: 'Sending',
                  onPress: () {},
                  loading: const SizedBox(
                    height: 17,
                    width: 17,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  ),
                )
              : SubmitButton(
                  color: tropicalRainforestGreen,
                  text: 'Send OTP',
                  onPress: () {
                    _provider.setPhoneNumber(_phoneController.text);
                    _provider.signInWithPhone(context);
                  },
                ),
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [Color(0XFFf0f5ff), Colors.white],
            ),
          ),
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(15),
              margin: const EdgeInsets.all(15),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          'Enter Phone Number',
                          style: TextStyle(
                            fontSize: 50,
                            fontWeight: FontWeight.bold,
                            color: deepJungleGreen,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'To use the application',
                          style: TextStyle(fontSize: 27),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Column(
                    children: [
                      CustomTextInput(
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
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
