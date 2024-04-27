
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class ClientController{
  late final GraphQLClient _client;
  GraphQLClient get client => _client;
  static ClientController? _instance;

  ClientController._();

  factory ClientController() {
    _instance ??= ClientController._();
    return _instance!;
  }
  ValueNotifier<GraphQLClient> initialize(String token) {
    final HttpLink httpLink = HttpLink("https://api.podchaser.com/graphql");
    final AuthLink authLink = AuthLink(getToken: () => 'Bearer $token');
    final Link link = authLink.concat(httpLink);
    _client = GraphQLClient(
      link: link,
      cache: GraphQLCache(),
    );
    return ValueNotifier(_client);
  }
}
