import 'package:flutter/material.dart';

class UserMetrics extends StatelessWidget {
  final String title;
  final int value;

  const UserMetrics({Key key, this.title, this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.grey,
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5.0)),
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(5.0),
            child: Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
            ),
          ),
          Padding(
              padding: EdgeInsets.only(bottom: 5.0),
              child: Text(
                "$value",
                style: TextStyle(fontWeight: FontWeight.normal, fontSize: 17.0),
              )),
        ],
      ),
    );
  }
}
