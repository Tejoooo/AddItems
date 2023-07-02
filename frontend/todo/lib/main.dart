import 'package:flutter/material.dart';
import 'package:todo/pages/login.dart';
import 'package:todo/pages/signup.dart';
import 'package:todo/pages/todo.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignupScreen(),
        '/home': (context) => TodoScreen(),
        '/logout': (context) => LoginScreen(),
      },
    );
  }
}
