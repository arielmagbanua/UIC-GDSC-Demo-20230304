import 'package:flutter/material.dart';

/// A simple page which displays any error.
class ErrorPage extends StatelessWidget {
  final String errorMessage;

  const ErrorPage({
    Key? key,
    required this.errorMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Text(
            errorMessage,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.red
            ),
          ),
        ),
      ),
    );
  }
}
