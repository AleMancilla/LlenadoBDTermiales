import 'package:graphql/client.dart';

final HttpLink _httpLink = HttpLink(
    uri: 'https://terminalesbolivia.herokuapp.com/v1/graphql',
    headers: {
      "content-type":"application/json",
      "x-hasura-admin-secret":"1234567890"
    }
);

// final AuthLink _authLink = AuthLink(
//     getToken: () async => 'Bearer $YOUR_PERSONAL_ACCESS_TOKEN',
// );

final Link _link = _httpLink;//_authLink.concat(_httpLink);

final GraphQLClient _client = GraphQLClient(
        cache: InMemoryCache(),
        link: _link,
    );

const String addStar = r'''

mutation addTerminal ($name:String,$ubicacion:String){
  insert_Terminal(objects: {nombre: $name, ubicacion: $ubicacion}) {
    affected_rows
    returning {
      nombre
      terminalID
      ubicacion
    }
  }
}

''';

Future<bool> insertarTerminal(String name, String ubicacion)async{
  final MutationOptions options = MutationOptions(
    documentNode: gql(addStar),
    variables: <String, dynamic>{
      'name': name,
      'ubicacion': ubicacion,
    },
  );
  final QueryResult result = await _client.mutate(options);
  
  if (result.hasException) {
      print(result.exception.toString());
      return false;
  }else{
    print(result);
    return true;
  }

  // final bool isStarred =  
  //     result.data['action']['starrable']['viewerHasStarred'] as bool;

  // if (isStarred) {
  //   print('Thanks for your star!');
  //   return;
  // }


}