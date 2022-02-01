import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class QuestionDetails extends StatefulWidget {
  final Question question;
  final Callback onSendCallBack;

  const QuestionDetails({Key? key, required this.question, required this.onSendCallBack }) : super(key: key);

  @override
  _QuestionDetailsState createState() => _QuestionDetailsState();
}

class Question {
  final String questionText;
  final String questionTitle;

  Question(this.questionText, this.questionTitle);
}

class Callback {
  void Function()? onSend;
}

class _QuestionDetailsState extends State<QuestionDetails> {

  @override
  Widget build(BuildContext context) {
    widget.onSendCallBack.onSend = onSend;
    return Container(
      child: Column(
        children: [
          Align(alignment: Alignment.topLeft,child: Text(widget.question.questionTitle, style: Theme.of(context).textTheme.headline2)),
          const SizedBox(height: 20),
          Align(alignment: Alignment.topLeft,child:Text(widget.question.questionText)),
          const SizedBox(height: 20),
          const Divider(),
          const TextField(
            maxLines: null,
            keyboardType: TextInputType.multiline,
          )
        ],
      ),
    );
  }

  void onSend(){

  }
}