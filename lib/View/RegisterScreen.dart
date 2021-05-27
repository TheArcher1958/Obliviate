//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../globals.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  void initState() {
    super.initState();
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  FocusNode _focus = new FocusNode();
  bool _agreedToTOS = true;
  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
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
              children: <Widget>[
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
                          scale: 5.5,
                          fit: BoxFit.none,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: convH(30,context)),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: convW(300,context),
                        height: convH(65,context),
                        child: TextFormField(
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
                          validator: (String value) {
                            if (value.trim().isEmpty) {
                              return 'Username is required';
                            } else {
                              return null;
                            }
                          },

                        ),
                      ),
                      SizedBox(height: convH(30,context)),
                      Container(
                        width: convW(300,context),
                        height: convH(65,context),
                        child: TextFormField(
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
                            labelText: 'Email',
                          ),
                          style: TextStyle(
                            fontFamily: "Roberto",
                            color: Colors.white,
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (String value) {
                            if (value.trim().isEmpty) {
                              return 'Email is required';
                            } else if(!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)) {
                              return "Invalid Email Format!";
                            } else {
                              return null;
                            }
                          },
                        ),
                      ),
                      SizedBox(height: convH(30,context)),
                      Container(
                        width: convW(300,context),
                        height: convW(65,context),
                        child: TextFormField(
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
                            labelText: 'Password',
                          ),
                          style: TextStyle(
                            fontFamily: "Roberto",
                            color: Colors.white,
                          ),
                          keyboardType: TextInputType.visiblePassword,
                          validator: (String value) {
                            if (value.trim().isEmpty) {
                              return 'Password is required';
                            } else if (value.length < 6) {
                                return 'Password is too short';
                            } else {
                              return null;
                            }
                          },
                        ),
                      ),
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
                          height: convH(45,context),
                          width: convW(200,context),
                          child: ElevatedButton(
                            child: Text('Register', style: TextStyle(fontSize: convW(25,context), color: Colors.white)),
                            style: ButtonStyle(elevation: MaterialStateProperty.all<double>(10.0),
                              backgroundColor: MaterialStateProperty.all<
                                  Color>(Color(0xff6c59e6)),
                            ),
                            onPressed: () {
//                            Navigator.pushReplacementNamed(context, "/register");
                            },
                          ),
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
                              Navigator.pushReplacementNamed(context, "/login");
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  bool _submittable() {
    return _agreedToTOS;
  }

  void _submit() {
    if(_formKey.currentState.validate()) {
      Navigator.pop(context);
    }
  }


}

class CustomHalfCircleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height);
    path.quadraticBezierTo(
        size.width / 4, size.height - 40, size.width / 2, size.height - 20);
    path.quadraticBezierTo(
        3 / 4 * size.width, size.height, size.width, size.height - 30);
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomHalfCircleClipper oldClipper) {
    return true;
  }
}