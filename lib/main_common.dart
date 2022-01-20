// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:niresto_flutter/config/app_config.dart';
import 'package:niresto_flutter/screens/connection_screen.dart';
import 'package:get_it/get_it.dart';
import 'package:niresto_flutter/screens/introduction_screen.dart';
import 'package:niresto_flutter/screens/welcome_screen.dart';
import 'package:niresto_flutter/services/authentication_service.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:niresto_flutter/services/graphql_service.dart';


GetIt locator = GetIt.instance;

void commonMain() async {
  initLocator();
  GetIt.instance<GraphqlService>().connect(null);
  runApp(GraphQLProvider(
      client: GetIt.instance<GraphqlService>().valueNotifier,
      child: MyApp()
  ));
}

void initLocator() {
  locator.registerSingleton(GraphqlService());
  locator.registerSingleton(AuthenticationService());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Niresto',
        initialRoute: '/',
        routes: {
          // When navigating to the "/" route, build the FirstScreen widget.
          '/': (context) => const ConnectionScreen(),
          // When navigating to the "/second" route, build the SecondScreen widget.
          '/welcome': (context) => const WelcomeScreen(),
          '/intro': (context) => const IntroductionScreen(),
        },
      theme: ThemeData(
        // Define the default brightness and colors.
        brightness: Brightness.light,
        primaryColor: Colors.lightBlue[800],
      ),
    );
  }
}