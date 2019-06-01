import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hack/src/profile/profile_screen.dart';

import 'login.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue, accentColor: Colors.green),
      home: ProfileScreen(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void _handleAuth() {
    FirebaseAuth.instance.onAuthStateChanged.listen((user) {
      if (user == null) {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return LoginScreen();
        }));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _handleAuth();
  }

  @override
  Widget build(BuildContext context) {
    return ProfileScreen();
  }
}
