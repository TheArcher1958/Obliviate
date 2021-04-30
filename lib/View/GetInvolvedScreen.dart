import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';


class GetInvolvedScreen extends StatefulWidget {
  @override
  _GetInvolvedScreenState createState() => _GetInvolvedScreenState();
}
//https://discord.gg/P28VVMQBja
void _launchURL(_url) async =>
    await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';


class _GetInvolvedScreenState extends State<GetInvolvedScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xff141e30), Color(0xff243b55)]
          )
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Obliviate at the current point in time is almost 100% built, managed, and maintained by me, the developer.\n'
                    'I hope for this app to be community driven and be the app you want it to be.',
                  style: TextStyle(fontSize: 16, color: Colors.white),),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'How can you get involved? There are several ways. Join our Discord if you would be interested in contributing.',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
              SizedBox(height: 8,),
              InkWell(
                child: Text(
                  'Join Our Discord',
                  style: TextStyle(fontSize: 17, color: Colors.amber, )
                ),
                onTap: () {
                  _launchURL('https://discord.gg/P28VVMQBja');
                },
              ),
              SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('- Questions\n'
                    'Have some quiz questions I could add? I am always looking for new questions to keep the app entertaining and challenging.',
                  style: TextStyle(fontSize: 16, color: Colors.white),),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('- Art\n'
                    'I am not an artist as you can see from the design. I am in search of artists to make a bunch of HP themed content for the app.',
                  style: TextStyle(fontSize: 16, color: Colors.white),),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('- Bug Testers / Feature Suggestions\n'
                    'Lets make Obliviate bug free! I would also love to hear any suggestions that you have.',
                  style: TextStyle(fontSize: 16, color: Colors.white),),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('- Discord Staff\n'
                    'Needed depending on user volume. Check discord to see if positions are currently open.',
                  style: TextStyle(fontSize: 16, color: Colors.white),),
              ),

              SizedBox(height: 30,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Contributing in any of these ways will get you added to the Credits page.',
                  style: TextStyle(fontSize: 16, color: Colors.white),),
              ),
//          Padding(
//            padding: const EdgeInsets.all(8.0),
//            child: Text('You can also support this project by becoming a Patreon. O'),
//          ),
            ],
          ),
        ),
      ),
    );
  }
}
