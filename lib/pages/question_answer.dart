import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:iknoweverything/models/answers.dart';

class QuestionAnswerPage extends StatefulWidget {
  @override
  _QuestionAnswerPageState createState() => _QuestionAnswerPageState();
}

class _QuestionAnswerPageState extends State<QuestionAnswerPage> {
  TextEditingController questionFieldController = TextEditingController();
  dynamic _currentAnswer;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  _handleGetAnswer() async {
    String questionText = questionFieldController.text.trim();
    if (questionText == '' ||
        questionText.length == 0 ||
        questionText[questionText.length - 1] != '?') {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Please ask a valid question')));
    } else {
      try {
        http.Response response =
            await http.get(Uri.parse("https://yesno.wtf/api"));
        if (response.statusCode == 200) {
          Map<String, dynamic> responseBody = jsonDecode(response.body);
          Answer answer = Answer.fromMap(responseBody);
          setState(() {
            _currentAnswer = answer;
          });
        }
      } catch (err) {
        print(err);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('I Know Everything'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.cyan.shade700,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.6,
            child: TextField(
                controller: questionFieldController,
                decoration: InputDecoration(
                  labelText: 'Ask a Question',
                  border: OutlineInputBorder(),
                )),
          ),
          SizedBox(
            height: 20,
          ),
          if (_currentAnswer != null)
            Stack(
              children: [
                Container(
                  height: 250,
                  width: 400,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(_currentAnswer.image))),
                ),
                Positioned.fill(
                  bottom: 20,
                  right: 20,
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Text(_currentAnswer.answer.toUpperCase(),
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                )
              ],
            ),
          SizedBox(
            height: 20,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  _handleGetAnswer();
                },
                child: Text('Get Answer'),
              ),
              SizedBox(
                width: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  questionFieldController.text = '';
                  setState(() {
                    _currentAnswer = null;
                  });
                },
                child: Text('Reset'),
              )
            ],
          )
        ],
      ),
    );
  }
}
