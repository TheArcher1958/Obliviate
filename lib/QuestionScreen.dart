import 'package:flutter/material.dart';
import 'Model/QuestionModel.dart';

class QuestionScreen extends StatefulWidget {
  final List<Question> questionsList;
  QuestionScreen(this.questionsList, {Key key}): super(key: key);
  @override
  _QuestionScreenState createState() => _QuestionScreenState();
}

checkAnswer(index, text, answer) {
  if(index == answer) {

  } else {

  }
}

class _QuestionScreenState extends State<QuestionScreen> {
  var answer;

  @override
  void initState() {

    answer = 3;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Question 1'),
        elevation: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('What is the name of the company Vernon Dursley works at?', style: TextStyle(fontSize: 25),),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(onPressed: () {checkAnswer(0, 'text', answer);}, child: Text('Answer 1')),
              ElevatedButton(onPressed: () {checkAnswer(1, 'text', answer);}, child: Text('Answer 2')),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(onPressed: () {checkAnswer(2, 'text', answer);}, child: Text('Answer 3')),
              ElevatedButton(onPressed: () {checkAnswer(3, 'text', answer);}, child: Text('Answer 4')),
            ],
          ),
          SizedBox(height: 80,)
        ],
      ),
    );
  }
}
