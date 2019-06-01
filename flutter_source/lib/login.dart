import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.grey[50],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Hero(
                tag: 'logo_tag',
                child: Image.asset(
                  'assets/logo.png',
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  'Find teammates for your next hackathon, smart and easy.',
                  style: TextStyle(fontSize: 25, color: Colors.grey[800],),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: MaterialButton(
                onPressed: () {

                },
                color: Colors.white,
                child: Text(
                  'Github',
                  style: TextStyle(color: Colors.redAccent),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
