import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'firebase_options.dart';
import 'pages/error_page.dart';
import 'pages/loading_page.dart';
import 'pages/login_page.dart';
import 'pages/tasks_page.dart';

void main() {
  // ensure widgets binding are initialized
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();

  /// Generate routes for the app here
  Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case TasksPage.routeName:
        return MaterialPageRoute(
          builder: (_) => const TasksPage(),
        );
      case LoginPage.routeName:
        return MaterialPageRoute(
          builder: (_) => const LoginPage(),
        );
      default:
        return MaterialPageRoute(
          builder: (_) =>
              const ErrorPage(errorMessage: 'Something went wrong!'),
        );
    }
  }
}

class _MyAppState extends State<MyApp> {
  // hold the future result of initialization.
  final _initFirebaseApp = Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // create a new global key for navigator state which will be used
  // for navigating to pages when user successfully logged in.
  final _navigatorKey = GlobalKey<NavigatorState>();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigatorKey,
      title: 'Todo',
      onGenerateRoute: widget.generateRoute,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder(
        future: _initFirebaseApp,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            // something went wrong therefore display the error page
            return ErrorPage(
              errorMessage: snapshot.error.toString(),
            );
          }

          if (snapshot.connectionState == ConnectionState.done) {
            // firebase has successfully initialized
            // now listen for auth changes and navigate to the proper page
            // depending on if the user has logged in.
            FirebaseAuth.instance.authStateChanges().listen((User? user) {
              if (user == null) {
                // user has logged out or user hasn't logged in yet
                _navigatorKey.currentState!
                    .pushReplacementNamed(LoginPage.routeName);
              } else {
                // user currently logged in
                _navigatorKey.currentState!
                    .pushReplacementNamed(TasksPage.routeName);
              }
            });
          }

          return const LoadingPage();
        },
      ),
    );
  }
}
