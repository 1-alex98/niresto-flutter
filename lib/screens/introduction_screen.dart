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

class _IntroductionScreenState extends State<IntroductionScreen> with TickerProviderStateMixin{


  @override
  Widget build(BuildContext context) {
    final TabController tabController = TabController(vsync: this, length: 2);
    return Scaffold(
        body:
        SafeArea(
        child:
          Padding(
            padding: const EdgeInsets.all(20),
            child: studyIntroductionScreens(tabController),
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

  Query studyIntroductionScreens(TabController tabController) {
    return Query(
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
          final PageController controller = PageController();
          var data = result.data!['my_study_query'];
          final List intros = data['intro_pages'] ?? [];
          final Iterable<Container> introContainers = intros.map((intro) => studyIntro(context, intro['title'], intro['text'], tabController));
          return
                PageView(
                  controller: controller,
                  onPageChanged: (value) => {
                    tabController.index = value
                  },
                  children: [
                    studyDescription(context, data['name'], data['short_description'], tabController),
                    ...introContainers
                  ]
                );
  });
    }

  Container studyDescription(BuildContext context, String title, String description, TabController tabController) {
    return Container(
              child: Column(
                children: [
                  const Text("Sie nehmen an folgender Studie Teil:"),
                  const SizedBox(height: 30),
                  Text(title, style: Theme.of(context).textTheme.headline2),
                  const SizedBox(height: 20),
                  Text(description),
                  const Expanded(child: SizedBox()),
                  TabPageSelector(controller: tabController)
                ],
              ),
            );
  }

  Container studyIntro(BuildContext context, String title, String description, TabController tabController) {
    return Container(
              child: Column(
                children: [
                  Text(title, style: Theme.of(context).textTheme.headline2),
                  const SizedBox(height: 20),
                  Text(description),
                  const Expanded(child: SizedBox()),
                  TabPageSelector(controller: tabController)
                ],
              ),
            );
  }
}
