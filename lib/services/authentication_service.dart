
import 'package:niresto_flutter/services/graphql_service.dart';
import 'package:get_it/get_it.dart';
import 'package:graphql/client.dart';
import 'dart:developer';


class AuthenticationService {
  String? _loginToken;

  Future<void> login(String tokenOrURL){
    String token;
    try{
      var queryParameters = Uri.parse(tokenOrURL).queryParameters;
      token = queryParameters["t"]!;
    } catch (e) {
      token = tokenOrURL;
    }
    return Future(() async {
      var graphqlService = GetIt.instance<GraphqlService>();
      graphqlService.connect(token);
      await checkValidParticipant();
      _loginToken = token;
    });
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
    if (queryResult.hasException) {
      log("Errors logging in ${queryResult.exception.toString()}");
      throw Exception("Login failed");
    }
  }

}