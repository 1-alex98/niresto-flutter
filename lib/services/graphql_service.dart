
import 'package:flutter/foundation.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:niresto_flutter/config/app_config.dart';


class GraphqlService {
  late GraphQLClient client;

  ValueNotifier<GraphQLClient>? valueNotifier;

  void connect(String? token){
    final _httpLink = HttpLink(
      GetIt.instance<AppConfig>().graphqlLink,
    );

    final _authLink = AuthLink(
      getToken: () async => 'Bearer $token',
    );

    Link _link = _authLink.concat(_httpLink);

    client = GraphQLClient(
      cache: GraphQLCache(),
      link: _link,
    );
    if(valueNotifier == null){
      valueNotifier= ValueNotifier(client);
    } else {
      valueNotifier?.value = client;
    }
  }

}