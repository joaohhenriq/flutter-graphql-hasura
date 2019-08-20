import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final HttpLink httpLink = HttpLink(
      uri: "https://countries.trevorblades.com/",
    );

    final ValueNotifier<GraphQLClient> client = ValueNotifier<GraphQLClient>(
      GraphQLClient(
        link: httpLink,
        cache: OptimisticCache(dataIdFromObject: typenameDataIdFromObject),
      ),
    );

    return GraphQLProvider(
      child: GraphQlPage(),
      client: client,
    );
  }
}

class GraphQlPage extends StatefulWidget {
  @override
  _GraphQlPageState createState() => _GraphQlPageState();
}

class _GraphQlPageState extends State<GraphQlPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("GraphQL Client"),
        centerTitle: true,
      ),
      body: Query(
        options: QueryOptions(
          document:
          r"""
            query GetContinent($code : String!){
              continent(code:$code){
                name
                countries{
                  name
                }
              }
            }
          """,
          variables: <String, dynamic>{
            "code" : "AS"
          }
        ),
        builder: (QueryResult result, {
          BoolCallback refetch,
          FetchMore fetchMore,
        }){
          if(result.data == null){
            return Center(child: CircularProgressIndicator(),);
          }
          return ListView.builder(
            itemBuilder: (context, index){
              return ListTile(
                title: Text(result.data['continent']['countries'][index]['name']),
              );
            },
            itemCount: result.data['continent']['countries'].length,
          );
        }),
    );
  }
}
