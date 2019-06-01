import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:DevMatch/button.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.grey[50],
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 80.0, horizontal: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Hero(
                tag: 'logo_tag',
                child: Image.asset(
                  'assets/logo.png',
                ),
              ),
              Text(
                'Find teammates for your next hackathon, smart and easy.',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[800],
                ),
              ),
              Spacer(),
              CustomButton(
                backgroundColor: Colors.grey[900],
                icon: Icon(Icons.lock),
                buttonText: Text(
                  'Login with GitHub',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[50],
                  ),
                ),
                textColor: Colors.grey[900],
                iconAlignment: Alignment.centerRight,
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
