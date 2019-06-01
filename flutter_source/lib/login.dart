import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/logo_white.png',
              width: 100,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 24.0),
              child: Text(
                'The Engineer Store',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.w600),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: MaterialButton(
                onPressed: () {},
                color: Colors.white,
                child: Text(
                  'Google',
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
