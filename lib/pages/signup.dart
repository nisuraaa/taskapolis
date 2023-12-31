// import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:taskapolis/pages/auth.dart';
import 'package:taskapolis/reuseable_wdigets/reuseable_widget.dart';

class signUpScreen extends StatefulWidget {
  const signUpScreen({super.key});

  @override
  State<signUpScreen> createState() => _signUpScreenState();
}

class _signUpScreenState extends State<signUpScreen> {
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _confirmPasswordTextController =
      TextEditingController();
  final TextEditingController _firstNameTextController =
      TextEditingController();
  final TextEditingController _lastNameTextController = TextEditingController();

  void signUp() async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      if (_passwordTextController.text != _confirmPasswordTextController.text) {
        Navigator.pop(context);
        errorMessage('Passwords do not match', false);
        return;
      } else if (_firstNameTextController.text.isEmpty ||
          _lastNameTextController.text.isEmpty) {
        Navigator.pop(context);
        errorMessage('Please enter your first and last name', false);
        return;
      } else if (_emailTextController.text.isEmpty) {
        Navigator.pop(context);
        errorMessage('Please enter your email', false);
        return;
      }
      var userCredentials = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _emailTextController.text,
              password: _passwordTextController.text);

      print('userCredentials: $userCredentials');
      await addUserDetails(
        userCredentials.user!.uid,
        _firstNameTextController.text.trim(),
        _lastNameTextController.text.trim(),
      );

      Navigator.pop(context);
      Navigator.popUntil(context, (route) => route.isFirst);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AuthPage()),
      );
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);

      if (e.code == 'email-already-in-use') {
        errorMessage('The account already exists for that email.', true);
      }
    }
  }

  Future addUserDetails(
      String userid, String firstName, String lastName) async {
    // update using  await user.updateProfile(updateInfo);
    var user = FirebaseAuth.instance;
    await user.currentUser!.updateDisplayName('$firstName $lastName');
  }

  void errorMessage(String message, bool isUsed) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            title: const Text('Sign In Failed'),
            content: Text(message),
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
                child: isUsed ? const Text('Sign In') : const Text('Try Again'),
                onPressed: () {
                  // Navigator.popUntil(context, (route) => route.isFirst);
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
              ),
            ]);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: const Text(
            "Sign Up",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration:
                BoxDecoration(color: Theme.of(context).colorScheme.background),
            child: SingleChildScrollView(
                child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 120, 20, 0),
              child: Column(children: <Widget>[
                const SizedBox(height: 20),
                reuseableTextField("First Name", Icons.person_2_outlined, false,
                    _firstNameTextController, context),
                const SizedBox(height: 20),
                reuseableTextField("Last Name", Icons.person_2_outlined, false,
                    _lastNameTextController, context),
                const SizedBox(height: 20),
                reuseableTextField("Email", Icons.email_outlined, false,
                    _emailTextController, context),
                const SizedBox(height: 20),
                reuseableTextField("Password", Icons.lock_outline, true,
                    _passwordTextController, context),
                const SizedBox(height: 20),
                reuseableTextField("Confirm Password", Icons.lock_outline, true,
                    _confirmPasswordTextController, context),
                const SizedBox(height: 20),
                signInSignUpButton(context, false, signUp),
              ]),
            ))));
  }
}
