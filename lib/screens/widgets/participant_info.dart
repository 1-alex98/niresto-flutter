import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:niresto_flutter/screens/widgets/question_details.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'loading.dart';

const myParticipantQuery = '''
{
  my_participant{
    id
    name
  }
}
''';

class ParticipantInfo extends StatelessWidget {

  const ParticipantInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Query(
        options: QueryOptions(
          document: gql(myParticipantQuery),
        ),
        builder: (result, {fetchMore, refetch}) {
          if (result.isLoading) {
            return const Loading();
          }
          if (result.hasException) {
            return const Text("Error loading introduction");
          }
          final data = result.data!['my_participant'];
          final id = data['id'];
          return Padding(
              padding: const EdgeInsets.all(20),
            child: Align(
              alignment: Alignment.center,
              child: Text("Your id is: "+ id),
            )
          );
        },
    );
  }

}
