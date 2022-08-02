import 'package:firebase_auth/firebase_auth.dart';
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
              final user = FirebaseAuth.instance.currentUser;
              await user?.sendEmailVerification();
            },
            child: const Text("Please verify your email"),
          )
        ],
      ),
    );
  }
}
