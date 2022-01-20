import 'package:niresto_flutter/config/app_config.dart';
import 'package:niresto_flutter/main_common.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;

void main() {
  locator.registerSingleton(AppConfig(
      flavorName: "prod",
      graphqlLink: "http://10.0.2.2/graphql"
  ));
  commonMain();
}