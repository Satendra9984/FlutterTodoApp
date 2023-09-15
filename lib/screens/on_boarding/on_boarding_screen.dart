import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ivy_contacts_app/screens/contacts/views/contact_list_screen.dart';
import 'package:ivy_contacts_app/utils/app_functions.dart';
import '../../app_services/database/firestore_services.dart';
import '../../app_services/database/shared_pref_services.dart';
import '../login/login_page.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  late bool loggedIn;
  final SPServices _spServices = SPServices();

  void initialization() async {
    final auth = FirebaseAuth.instance;
    final uid = auth.currentUser?.uid;
    await _spServices.getToken().then((token) {
      if (uid != null && token != null) {
        /// checking if field verifier already exists
        navigatePushReplacement(context, HomeScreen());
      } else {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (ctx) => const LogInPage()));
      }
    });
  }

  @override
  void initState() {
    initialization();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Ivy Contact App',
          style: TextStyle(fontSize: 48.0),
        ),
      ),
    );
  }
}
