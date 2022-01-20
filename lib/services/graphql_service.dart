
import 'package:flutter/foundation.dart';
import 'package:graphql_flutter/graphql_flutter.dart';


class GraphqlService {
  late GraphQLClient client;

  late ValueNotifier<GraphQLClient> valueNotifier;

  void connect(String? token){
    final _httpLink = HttpLink(
      'https://10.0.2.2/graphql',
    );

    final _authLink = AuthLink(
      getToken: () async => 'Bearer $token',
    );

    Link _link = _authLink.concat(_httpLink);

    client = GraphQLClient(
      cache: GraphQLCache(),
      link: _link,
    );
    valueNotifier= ValueNotifier(client);
  }

}