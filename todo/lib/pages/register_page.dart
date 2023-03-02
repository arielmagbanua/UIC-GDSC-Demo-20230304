import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

/// The register page for user signup with firebase authentication.
class RegisterPage extends StatefulWidget {
  // route name of the page
  static const String routeName = '/register';

  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  final _formKey = GlobalKey<FormState>();

  // text editing controllers for the form fields
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  /// The regular expression for validating the email.
  final _emailRegExp = RegExp(
    r'^[\w\-\.]+@([\w-]+\.)+[\w-]{2,4}$',
  );

  /// The regular expression for validating the password.
  /// Minimum eight characters, at least one uppercase letter,
  /// one lowercase letter, one number and one special character.
  final _passwordRegExp = RegExp(
    r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{8,}$',
  );

  // users collection reference
  final _usersRef = FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Register'),
          actions: [
            IconButton(
              onPressed: () async {
                // validate returns true if the form is valid, or false otherwise
                if (_formKey.currentState!.validate()) {
                  try {
                    // form is valid then create the user and
                    // obtain the user credential
                    final userCredential = await FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                      email: _emailController.text,
                      password: _passwordController.text,
                    );

                    // the data of the user
                    final userDoc = <String, dynamic>{
                      'name': _nameController.text,
                      'email': userCredential.user!.email,
                    };

                    // create a user doc to user collection
                    _usersRef.doc(userCredential.user!.uid).set(
                          userDoc,
                          SetOptions(merge: true),
                        );

                    // create user was successful notify user
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'The account was successfully created',
                        ),
                      ),
                    );
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'email-already-in-use') {
                      // notify user via snack bar
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'The account already exists for that email',
                          ),
                        ),
                      );
                    } else {
                      // notify user via snack bar
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(e.message ?? 'Something went wrong'),
                        ),
                      );
                    }
                  }
                }
              },
              icon: const Icon(Icons.save),
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 16.0,
            horizontal: 16.0,
          ),
          child: Column(
            children: [
              TextFormField(
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  helperText: 'The name of the user',
                  border: OutlineInputBorder(),
                ),
                controller: _nameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    // no email provided
                    return 'Please provide the name of the user';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  helperText: 'The email of the user',
                  border: OutlineInputBorder(),
                ),
                controller: _emailController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    // no email provided
                    return 'Please provide an email';
                  }

                  // regular expression matching for checking the email
                  if (!_emailRegExp.hasMatch(value)) {
                    // the email did not match a typical email pattern
                    // and likely that the email is invalid
                    return 'Email is invalid';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                keyboardType: TextInputType.text,
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                obscuringCharacter: '*',
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  helperText: 'The password of the user',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    // no email provided
                    return 'Please provide a password';
                  }

                  if (!_passwordRegExp.hasMatch(value)) {
                    // password is invalid
                    return 'Password is invalid';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                keyboardType: TextInputType.text,
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                obscuringCharacter: '*',
                decoration: const InputDecoration(
                  labelText: 'Confirm Password',
                  border: OutlineInputBorder(),
                ),
                controller: _confirmPasswordController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    // no email provided
                    return 'Please provide your password to confirm';
                  }

                  if (value != _passwordController.text) {
                    // the password and confirm password did not match
                    return 'Password did not match';
                  }

                  return null;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
