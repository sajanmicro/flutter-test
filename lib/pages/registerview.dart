import 'package:app55/constants/routes.dart';
import 'package:app55/services/auth/auth_exceptions.dart';
import 'package:app55/services/auth/auth_services.dart';
import 'package:app55/utilities/error_dialog.dart';
import 'package:flutter/material.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: FutureBuilder(
        future: AuthService.firebase().initialize(),
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
                          await AuthService.firebase().createUser(
                            email: email,
                            password: password,
                          );
                          AuthService.firebase().sendEmailVerification();
                          // ignore: use_build_context_synchronously
                          Navigator.of(context).pushNamed(emailRoute);
                        } on WeakPasswordException {
                          await showErrorDialog(
                            context,
                            'Weak password',
                          );
                        } on EmailAlreadyUsedException {
                          await showErrorDialog(
                            context,
                            'Email Already in Use',
                          );
                        } on InvalidEmailException {
                          await showErrorDialog(
                            context,
                            'Invalid Email',
                          );
                        } on GenerericException {
                          await showErrorDialog(
                            context,
                            'Registration error',
                          );
                        }

                        // print(userCredential);
                      },
                      child: const Text('Register'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            loginRoute, (route) => false);
                      },
                      child: const Text("Registered, Go to login"),
                    )
                  ],
                ),
              );

            default:
              return const Text('Loading');
          }
        },
      ),
    );
  }
}
