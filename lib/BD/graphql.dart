import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
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

const String readRepositories = r'''
  query getTerminal {
    Terminal {
      nombre
      terminalID
    }
  }
''';

Future<List> obtenerTerminales()async{
  // const int nRepositories = 50;

  final QueryOptions options = QueryOptions(
      documentNode: gql(readRepositories),
      // variables: <String, dynamic>{
      //     'nRepositories': nRepositories,
      // },
  );

  final QueryResult result = await _client.query(options);

  if (result.hasException) {
      print(result.exception.toString());
      return [];
  }else{
    print(result.data);
    return result.data["Terminal"];
  }

  // final List<dynamic> repositories =
  //     result.data['viewer']['repositories']['nodes'] as List<dynamic>;

  // ...
}



const String addEmpresa = r'''

mutation addEmpresa($idTerminal: uuid, $imageURL: String, $nombreEmp: String, $numContacto: String) {
  insert_Empresa(objects: {idTerminal: $idTerminal, imageURL: $imageURL, nombreEmpresa: $nombreEmp, numeroContacto: $numContacto}) {
    returning {
      idEmpresa
      idTerminal
      imageURL
      nombreEmpresa
      numeroContacto
    }
  }
}


''';

Future<bool> insertarEmpresa({String idTerminal, String imageURL,String nombreEmp, String numContacto})async{
  final MutationOptions options = MutationOptions(
    documentNode: gql(addEmpresa),
    variables: <String, dynamic>{
      "idTerminal": idTerminal,
      "imageURL": imageURL,
      "nombreEmp": nombreEmp,
      "numContacto": numContacto,
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

const String readRepositoriesEmpresas = r'''
    query obtenerEmpresa {
    Empresa {
      idEmpresa
      nombreEmpresa
    }
  }

  ''';

  Future<List> obtenerEmpresa()async{
    // const int nRepositories = 50;

    final QueryOptions options = QueryOptions(
        documentNode: gql(readRepositoriesEmpresas),
        // variables: <String, dynamic>{
        //     'nRepositories': nRepositories,
        // },
    );

    final QueryResult result = await _client.query(options);

    if (result.hasException) {
        print(result.exception.toString());
        return [];
    }else{
      print(result.data);
      return result.data["Empresa"];
    }

    // final List<dynamic> repositories =
    //     result.data['viewer']['repositories']['nodes'] as List<dynamic>;

  // ...
}




const String addDestino = r'''

mutation insertDestino($idTerminal: uuid, $idEmpresa: uuid, $destino: String, $hora: String, $diasHabiles: json, $costoViaje: float8, $tiempoViaje: float8) {
  insert_Destino(objects: {idTerminal: $idTerminal, idEmpresa: $idEmpresa, destino: $destino, hora: $hora, diasHabiles: $diasHabiles, costoViaje: $costoViaje, tiempoViaje: $tiempoViaje}) {
    returning {
      idDestino
      costoViaje
      destino
      diasHabiles
    }
  }
}



''';

Future<bool> insertarDestino({String idTerminal,String idEmpresa, String destino,String hora, Map diasHabiles,double costoViaje,double tiempoViaje})async{
  final MutationOptions options = MutationOptions(
    documentNode: gql(addDestino),
    variables: <String, dynamic>{
      "idTerminal": idTerminal,
      "idEmpresa": idEmpresa,
      "destino": destino,
      "hora": hora,
      "diasHabiles": diasHabiles,
      "costoViaje": costoViaje,
      "tiempoViaje": tiempoViaje
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