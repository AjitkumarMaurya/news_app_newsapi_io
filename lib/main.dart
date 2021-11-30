import 'package:flutter/material.dart';
import 'package:news_app_newsapi_io/model/headline_response.dart';
import 'package:news_app_newsapi_io/rest/rest_api.dart';
import 'package:news_app_newsapi_io/view/headline_list.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FirstPage(),
    );
  }
}

class FirstPage extends StatefulWidget {
  @override
  FirstPageState createState() => FirstPageState();
}

class FirstPageState extends State<FirstPage> {
  ApiCall client = ApiCall();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            color: Colors.black,
            icon: const Icon(Icons.dehaze_rounded),
            onPressed: () {}),
        centerTitle: true,
        title: const Text("News",
            textAlign: TextAlign.center, style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
      ),
      body: FutureBuilder(
        future: client.getArticle(),
        builder:
            (BuildContext context, AsyncSnapshot<List<Articles>> snapshot) {
          if (snapshot.hasData) {
            List<Articles>? articles = snapshot.data;
            return ListView.builder(
                itemCount: articles?.length,
                itemBuilder: (context, index) =>
                    customListTile(articles![index], context));
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
