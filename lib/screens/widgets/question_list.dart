import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:niresto_flutter/screens/widgets/question_details.dart';

const myStudyQuery ="""
{
  questions_new{
    id
    question_text
    question_title
    study_id
    created_at
    updated_at
  }
}
""";

class QuestionList extends StatefulWidget {
  final void Function(Question question) onQuestionDetails;

  const QuestionList({Key? key, required this.onQuestionDetails}) : super(key: key);

  @override
  _QuestionListState createState() => _QuestionListState();
}

class _QuestionListState extends State<QuestionList> {


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Query(
        options: QueryOptions(
          document: gql(myStudyQuery),
        ),
        builder: (result, {fetchMore, refetch}) {

          if (result.isLoading) {
            return const Text("Loading...");
          }
          if (result.hasException) {
            return const Text("Error loading introduction");
          }
          var data = result.data!['questions_new'];
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
                final question = data[index];

                return _questionItem(question, context);
              }
            );
      })
    );
  }

  Widget _questionItem(question, context) {
    var title = question['question_title'];
    return Card(
      child: InkWell(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            title,
            style: const TextStyle(fontSize: 22.0),
          ),
        ),
        onTap: () => openQuestion(question),
      )
    );
  }

  void openQuestion(question){
    var questionObject = Question(question['question_text'], question['question_title']);
    widget.onQuestionDetails(questionObject);
  }

}