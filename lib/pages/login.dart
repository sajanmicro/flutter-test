import 'package:app55/constants/routes.dart';
import 'package:app55/services/auth/auth_exceptions.dart';
import 'package:app55/services/auth/auth_services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/src/foundation/key.dart';
// import 'package:flutter/src/widgets/framework.dart';
import 'package:app55/firebase_options.dart';

import '../utilities/error_dialog.dart';
//import 'package:firebase_core/firebase_core.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Login'),
      // ),
      body: FutureBuilder(
        future: Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Image.asset(
                        fit: BoxFit.cover, height: 150, 'assets/login.png'),
                    TextField(
                      decoration: const InputDecoration(
                        hintText: 'Enter Email',
                      ),
                      enableSuggestions: false,
                      autocorrect: false,
                      controller: _email,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    TextField(
                      decoration: const InputDecoration(
                        hintText: 'Enter Password',
                      ),
                      controller: _password,
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        final email = _email.text;
                        final password = _password.text;
                        try {
                          await AuthService.firebase().logIn(
                            email: email,
                            password: password,
                          );
                          final user = AuthService.firebase().currentUser;
                          if (user?.isEmailverified ?? false) {
                            // ignore: use_build_context_synchronously
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                notesRoute, (_) => false);
                          } else {
                            // ignore: use_build_context_synchronously
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                emailRoute, (_) => false);
                          }
                          // ignore: use_build_context_synchronously

                        } on UserNotFoundException {
                          await showErrorDialog(
                            context,
                            'User not found',
                          );
                        } on WrongpasswordException {
                          await showErrorDialog(
                            context,
                            'Wrong password',
                          );
                        } on GenerericException {
                          await showErrorDialog(
                            context,
                            'Authentification Error',
                          );
                        }
                      },
                      child: const Text('Login'),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              '/register/', (route) => false);
                        },
                        child: const Text("Not registered, Register"))
                  ],
                ),
              );

            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}

enum MenuButton { logout }
