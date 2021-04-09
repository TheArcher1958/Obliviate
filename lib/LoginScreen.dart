import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  MediaQueryData queryData;

  @override
  void initState() {
    //queryData = MediaQuery.of(context);

    FirebaseAuth.instance
        .authStateChanges()
        .listen((User user) {
      if (user == null) {
//        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });
  }


  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    // Create a new credential
    final GoogleAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<UserCredential> signInAnonymously() async {
    UserCredential userCredential = await FirebaseAuth.instance.signInAnonymously();
    return userCredential;
  }

  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [Color(0x141e30), Color(0x243b55)])
        ),
        child: Column(
          children: [
            ElevatedButton(onPressed: signInAnonymously, child: Text('Continue as Guest')),
            ElevatedButton(onPressed: signInWithGoogle, child: Text('Sign in with Google')),
            ElevatedButton(onPressed: () {
              Navigator.pushNamed(context, "/register");
            }, child: Text('Sign Up')),
          ],
        ),
      ),
    );
  }
}
