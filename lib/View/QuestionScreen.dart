import 'package:flutter/material.dart';
import 'package:hp_multiplayer_trivia/View/ResultsScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../globals.dart';
import 'HomeScreen.dart';
import 'ad_helper.dart';

import 'package:google_mobile_ads/google_mobile_ads.dart';



class QuestionScreen extends StatefulWidget {
  final String gameID;
  QuestionScreen(this.gameID, {Key key}): super(key: key);
  @override
  _QuestionScreenState createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> with TickerProviderStateMixin, WidgetsBindingObserver {
  var counter = 0;
  var iAnswered = false;
  var buttonsLocked = false;
  var ques = [];
  var myAnswers = [];
  var opponentAnswers = [];
  var _controller;
  var controller;
  var animation;
  var ignoreOpponentSnapshots = false;
  var waitingState = false;
  DocumentReference gameStream;
  var buttonColors = [Colors.black26,Colors.black26,Colors.black26,Colors.black26];

  InterstitialAd _interstitialAd;

  bool _isInterstitialAdReady = false;

  @override
  void initState() {
    print("Made it to questions");
    WidgetsBinding.instance.addObserver(this);

    _controller = AnimationController(vsync: this, duration: Duration(seconds: 1));
    animation = Tween(
        begin: 0.0,
        end: 1.0
    ).animate(_controller);

    print('gameID: ' + widget.gameID);
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 17),
    )..addListener(() {

      if (controller.value == 1.0 && buttonsLocked == false) {
        switchQuestion(null, -1);
        setState(() {
          waitingState = true;
        });



      } else if(controller.value == 1.0 && buttonsLocked == true) {
        print('button');
        setState(() {
          waitingState = true;
        });
        var beforeOpponentsAnswers = opponentAnswers;
        Future.delayed(Duration(seconds: 8), () {
          print('after 8');
          if(beforeOpponentsAnswers == opponentAnswers) {
            while(opponentAnswers.length < ques.length) {
              opponentAnswers.add(-1);
            }
            ignoreOpponentSnapshots = true;
            print('ensured');
            ensureOpponentAnswered();
          }
        });
//        Future.delayed(const Duration(seconds: 8), () => () {
//          print('after 8');
//          if(beforeOpponentsAnswers == opponentAnswers) {
//            while(opponentAnswers.length < ques.length) {
//              opponentAnswers.add(-1);
//            }
//            ignoreOpponentSnapshots = true;
//            print('ensured');
//            ensureOpponentAnswered();
//          }
//        });
      }
    });
    gameStream = FirebaseFirestore.instance.collection('games').doc(widget.gameID);
    gameStream.snapshots().listen((querySnapshot) {
      print("Inside Stream");

      if (querySnapshot.exists) {
        var playerIDs = querySnapshot.data()['playersIds'];

        var opponentsID = playerIDs[0] == globalUser.uid
            ? playerIDs[1]
            : playerIDs[0];

        // TODO: optimize this better in the future?
        if(ignoreOpponentSnapshots == false) {
          opponentAnswers = (querySnapshot.data()['answers'][opponentsID]);
        }

        ensureOpponentAnswered();
        if (ques.length == 0 || ques.isEmpty) {
          setState(() {
            ques = querySnapshot.data()['questions'];
          });
          if (!_isInterstitialAdReady) {
            _loadInterstitialAd();
          }
        }
      } else {
        // TODO: Game doesn't exist so show a modal and push away.
      }

    });
    super.initState();
  }

  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          this._interstitialAd = ad;

          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
//              _moveToHome();
              if(counter >= ques.length) {
                WidgetsBinding.instance.addPostFrameCallback((_) =>
                {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) =>
                          ResultsScreen(myAnswers, opponentAnswers, ques, widget
                              .gameID)))
                });
              }
            },
          );

          _isInterstitialAdReady = true;
        },
        onAdFailedToLoad: (err) {
          print('Failed to load an interstitial ad: ${err.message}');
          _isInterstitialAdReady = false;
        },
      ),
    );
  }


  void ensureOpponentAnswered() {
    print("Inside ensure");

    if(opponentAnswers != null) {
      print(opponentAnswers.length.toString() + " " + ques.length.toString());
      if ((opponentAnswers.length == counter + 1 || opponentAnswers.length == ques.length) &&
          myAnswers.length == counter + 1 && iAnswered == false) {
        iAnswered = true;
        Future.delayed(Duration(seconds: 1), () {
          _controller.value = 0.0;
          setState(() {
            waitingState = false;
            counter += 1;
            iAnswered = false;
            buttonsLocked = false;
            buttonColors =
            [Colors.black26, Colors.black26, Colors.black26, Colors.black26];
            controller.value = 0.0;
          });
        });
      }
    }
  }

  void switchQuestion(optionText, i) {
    setState(() {
      buttonsLocked = true;
    });
    if(optionText != null) {
      if (optionText == ques[counter]['answer']) {
        setState(() {
          buttonColors[i] = Colors.green;
        });
      } else {
        setState(() {
          buttonColors[i] = Colors.red;
        });
      }
    }
    myAnswers.add(i);
    print("Right before answer update");

    gameStream.update({'answers.' + globalUser.uid: myAnswers})
        .then((value) => ensureOpponentAnswered())
        .catchError((error) => print("Failed to update user: $error"));
  }

  IconData getOpponentIcon() {
    if(opponentAnswers.length == counter + 1 || opponentAnswers.length == ques.length) return Icons.check;
    else return Icons.clear;
  }

  Color getOpponentColor() {
    if(opponentAnswers.length == counter + 1 || opponentAnswers.length == ques.length) return Colors.green;
    else return Colors.red;
  }


  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    _interstitialAd?.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
      print('State change detected! 🔨');
      print(state);
      if(state == AppLifecycleState.paused && myAnswers.length < ques.length) {
        while(myAnswers.length < ques.length) {
          myAnswers.add(-1);
        }
        print(myAnswers);
        gameStream.update({'answers.' + globalUser.uid: myAnswers})
            .then((value) => ensureOpponentAnswered())
            .catchError((error) => print("Failed to update user: $error"));
        CollectionReference userDoc = FirebaseFirestore.instance.collection('matchmaking');
        userDoc
            .doc(globalUser.uid)
            .delete()
            .then((value) => {
              Navigator.pop(context),
          print('Canceled')
        }).catchError((error) => print('Unable to delete document.'));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      }
  }

  @override
  Widget build(BuildContext context) {
    if(waitingState == true) {
      return Container(
        width: MediaQuery
            .of(context)
            .size
            .width,
        height: MediaQuery
            .of(context)
            .size
            .height,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [Color(0xff141e30), Color(0xff243b55)])
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CircularProgressIndicator(
              color: Colors.amber,
            ),
          ],
        ),
      );
    }
    if(ques.length == 0 || ques.isEmpty) {
      return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xff141e30), Color(0xff243b55)]
          ),
        ),
      );
    } else {
      if(counter >= ques.length) {
        WidgetsBinding.instance.addPostFrameCallback((_) => {
          if (_isInterstitialAdReady) {
              _interstitialAd?.show()
          } else {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => ResultsScreen(myAnswers, opponentAnswers, ques, widget.gameID)))
          }
        });

        return Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [Color(0xff141e30), Color(0xff243b55)]
            ),
          ),
        );
      }
      _controller.forward();
      controller.forward();
      return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          body: SingleChildScrollView(
            child: Container(
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              height: MediaQuery
                  .of(context)
                  .size
                  .height,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [Color(0xff141e30), Color(0xff243b55)])
              ),
              child: Column(
                children:
                [
                  LinearProgressIndicator(
                    minHeight: convH(40,context),
                    color: Color(0xff6c59e6),
                    backgroundColor: Colors.black45,
                    value: controller.value,
                    semanticsLabel: 'Timer',
                  ),
                  SizedBox(height: convH(8,context),),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Opponent: John', style: TextStyle(color: Colors.white, fontSize: convW(16,context)),),
                      SizedBox(width: convW(5,context),),
                      Icon(getOpponentIcon(), color: getOpponentColor(),)
                    ],
                  ),
                  SizedBox(height: convH(8,context),),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    transitionBuilder: (Widget child, Animation<double> animation) {
                      return ScaleTransition(child: child, scale: animation);
                    },
                    child: Padding(
                      key: ValueKey<int>(counter),
                      padding: const EdgeInsets.all(14.0),
                      child: Container(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width,
                        decoration: BoxDecoration(
                            color: Colors.black45,
                            borderRadius: BorderRadius.all(Radius.circular(20))
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(ques[counter]['question'],
                            style: TextStyle(color: Colors.white, fontSize: convW(22,context),),),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: convH(50,context),),
                  Column(
                    children: new List.generate(
                      ques[counter]['options'].length, (i) =>
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 500),
                        transitionBuilder: (Widget child,
                            Animation<double> animation) {
                          return ScaleTransition(child: child, scale: animation);
                        },
                        child: Padding(key: ValueKey<int>(counter),
                          padding: const EdgeInsets.all(14.0),
                          child: SizedBox(
                            width: MediaQuery
                                .of(context)
                                .size
                                .width,
                            child: AnimatedContainer(
                              color: buttonColors[i ],
                              duration: Duration(milliseconds: 300),
                              child: ElevatedButton(style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<
                                      Color>(Colors.transparent)),
                                  onPressed: () {
                                    if (!buttonsLocked) {
                                      switchQuestion(
                                          ques[counter]['options'][i], i);
                                    } else {
                                      return null;
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        8, 14, 8, 14),
                                    child: Text(ques[counter]['options'][i],
                                      style: TextStyle(fontSize: convW(17,context)),),
                                  )
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }
}
