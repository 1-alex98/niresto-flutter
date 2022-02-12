
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:niresto_flutter/services/graphql_service.dart';
import 'package:get_it/get_it.dart';
import 'package:graphql/client.dart';
import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';


class AuthenticationService {

  final SharedPreferences prefs;

  AuthenticationService(this.prefs);

  Future<void> login(String tokenOrURL){
    String token;
    try{
      var queryParameters = Uri.parse(tokenOrURL).queryParameters;
      token = queryParameters["token"]!;
    } catch (e) {
      token = tokenOrURL;
    }
    return Future(() async {
      var graphqlService = GetIt.instance<GraphqlService>();
      graphqlService.connect(token);
      await checkValidParticipantAndUpdateToken();
      await prefs.setString('token', token);
    });
  }

  String? getSavedToken(){
    return prefs.getString('token');
  }

  Future<void> logout() async{
    await prefs.remove('token');
  }

  Future<void> checkValidParticipantAndUpdateToken() async{
    const String readParticipant = r'''
        mutation update($token: String!){
            fcm_token_update(
                new_token: $token
            )
        }
      ''';
    String? token = await FirebaseMessaging.instance.getToken();

    final MutationOptions options = MutationOptions(
      document: gql(readParticipant),
      variables: {
        "token": token
      }
    );
    var queryResult = await GetIt.instance<GraphqlService>().client.mutate(options);
    if (queryResult.hasException || queryResult.data == null || !queryResult.data!["fcm_token_update"]) {
      log("Errors logging in ${queryResult.exception.toString()}");
      throw Exception("Login failed");
    }
  }

}