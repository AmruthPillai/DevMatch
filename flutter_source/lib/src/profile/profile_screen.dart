import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:DevMatch/src/anim/blink_animation.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:location/location.dart';

import '../mentor_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  ProfileScreenState createState() {
    return ProfileScreenState();
  }
}

class ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  double waveRadius = 0.0;
  double waveGap = 10.0;
  Animation<double> _animation;

  //Animation<double> _blinkAnimation;
  AnimationController controller;
  bool findMode = false;
  AnimationController blinkController;

  @override
  void initState() {
    super.initState();
    initPlatformState();
    controller = AnimationController(
        duration: Duration(milliseconds: 1000), vsync: this);

    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.reset();
      } else if (status == AnimationStatus.dismissed) {
        controller.forward();
      }
    });
  }

  LocationData _startLocation;
  LocationData _currentLocation;

  StreamSubscription<LocationData> _locationSubscription;

  Location _locationService = new Location();
  bool _permission = false;
  String error;

  initPlatformState() async {
    Geoflutterfire geo = Geoflutterfire();
    Firestore _firestore = Firestore.instance;
    await _locationService.changeSettings(
        accuracy: LocationAccuracy.HIGH, interval: 1000);

    LocationData location;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      bool serviceStatus = await _locationService.serviceEnabled();
      print("Service status: $serviceStatus");
      if (serviceStatus) {
        _permission = await _locationService.requestPermission();
        print("Permission: $_permission");
        if (_permission) {
          location = await _locationService.getLocation();

          _locationSubscription = _locationService
              .onLocationChanged()
              .listen((LocationData result) async {
            if (mounted) {
              setState(() {
                _currentLocation = result;
                GeoFirePoint myLocation = geo.point(
                    latitude: _currentLocation.latitude,
                    longitude: _currentLocation.longitude);
                print("LOCATION : ${myLocation.data}");
                Firestore.instance
                  ..collection('users').add(
                      {'name': 'random name', 'position': myLocation.data});
              });
            }
          });
        }
      } else {
        bool serviceStatusResult = await _locationService.requestService();
        print("Service status activated after request: $serviceStatusResult");
        if (serviceStatusResult) {
          initPlatformState();
        }
      }
    } on PlatformException catch (e) {
      print(e);
      if (e.code == 'PERMISSION_DENIED') {
        error = e.message;
      } else if (e.code == 'SERVICE_STATUS_ERROR') {
        error = e.message;
      }
      location = null;
    }

    setState(() {
      _startLocation = location;
    });
  }

  @override
  void dispose() {
    controller.dispose();
    blinkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    findMode ? controller.forward() : controller.stop();
    _animation = Tween(begin: 0.0, end: waveGap).animate(controller)
      ..addListener(() {
        setState(() {
          waveRadius = _animation.value;
        });
      });

    /*if (findMode) {
      controller.stop();
      _animation = Tween(begin: 0.0, end: waveGap).animate(controller)
        ..addListener(() {
          setState(() {
            waveRadius = _animation.value;
          });
        });
      controller.forward();
    } else {
      controller.stop();
      final CurvedAnimation curve =
          new CurvedAnimation(parent: controller, curve: Curves.easeIn);
      _blinkAnimation = new Tween(begin: 1.0, end: 0.0).animate(curve);
      controller.forward();
    }*/

    return Scaffold(
        appBar: PreferredSize(
            child: AppBar(
                backgroundColor: Colors.blueGrey,
                flexibleSpace: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CustomPaint(
                      size: Size(0.0, 0.0),
                      painter: CircleWavePainter(waveRadius),
                      child: Container(
                        alignment: Alignment.center,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              findMode = !findMode;
                            });
                          },
                          child: Container(
                            width: 150.0,
                            height: 150.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: NetworkImage(
                                  "https://pbs.twimg.com/profile_images/864282616597405701/M-FEJMZ0_400x400.jpg",
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
            preferredSize:
                Size.fromHeight(MediaQuery.of(context).size.height * 0.5)),
        body: findMode
            ? ListView.builder(
                itemBuilder: (BuildContext ctxt, int index) {
                  return InkWell(
                    child: makeCard,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MentorProfile()),
                      );
                    },
                  );
                },
                itemCount: 4,
              )
            : Center(
                child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    /*FadeTransition(
                      opacity: _blinkAnimation,
                      child: Icon(
                        Icons.touch_app,
                        size: 60.0,
                        color: Colors.blueGrey,
                      ),
                    ),*/
                    Icon(
                      Icons.touch_app,
                      size: 60.0,
                      color: Colors.blueGrey,
                    ),
                    Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          "Tap on ur profile picture to \nfind your NEARBY teams/mentors",
                          style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.redAccent),
                          textAlign: TextAlign.center,
                        ))
                  ],
                ),
              )));
  }
}

final makeCard = Card(
  elevation: 8.0,
  margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
  child: Container(
    decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
    child: makeListTile,
  ),
);

final makeListTile = ListTile(
    contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
    leading: Container(
      padding: EdgeInsets.only(right: 12.0),
      decoration: new BoxDecoration(
          border: new Border(
              right: new BorderSide(width: 1.0, color: Colors.white24))),
      child: Icon(Icons.autorenew, color: Colors.white),
    ),
    title: Text(
      "Introduction to Driving",
      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    ),
    // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

    subtitle: Row(
      children: <Widget>[
        Icon(Icons.linear_scale, color: Colors.yellowAccent),
        Text(" Intermediate", style: TextStyle(color: Colors.white))
      ],
    ),
    trailing:
        Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0));
