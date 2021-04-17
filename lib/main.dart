import 'package:flutter/material.dart';
import 'dart:core';

// import 'package:iknoweverything/models/answers.dart';
import 'package:iknoweverything/pages/question_answer.dart';

void main() {
  runApp(IKnowEverything());
}

class IKnowEverything extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'I Know Everything',
      theme: ThemeData(primaryColor: Colors.blueGrey.shade700),
      home: QuestionAnswerPage(),
    );
  }
}
