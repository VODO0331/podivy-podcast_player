
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../access_token.dart';


class ClientGlobalController extends GetxController {
  static ClientGlobalController? _instance;

  late final GraphQLClient  client;

  ClientGlobalController._() {
    initialize();
  }

  factory ClientGlobalController() {
    _instance ??= ClientGlobalController._();
    return _instance!;
  }

  void initialize() {
    final HttpLink httpLink = HttpLink("https://api.podchaser.com/graphql");
    final AuthLink authLink = AuthLink(getToken: () => 'Bearer $myDevelopToken');
    final Link link = authLink.concat(httpLink);
    
    client = GraphQLClient(
        link: link,
        cache: GraphQLCache(),
      );
    
  }
}
