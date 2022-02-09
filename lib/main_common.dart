// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:niresto_flutter/screens/connection_screen.dart';
import 'package:get_it/get_it.dart';
import 'package:niresto_flutter/screens/introduction_screen.dart';
import 'package:niresto_flutter/screens/question_screen.dart';
import 'package:niresto_flutter/screens/welcome_screen.dart';
import 'package:niresto_flutter/services/authentication_service.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:niresto_flutter/services/graphql_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';

GetIt locator = GetIt.instance;

void commonMain() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await initLocator();
  GetIt.instance<GraphqlService>().connect(null);
  runApp(GraphQLProvider(
      client: GetIt.instance<GraphqlService>().valueNotifier,
      child: MyApp()
  ));
}

Future<void> initLocator() async{
  locator.registerSingleton(GraphqlService());
  locator.registerSingleton(AuthenticationService(await SharedPreferences.getInstance()));
}

const connectionPath = '/connection';
const welcomePath = '/welcome';
const introPath = '/intro';
const questionPath = '/question';


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Niresto',
        onGenerateRoute: (settings) {
          late Widget page;
          if (settings.name == connectionPath || settings.name == "/") {
            page = const ConnectionScreen();
          } else if (settings.name == welcomePath) {
            page = const WelcomeScreen();
          } else if (settings.name == introPath) {
            page = const IntroductionScreen();
          } else if (settings.name!.startsWith(questionPath)) {
            final subRoute = settings.name!.substring(questionPath.length);
            page = QuestionScreen(
              subPageRoute: subRoute,
            );
          } else {
            throw Exception('Unknown route: ${settings.name}');
          }

          return MaterialPageRoute<dynamic>(
            builder: (context) {
              return page;
            },
            settings: settings,
          );
        },
        theme: ThemeData(
          // Define the default brightness and colors.
          brightness: Brightness.light,
          primaryColor: Colors.lightBlue[800],
        ),
    );
  }
}