import 'package:graphql/client.dart';

void main() async {
  final GraphQLClient client = YourGraphQLClient(); // 你需要提供一个 GraphQLClient

  final QueryOptions options = QueryOptions(
    document: gql('''
      query GetBrandList(\$input: BrandListInput!) {
        brands(input: \$input) {
          totalCount
          edges {
            cursor
            node {
              id
              name
              description
              // 其他字段...
            }
          }
          // 其他字段...
        }
      }
    '''),
    variables: const{
      'input': {
        'first': 10,
        'page': 0,
        'searchTerm': 'your_search_term',
        'sort': 'NAME_ASC', // 请根据实际的排序枚举值填写
        'paginationType': 'PAGE', // 请根据实际的分页枚举值填写
        'cursor': 'your_cursor',
      },
    },
  );

  final QueryResult result = await client.query(options);

  // 处理查询结果
  if (result.hasException) {
    print('Error: ${result.exception}');
  } else {
    print('Total Count: ${result.data?['brands']['totalCount']}');
    for (var edge in result.data?['brands']['edges']) {
      var brand = edge['node'];
      print('Brand ID: ${brand['id']}, Name: ${brand['name']}');
      // 处理其他字段...
    }
  }
}

