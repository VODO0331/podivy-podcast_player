import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class ClientGlobalController extends GetxController {
  late final GraphQLClient _client;
  GraphQLClient get client => _client;
  // ClientGlobalController();
  static ClientGlobalController? _instance;

  ClientGlobalController._();

  factory ClientGlobalController() {
    _instance ??= ClientGlobalController._();
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
