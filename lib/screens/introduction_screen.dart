import 'dart:io';

import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

const myStudyQuery = '''
              {
                my_study_query{
                  name
                  short_description
                  intro_pages {
                    title
                    text
                  }
                }
              }
              ''';

class IntroductionScreen extends StatefulWidget {
  const IntroductionScreen({Key? key}) : super(key: key);

  @override
  _IntroductionScreenState createState() => _IntroductionScreenState();
}

class _IntroductionScreenState extends State<IntroductionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:
        SafeArea(
        child:
          Padding(
            padding: const EdgeInsets.all(20),
            child: Container(
            ),
          )
        ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your onPressed code here!
        },
        backgroundColor: Theme.of(context).floatingActionButtonTheme.backgroundColor,
        child: const Icon(Icons.arrow_forward_ios),
      ),
    );
  }

  Query studyIntroductionScreens() {
    return Query(
        options: QueryOptions(
          document: gql(myStudyQuery),
        ),
        builder: (result, {fetchMore, refetch}) {
          if (result.isLoading) {
            return const Text("Loading...");
          }
          if (result.hasException) {
            return const Text("Error loading name");
          }
          return Text(result.data!['my_study_query']['name']);
        });
  }
}
