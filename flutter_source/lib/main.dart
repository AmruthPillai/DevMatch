import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_hack/src/profile/profile_screen.dart';

import 'login.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
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
        Future.delayed(const Duration(milliseconds: 2000), () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return LoginScreen();
          }));
        });
      }else{
        Navigator.of(context).push(MaterialPageRoute(builder: (_){
          return ProfileScreen();
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
    return Scaffold(
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Hero(
              tag: 'logo_tag',
              child: Image.asset('assets/logo.png'),
            ),
          ),
        ),
      ),
    );
  }
}
