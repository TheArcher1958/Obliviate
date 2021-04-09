//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

    return Scaffold(
//      appBar: AppBar(
//        title: Text("Register"),
//        centerTitle: true,
//      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ClipPath(
              clipper: CustomHalfCircleClipper(),
              child: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [Colors.purple, Colors.blue])
                ),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.25,
                //color: Color(0xffFE7615),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
//                  Padding(
//                    padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
//                    child: Image.asset(
//                      'assets/TappleLogo.jpg',
//                      width: 90,
//                      height: 90,
//                    ),
//                  ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(5, 10, 0, 0),
                      child: Text(
                        "Register",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 35,
                          fontFamily: 'HP',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 26.0),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 300,
                    height: 65,
                    child: TextFormField(
                      style: TextStyle(
                        fontFamily: "Roberto",
                      ),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Username',
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
                  const SizedBox(height: 11.0),
                  Container(
                    width: 300,
                    height: 65,
                    child: TextFormField(
                      style: TextStyle(
                        fontFamily: "Roberto",
                      ),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Email',
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
                  const SizedBox(height: 11.0),
                  Container(
                    width: 300,
                    height: 65,
                    child: TextFormField(
                      style: TextStyle(
                        fontFamily: "Roberto",
                      ),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Password',
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
//                const SizedBox(height: 11.0),
//                Container(
//                  width: 300,
//                  height: 65,
//                  child: TextFormField(
//                    controller: _dateController,
//                    focusNode: _focus,
//                    decoration: InputDecoration(
//                      border: OutlineInputBorder(),
//                      labelText: 'Date',
//                    ),
//                    keyboardType: TextInputType.visiblePassword,
//                    validator: (String value) {
//                      if (value.trim().isEmpty) {
//                        return 'Password is required';
//                      } else {
//                        return null;
//                      }
//                    },
//                  ),
//                ),
//                Padding(
//                  padding: const EdgeInsets.symmetric(vertical: 13.0),
//                  child: Row(
//                    children: <Widget>[
//                      Checkbox(
//                        value: _agreedToTOS,
//                        onChanged: _setAgreedToTOS,
//                      ),
//                      GestureDetector(
//                        onTap: () => _setAgreedToTOS(!_agreedToTOS),
//                        child: const Text(
//                          'I agree to the Terms of Services and Privacy Policy',
//                        ),
//                      ),
//                    ],
//                  ),
//                ),
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xffFE7615),
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
                      height: 50,
                      width: 250,
                      child: ElevatedButton(
                        child: const Text('Register', style: TextStyle(fontSize: 25)),
                        //textColor: Colors.white,
                        onPressed: _submittable() ? _submit : null,
                        //color: Color(0xffFE7615),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
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