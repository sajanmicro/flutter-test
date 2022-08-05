import 'package:app55/constants/routes.dart';
import 'package:app55/services/auth/auth_services.dart';
import 'package:flutter/material.dart';

class EmailView extends StatefulWidget {
  const EmailView({Key? key}) : super(key: key);

  @override
  State<EmailView> createState() => _EmailViewState();
}

class _EmailViewState extends State<EmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Email verifiy'),
      ),
      body: Column(
        children: [
          TextButton(
            onPressed: () async {
              AuthService.firebase().sendEmailVerification();
            },
            child: const Text("Please verify your email"),
          ),
          TextButton(
            onPressed: () async {
              await AuthService.firebase().logOut();
              // ignore: use_build_context_synchronously
              Navigator.of(context).pushNamedAndRemoveUntil(
                registerRoute,
                (route) => false,
              );
            },
            child: const Text('Restart'),
          ),
        ],
      ),
    );
  }
}
