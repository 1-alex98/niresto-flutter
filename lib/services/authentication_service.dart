
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
      await checkValidParticipant();
      await prefs.setString('token', token);
    });
  }

  String? getSavedToken(){
    return prefs.getString('token');
  }

  Future<void> logout() async{
    await prefs.remove('token');
  }

  Future<void> checkValidParticipant() async{
    const String readParticipant = r'''
        {
          my_participant{
              id
          }
        }
      ''';
    final QueryOptions options = QueryOptions(
      document: gql(readParticipant)
    );
    var queryResult = await GetIt.instance<GraphqlService>().client.query(options);
    if (queryResult.hasException  || queryResult.data == null) {
      log("Errors logging in ${queryResult.exception.toString()}");
      throw Exception("Login failed");
    }
  }

}