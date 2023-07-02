import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:todo/constants.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    // Create a map with the login credentials
    var credentials = {
      'email': email,
      'password': password,
    };

 void _clearTextFields() {
  _emailController.clear();
  _passwordController.clear();
}
    // Send the POST request to the login API endpoint
    var response = await http.post(
      Uri.parse('$api/login/'), // Replace with your API endpoint URL
      body: jsonEncode(credentials),
      headers: {'Content-Type': 'application/json'},
    );

    // Check the response status code
    if (response.statusCode == 200) {
      // Successful login, navigate to the home screen or perform other actions
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      // Invalid login, show an error message or perform other actions
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Invalid email or password.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
        _clearTextFields();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _login,
              child: Text('Login'),
            ),
            SizedBox(height: 16.0),
          MouseRegion(
            cursor: SystemMouseCursors.click, // Set the cursor to clickable
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/signup');
              },
              child: Text(
                'Create New User',
                style: TextStyle(
                  color: Colors.deepPurple,
                              ),
              ),
            ),
          ),
          ],
        ),
      ),
    );
  }
}
