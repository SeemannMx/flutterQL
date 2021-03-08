import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_grapgql/graphql_provide.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'graphql_api.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  String get host {
    if (Platform.isAndroid) {
      return '10.0.2.2';
    } else {
      return 'localhost';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GraphqlProvider(
      uri: 'http://$host:9002/graphql',
      child: MaterialApp(
        home: Scaffold(
          body: Query(
            options: QueryOptions(
              documentNode: CompaniesDataQuery().document,
            ),
            builder: (
                QueryResult result, {
                  Future<QueryResult> Function() refetch,
                  FetchMore fetchMore,
                }) {
              if (result.hasException) {
                return Text(result.exception.toString());
              }

              if (result.loading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              final allCompanies = CompaniesData.fromJson(result.data).allCompanies;

              return ListView.builder(
                itemBuilder: (_, index) {
                  return ListTile(
                    leading: Icon(Icons.card_travel),
                    title: Text(allCompanies[index].name),
                    subtitle: Text(allCompanies[index].industry),
                  );
                },
                itemCount: allCompanies.length,
              );
            },
          ),
        )
      ),
    );
  }
}
