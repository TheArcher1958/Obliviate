import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hp_multiplayer_trivia/globals.dart';
import 'package:flutter/services.dart';
import 'HomeScreen.dart';
import 'LoginScreen.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:package_info/package_info.dart';
import 'package:version/version.dart';



class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {

  var motd;
  var unstableVersion;
  var remoteConfig;



  Future<void> displayNoInternetLoading() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black26,
          title: const Text('Connection Failure', style: TextStyle(color: Colors.white),),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Unable to establish a connection.', style: TextStyle(color: Colors.white)),
                Text('Please make sure you are connected to the internet.', style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Retry', style: TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoadingScreen()),
                );
              },
            ),
            TextButton(
              child: const Text('Cancel', style: TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black26,
          title: const Text('Available Update', style: TextStyle(color: Colors.white),),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('This version of the app is unstable.', style: TextStyle(color: Colors.white)),
                Text('Please update the app to the latest version to continue.', style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel', style: TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Update', style: TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }



  getConfig() async {
    await remoteConfig.fetchAndActivate();
    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 10),
      minimumFetchInterval: const Duration(hours: 1),
    ));
    await remoteConfig.setDefaults(<String, dynamic>{
      'motd': 'Obliviate - Beta',
      'hello': '0.0.0',
    });
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([]);


    remoteConfig = RemoteConfig.instance;
    getConfig();

    motd = remoteConfig.getString('motd');
    unstableVersion = remoteConfig.getString('must_update_version');
    print(unstableVersion);
    if(motd != null && unstableVersion != null && motd != "" && unstableVersion != "") {
      PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
        String version = packageInfo.version;
        Version currentVersion = Version.parse(version);
        Version unstableVersion2 = Version.parse(unstableVersion);


        if (currentVersion <= unstableVersion2) {
          _showMyDialog();
        } else {
          Future.delayed(Duration(seconds: 1), () {
            FirebaseAuth.instance
                .authStateChanges()
                .listen((User user) {
              if (user == null) {
                //          print('User is currently signed out!');
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              } else {
                //          print('User is signed in!');
                globalUser = user;
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              }
            });
          });
        }
      });
    } else {
      print('No internet?');
      Future.delayed(Duration.zero, displayNoInternetLoading);
//      displayNoInternetLoading();
//      _showMyDialog();
    }

  }

  @override
  Widget build(BuildContext context) {
//    print(convW(25, context));
//    print(MediaQuery.of(context).size.width);
//    print(MediaQuery.of(context).size.height);
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [Color(0xff141e30), Color(0xff243b55)])
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Container(
//            decoration: BoxDecoration(
//              color: Colors.black26,
//              borderRadius: BorderRadius.all(Radius.circular(4.0))
//            ),
            child: Column(

              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                motd != null ?
                  Text(motd, textAlign: TextAlign.center, style: TextStyle(fontSize: convW(24,context), color: Colors.white,fontFamily: "Lumos"),) :
                  Text('Obliviate - Beta',style: TextStyle(fontSize: convW(24,context),color: Colors.white,fontFamily: "Lumos"),),
                SizedBox(height: 100,)
              ],
            ),
          ),
        )
      ),
    );
  }
}
