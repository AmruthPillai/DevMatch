import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hack/button.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uni_links/uni_links.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  StreamSubscription _subs;
  String githubClientID = 'Iv1.88f752f7e6b4c910';
  String githubClientSecret = '954b2ef4da1f0d87eb4714a01afbff97340e9bb1';

  @override
  void initState() {
    _initDeepLinkListener();
    super.initState();
  }

  @override
  void dispose() {
    _disposeDeepLinkListener();
    super.dispose();
  }

  void _initDeepLinkListener() async {
    _subs = getLinksStream().listen((String link) {
      print(link);
      _checkDeepLink(link);
    }, cancelOnError: true);
  }

  void _checkDeepLink(String link) {
    if (link != null) {
      String code = link.substring(link.indexOf(RegExp('code=')) + 5);
      loginWithGitHub(code).then((firebaseUser) {
        print("LOGGED IN AS: " + firebaseUser.displayName);
      }).catchError((e) {
        print("LOGIN ERROR: " + e.toString());
      });
    }
  }

  Future<FirebaseUser> loginWithGitHub(String code) async {
    //ACCESS TOKEN REQUEST
    final response = await http.post(
      "https://github.com/login/oauth/access_token",
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json"
      },
      body: jsonEncode(GitHubLoginRequest(
        clientId: githubClientID,
        clientSecret: githubClientSecret,
        code: code,
      )),
    );

    GitHubLoginResponse loginResponse =
        GitHubLoginResponse.fromJson(json.decode(response.body));

    //FIREBASE STUFF
    final AuthCredential credential = GithubAuthProvider.getCredential(
      token: loginResponse.accessToken,
    );

    final FirebaseUser user =
        await FirebaseAuth.instance.signInWithCredential(credential);

    return user;
  }

  void _disposeDeepLinkListener() {
    if (_subs != null) {
      _subs.cancel();
      _subs = null;
    }
  }

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
                onPressed: () async {
                  String url = "https://github.com/login/oauth/authorize" +
                      "?client_id=" +
                      githubClientID +
                      "&scope=public_repo%20read:user%20user:email";

                  if (await canLaunch(url)) {
                    await launch(
                      url,
                      forceSafariVC: false,
                      forceWebView: false,
                    );
                  } else {
                    print("CANNOT LAUNCH THIS URL!");
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GitHubLoginRequest {
  String clientId;
  String clientSecret;
  String code;

  GitHubLoginRequest({this.clientId, this.clientSecret, this.code});

  dynamic toJson() => {
        "client_id": clientId,
        "client_secret": clientSecret,
        "code": code,
      };
}

class GitHubLoginResponse {
  String accessToken;
  String tokenType;
  String scope;

  GitHubLoginResponse({this.accessToken, this.tokenType, this.scope});

  factory GitHubLoginResponse.fromJson(Map<String, dynamic> json) =>
      GitHubLoginResponse(
        accessToken: json["access_token"],
        tokenType: json["token_type"],
        scope: json["scope"],
      );
}
