import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:news_app_newsapi_io/model/headline_response.dart';
import 'package:news_app_newsapi_io/rest/rest_api.dart';
import 'package:news_app_newsapi_io/view/news_details_screen.dart';
import 'package:timeago/timeago.dart' as timeago;

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FirstPage(),
    );
  }
}

class FirstPage extends StatefulWidget {
  const FirstPage({Key? key}) : super(key: key);

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

            final DateTime now = DateTime.now();

            final String formatted = formatDate(
                now, [yyyy, '-', mm, '-', dd, ' ', hh, ':', mm, ':', ss]);

            return ListView.separated(
              shrinkWrap: true,
              physics: const ScrollPhysics(),
              itemCount: articles!.length,
              padding: const EdgeInsets.all(16),
              itemBuilder: (context, index) {
                Articles mData = articles[index];

                String servDate =
                    mData.publishedAt!.replaceAll("T", " ").replaceAll("Z", "");
                String serFormatted = formatDate(DateTime.parse(servDate),
                    [yyyy, '-', mm, '-', dd, ' ', hh, ':', mm, ':', ss]);
                final diff = DateTime.parse(formatted)
                    .difference(DateTime.parse(serFormatted));
                final timeAgo = DateTime.parse(formatted).subtract(diff);

                return GestureDetector(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                NewsDetailsScreen(headline: mData,size: articles.length.toString(),pos: (index+1).toString()))),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        mData.urlToImage != null
                            ? Container(
                                height: 90.0,
                                width: 100.0,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: NetworkImage(mData.urlToImage!),
                                      fit: BoxFit.cover),
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                              )
                            : Container(
                                height: 90.0,
                                width: 100.0,
                                decoration: BoxDecoration(
                                  image: const DecorationImage(
                                      image: NetworkImage(
                                          'https://as1.ftcdn.net/v2/jpg/00/88/43/58/500_F_88435823_c3MiOAvV8gFwtQzTGlsLt6I6mFvQuQmN.jpg'),
                                      fit: BoxFit.cover),
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                              ),
                        const Padding(
                          padding: EdgeInsets.only(
                            left: 10.0,
                            right: 10.0,
                          ),
                        ),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(mData.title!,
                                  textAlign: TextAlign.start,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 18.0,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  softWrap: true,
                                  maxLines: 2),
                              const Padding(
                                padding: EdgeInsets.only(
                                  top: 4.0,
                                  bottom: 4.0,
                                ),
                              ),
                              Text(
                                  mData.source!.name! +
                                      ' ' +
                                      timeago.format(timeAgo),
                                  textAlign: TextAlign.start,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.normal,
                                  ),
                                  softWrap: true,
                                  maxLines: 1),
                            ],
                          ),
                        ),
                      ],
                    ));
              },
              separatorBuilder: (context, index) {
                return const Divider();
              },
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
