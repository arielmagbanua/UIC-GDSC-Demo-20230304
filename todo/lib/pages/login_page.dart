import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  helperText: 'The email of the user',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                keyboardType: TextInputType.text,
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                obscuringCharacter: '*',
                decoration: const InputDecoration(
                  labelText: 'Password',
                  helperText: 'The password of the user',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {},
                child: const Text('LOGIN'),
              ),
              ElevatedButton(
                onPressed: () {},
                child: const Text('SIGN-UP'),
              ),
              const SizedBox(height: 32.0),
              Text(
                'Supported Social Media Login',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async {
                  await _loginWithGoogle();
                },
                child: const Text('Google'),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<UserCredential> _loginWithGoogle() async {
    // trigger the authentication flow
    final googleUser = await GoogleSignIn().signIn();

    // obtain the auth details from the request
    final googleAuth = await googleUser?.authentication;

    // create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}
