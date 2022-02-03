import 'dart:io';

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:niresto_flutter/screens/widgets/loading.dart';

const myParticipantQuery = '''
              {
                my_participant{
                    id
                    name
                }
              } 
              ''';
const myStudyQuery = '''
              {
                my_study_query{
                  name
                }
              }
              ''';

void _navigateIntro(BuildContext context) {
  Navigator.popAndPushNamed(context, "/intro");
}

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:
        SafeArea(
        child:
          Padding(
            padding: const EdgeInsets.all(20),
            child: Container(
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: Text("Welcome", style: Theme.of(context).textTheme.headline2),
                    ),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.topCenter,
                      child: participantNameText(),
                    ),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Text("To the study", style: Theme.of(context).textTheme.headline5),
                    ),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.topCenter,
                      child: studyName(),
                    ),
                  ],
                )
            ),
          )
        ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _navigateIntro(context);
        },
        backgroundColor: Theme.of(context).floatingActionButtonTheme.backgroundColor,
        child: const Icon(Icons.arrow_forward_ios),
      ),
    );
  }

  Query participantNameText() {
    return Query(
        options: QueryOptions(
          document: gql(myParticipantQuery),
        ),
        builder: (result, {fetchMore, refetch}) {
          if (result.isLoading) {
            return const Loading();
          }
          if (result.hasException) {
            return const Text("Error loading name");
          }
          return Text(result.data!['my_participant']['name']??"No name given");
        });
  }
  Query studyName() {
    return Query(
        options: QueryOptions(
          document: gql(myStudyQuery),
        ),
        builder: (result, {fetchMore, refetch}) {
          if (result.isLoading) {
            return const Loading();
          }
          if (result.hasException) {
            return const Text("Error loading name");
          }
          return Text(result.data!['my_study_query']['name']??"No name given");
        });
  }
}
