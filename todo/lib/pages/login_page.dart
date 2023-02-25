import 'package:flutter/material.dart';

/// The login page of the app which supports
/// credential and social media authentication.
class LoginPage extends StatefulWidget {
  // route name of the page
  static const String routeName = '/login';

  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [],
            ),
          ),
        ),
      ),
    );
  }
}
