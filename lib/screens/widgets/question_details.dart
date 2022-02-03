import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:niresto_flutter/services/graphql_service.dart';

const sendAnswer = r"""
mutation answer($questionId: ID!, $text: String!){
    create_answer(
        input:{
            answer_text: $text,
            question_id: $questionId
        }
    )
    {
        id
    }
}
""";

class QuestionDetails extends StatefulWidget {
  final Question question;
  final Callback onSendCallBack;

  const QuestionDetails(
      {Key? key, required this.question, required this.onSendCallBack})
      : super(key: key);

  @override
  _QuestionDetailsState createState() => _QuestionDetailsState();
}

class Question {
  final String questionText;
  final String questionTitle;
  final String id;

  Question(this.questionText, this.questionTitle, this.id);
}

class Callback {
  void Function()? onSend;
}

class _QuestionDetailsState extends State<QuestionDetails>{
  final answerController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    widget.onSendCallBack.onSend = onSend;
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Align(
              alignment: Alignment.topLeft,
              child: Text(widget.question.questionTitle,
                  style: Theme.of(context).textTheme.headline2)),
          const SizedBox(height: 20),
          Align(
              alignment: Alignment.topLeft,
              child: Text(widget.question.questionText)),
          const SizedBox(height: 20),
          const Divider(),
          TextField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Answer to question',
            ),
            controller: answerController,
            maxLines: null,
            keyboardType: TextInputType.multiline,
          )
        ],
      )
    );
  }

  void onSend() async {
    final MutationOptions options = MutationOptions(
      document: gql(sendAnswer),
      variables: {
        "text": answerController.text,
        "questionId": widget.question.id
      }
    );
    var queryResult =
        await GetIt.instance<GraphqlService>().client.mutate(options);
    if (queryResult.hasException) {
      log("Errors sending answer ${queryResult.exception.toString()}");
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Sending answer failed"),
      ));
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Saved answer"),
    ));
    Navigator.of(context).pop();
  }
}
