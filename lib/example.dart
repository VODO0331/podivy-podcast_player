import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

void main() async {
  // We're using HiveStore for persistence,
  // so we need to initialize Hive.
  await initHiveForFlutter();
  final String apiKey = 'SESiaYMFq2VLVKRCf844EIXkC3yQBmlRXGDeQZup';
  final String apiSecret = '9adf5693-85a0-4883-94df-1490aab2704d';
  final HttpLink httpLink = HttpLink(
    'https://api.podchaser.com/graphql',
  );

  String addStar = """
  mutation {
    requestAccessToken(
        input: {
            grant_type: CLIENT_CREDENTIALS
            client_id: $apiKey
            client_secret: $apiSecret
        }
    ) {
        access_token
        token_type   
        expires_in    
    }
}
""";
  // final AuthLink authLink = AuthLink(
  //   getToken: () async => 'Bearer <YOUR_PERSONAL_ACCESS_TOKEN>',
  //   // OR
  //   // getToken: () => 'Bearer <YOUR_PERSONAL_ACCESS_TOKEN>',
  // );

  // final Link link = authLink.concat(httpLink);

  // ValueNotifier<GraphQLClient> client = ValueNotifier(
  //   GraphQLClient(
  //     link: link,
  //     // The default store is the InMemoryStore, which does NOT persist to disk
  //     cache: GraphQLCache(store: HiveStore()),
  //   ),
  // );
}
