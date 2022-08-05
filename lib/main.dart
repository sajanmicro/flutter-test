import 'package:app55/constants/routes.dart';
import 'package:app55/pages/email_view.dart';
import 'package:app55/pages/login.dart';
import 'package:app55/pages/notes_view.dart';
import 'package:app55/pages/registerview.dart';
import 'package:app55/services/auth/auth_services.dart';
import 'package:flutter/material.dart';

//import 'dart:developer' show log;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const HomePage(),
      routes: {
        loginRoute: (context) => const LoginPage(),
        registerRoute: (context) => const RegisterView(),
        notesRoute: (context) => const NotesView(),
        emailRoute: (context) => const EmailView(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.firebase().initialize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = AuthService.firebase().currentUser;
            if (user != null) {
              if (user.isEmailverified) {
                return const NotesView();
              } else {
                return const EmailView();
              }
            } else {
              return const LoginPage();
            }
          //return const Text('Done');
          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}
