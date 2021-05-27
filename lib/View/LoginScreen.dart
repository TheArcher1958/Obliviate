import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../globals.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  bool _hidePasswordText = true;
  var _userController = TextEditingController();
  var _passController = TextEditingController();

  @override
  void initState() {


    FirebaseAuth.instance
        .authStateChanges()
        .listen((User user) {
      if (user == null) {
//        print('User is currently signed out!');
      } else {
        //print('User is signed in!');
        Navigator.pushReplacementNamed(context, "/");
      }
    });
  }


  void _toggleVisibility() {
    setState(() {
      _hidePasswordText = !_hidePasswordText;
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
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
//        backgroundColor: Color(0xff141e30),
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Container(
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
                ClipPath(
                  clipper: CustomHalfCircleClipper(),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.25,
                    color: Colors.amber,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'images/Logo.png',
                           scale: convH(5.5,context),
                          fit: BoxFit.none,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: convH(30,context),
                ),
                Container(
                  width: convW(300,context),
                  child: TextField(
                    controller: _userController,
                    cursorColor: Colors.amber,
                    decoration: InputDecoration(
                      labelStyle: TextStyle(
                        color: Colors.white,
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white70, width: 2.0),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.amber, width: 2.0),
                      ),
//                      border: OutlineInputBorder(borderSide: new BorderSide(color: Colors.teal)),
                      labelText: 'Username',
                    ),
                    style: TextStyle(
                      fontFamily: "Roberto",
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(
                  height: convH(30,context),
                ),
                Container(
                  width: convW(300,context),
                  child: TextField(
                    cursorColor: Colors.amber,
                    controller: _passController,
                    obscureText: _hidePasswordText,
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: "Roberto",
                    ),
                    decoration: InputDecoration(
                      labelStyle: TextStyle(
                        color: Colors.white,
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white70, width: 2.0),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.amber, width: 2.0),
                      ),
                      labelText: 'Password',
                      suffixIcon: IconButton(
                        onPressed: () => _toggleVisibility(),
                        icon: Icon(_hidePasswordText ? Icons.visibility : Icons.visibility_off, color: _hidePasswordText ? Colors.white : Colors.amber,),
                      ),
                    ),
                  ),
                ),

//          FlatButton(
//            onPressed: () {},
//            textColor: Colors.grey,
//            child: Text('Forgot Password',
//              style: TextStyle(
//                fontSize: 12,
//              ),
//            ),
//          ),
                SizedBox(
                  height: convH(20,context),
                ),
                Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.6),
                        offset: Offset(0.0, 2.0),
                        blurRadius: 3.0,
                        spreadRadius: 3.0,
                      )
                    ],
                  ),
                  child: SizedBox(
                    height: convH(50,context),
                    width: convW(250,context),
                    child: ElevatedButton(
                      child: Text('Login', style: TextStyle(fontSize: convW(25,context), color: Colors.white)),
                      style: ButtonStyle(elevation: MaterialStateProperty.all<double>(10.0),
                        backgroundColor: MaterialStateProperty.all<
                            Color>(Color(0xff6c59e6)),

                      ),
                      onPressed: () {
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: convH(25,context),
                ),
                SizedBox(
                  width: convW(250,context),
                  child: InkWell(
                    child: Image.asset('images/googlesignin.png'),
                    onTap: () async {
                      await signInWithGoogle();
                    },
                  ),
                ),
                SizedBox(
                  height: convH(25,context),
                ),
                Text(
                  "Or",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: "UniSansHeavy",
                  ),
                ),
                SizedBox(
                  height: convH(25,context),
                ),
                ElevatedButton(onPressed: signInAnonymously, child: Text('Continue as Guest')),
                SizedBox(
                  height: convH(25,context),
                ),
                Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.6),
                        offset: Offset(0.0, 2.0),
                        blurRadius: 3.0,
                        spreadRadius: 3.0,
                      )
                    ],
                  ),
                  child: SizedBox(
                    height: convH(45,context),
                    width: convW(200,context),
                    child: ElevatedButton(
                      child: Text('Register', style: TextStyle(fontSize: convW(25,context), color: Colors.white)),
//                    textColor: Colors.white,
                      style: ButtonStyle(elevation: MaterialStateProperty.all<double>(10.0),
                        backgroundColor: MaterialStateProperty.all<
                            Color>(Color(0xff6c59e6)),
                      ),
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, "/register");
                      },
                    ),
                  ),
                )
              ],
            ),






//          Column(
//            children: [
//              ElevatedButton(onPressed: signInAnonymously, child: Text('Continue as Guest')),
//              ElevatedButton(onPressed: signInWithGoogle, child: Text('Sign in with Google')),
//              ElevatedButton(onPressed: () {
//                Navigator.pushNamed(context, "/register");
//              }, child: Text('Sign Up')),
//            ],
//          ),
          ),
        ),
      ),
    );
  }
}


class CustomHalfCircleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height);
    path.quadraticBezierTo(size.width/4, size.height - 40, size.width/2, size.height-20);
    path.quadraticBezierTo(3/4*size.width, size.height, size.width, size.height-30);
    path.lineTo(size.width, 0);
    return path;
  }
  @override
  bool shouldReclip(CustomHalfCircleClipper oldClipper) {
    return true;
  }
}
