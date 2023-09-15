import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ivy_contacts_app/providers/auth_provider.dart';
import 'package:ivy_contacts_app/screens/contacts/bloc/contact_cubit.dart';
import 'package:ivy_contacts_app/screens/contacts/views/add_contact.dart';
import 'package:ivy_contacts_app/screens/contacts/views/contact_list_screen.dart';
import 'package:ivy_contacts_app/screens/login/otp_page.dart';
import 'package:ivy_contacts_app/screens/on_boarding/on_boarding_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ContactCubit()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'IvyContactApp',
        theme: ThemeData.light(),
        // ThemeData(
        //   primaryColor: Colors.lightBlue,
        //   primarySwatch: Colors.blue,
        //   fontFamily: 'Roboto',
        // ),
        // home: FileViewerWidget(),
        routes: {
          '/': (context) => const OnBoardingScreen(),
          // '/': (context) => AddContact(),
          // '/': (context) => HomeScreen(),
          // '/': (context) => const OTPPage(),
        },
      ),
    );
  }
}
