import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity/connectivity.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:news_app_newsapi_io/model/headline_response.dart';
import 'package:news_app_newsapi_io/rest/rest_api.dart';
import 'package:news_app_newsapi_io/utils/preference.dart';
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
  String _connectionStatus = 'Unknown';
  String oldRes = "";
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> initConnectivity() async {
    ConnectivityResult result = ConnectivityResult.none;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
    }
    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.wifi:
        setState(() => _connectionStatus = "200");
        break;
      case ConnectivityResult.mobile:
        setState(() => _connectionStatus = "200");
        break;
      case ConnectivityResult.none:
        setState(() => _connectionStatus = "201");
        break;
      default:
        setState(() => _connectionStatus = '201');
        break;
    }
  }

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
        future: client.getArticle(_connectionStatus),
        builder:
            (BuildContext context, AsyncSnapshot<List<Articles>> snapshot) {
          if (snapshot.hasData) {
            List<Articles> articles = snapshot.data!;
            getOfflineData();
            return _buildListView(articles);
          }
          getOfflineData();
          return _buildLoadingOrOffline();
        },
      ),
    );
  }

  getOfflineData() async {
    oldRes = await PreferenceManager().getPref("dataList");
  }

  _buildLoadingOrOffline() {
    if (oldRes.isNotEmpty && oldRes.trim().length > 0) {
      final body = json.decode(oldRes);
      final List data = body['articles'];
      List<Articles> articles = data.map((e) => Articles.fromJson(e)).toList();
      return _buildListView(articles);
    } else {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
  }

  _buildListView(List<Articles> articles) {
    final DateTime now = DateTime.now();
    final String formatted =
        formatDate(now, [yyyy, '-', mm, '-', dd, ' ', hh, ':', mm, ':', ss]);

    return ListView.separated(
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      itemCount: articles.length,
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        Articles mData = articles[index];

        String servDate =
            mData.publishedAt!.replaceAll("T", " ").replaceAll("Z", "");
        String serFormatted = formatDate(DateTime.parse(servDate),
            [yyyy, '-', mm, '-', dd, ' ', hh, ':', mm, ':', ss]);
        final diff =
            DateTime.parse(formatted).difference(DateTime.parse(serFormatted));
        final timeAgo = DateTime.parse(formatted).subtract(diff);

        return GestureDetector(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => NewsDetailsScreen(
                        headline: mData,
                        size: articles.length.toString(),
                        pos: (index + 1).toString()))),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                mData.urlToImage != null
                    ? SizedBox(
                        height: 90.0,
                        width: 100.0,
                        child: CachedNetworkImage(
                          imageUrl: mData.urlToImage!,
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.circular(0)
                            ),
                          ),
                          placeholder: (context, url) => const Padding(
                            padding: EdgeInsets.fromLTRB(40,35,40,35),
                            child: CircularProgressIndicator(),
                          ),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      )
                    : SizedBox(
                        height: 90.0,
                        width: 100.0,
                        child: CachedNetworkImage(
                          imageUrl:
                              "https://as1.ftcdn.net/v2/jpg/00/88/43/58/500_F_88435823_c3MiOAvV8gFwtQzTGlsLt6I6mFvQuQmN.jpg",
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                                borderRadius: BorderRadius.circular(0)
                            ),
                          ),
                          placeholder: (context, url) => const Padding(
                            padding: EdgeInsets.fromLTRB(40,35,40,35),
                            child: CircularProgressIndicator(),
                          ),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
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
                      Text(mData.source!.name! + ' ' + timeago.format(timeAgo),
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
}
