import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

class AppConfig {
  AppConfig({
    required this.flavorName,
    required this.graphqlLink
  });

  final String flavorName;
  final String graphqlLink;

}