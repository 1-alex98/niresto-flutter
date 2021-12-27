// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:niresto_flutter/screens/connection_screen.dart';
import 'package:get_it/get_it.dart';
import 'package:niresto_flutter/screens/introduction_screen.dart';
import 'package:niresto_flutter/services/authentication_service.dart';

GetIt locator = GetIt.instance;

void main() {
  initLocator();
  runApp(MyApp());
}

void initLocator() {
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
          '/intro': (context) => const IntroductionScreen(),
        }
    );
  }
}