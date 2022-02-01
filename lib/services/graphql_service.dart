
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
    final policies = Policies(
      fetch: FetchPolicy.noCache,
      error: ErrorPolicy.ignore,
      cacheReread: CacheRereadPolicy.ignoreAll
    );
    client = GraphQLClient(
      cache: GraphQLCache(),
      link: _link,
      defaultPolicies: DefaultPolicies(
        watchQuery: policies,
        watchMutation: policies,
        query: policies,
        mutate: policies,
        subscribe: policies
      )
    );
    if(valueNotifier == null){
      valueNotifier= ValueNotifier(client);
    } else {
      valueNotifier?.value = client;
    }
  }

}