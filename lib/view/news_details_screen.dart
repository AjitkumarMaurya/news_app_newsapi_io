import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:news_app_newsapi_io/model/headline_response.dart';

class NewsDetailsScreen extends StatefulWidget {
  static String tag = '/NewsDetailsScreen';

  final List<Articles> headline;
  final int posNew;

  const NewsDetailsScreen({required this.headline, required this.posNew});

  @override
  NewsDetailsScreenState createState() => NewsDetailsScreenState();
}

class NewsDetailsScreenState extends State<NewsDetailsScreen> {
  bool isFollowing = false;
  late int cuPos = widget.posNew;

  @override
  void initState() {
    super.initState();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            color: Colors.black,
            icon: const Icon(Icons.arrow_back_ios_sharp),
            onPressed: () {
              finish(context);
            }),
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
            (cuPos + 1).toString() +
                '/' +
                widget.headline.length.toString(),
            style: const TextStyle(
              fontSize: 16.0,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            )),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                widget.headline[cuPos].urlToImage != null
                    ? Container(
                        height: 240.0,
                        width: double.infinity,
                        child: CachedNetworkImage(
                          imageUrl: widget.headline[cuPos].urlToImage!,
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.circular(0)),
                          ),
                          placeholder: (context, url) => const Padding(
                            padding: EdgeInsets.fromLTRB(40, 35, 40, 35),
                            child: CircularProgressIndicator(),
                          ),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
                      )
                    : Container(
                        height: 240.0,
                        width: double.infinity,
                        child: CachedNetworkImage(
                          imageUrl:
                              "https://as1.ftcdn.net/v2/jpg/00/88/43/58/500_F_88435823_c3MiOAvV8gFwtQzTGlsLt6I6mFvQuQmN.jpg",
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.circular(0)),
                          ),
                          placeholder: (context, url) => const Padding(
                            padding: EdgeInsets.fromLTRB(40, 35, 40, 35),
                            child: CircularProgressIndicator(),
                          ),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
                      ),
                const SizedBox(
                  height: 8.0,
                ),
                Container(
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  padding: const EdgeInsets.all(0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.headline[cuPos].source!.name!,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14.0,
                                          color: Color.fromARGB(
                                              255, 137, 133, 133),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10.0,
                                      ),
                                      const Text(
                                        '4 min read',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14.0,
                                          color: Color.fromARGB(
                                              255, 137, 133, 133),
                                        ),
                                      ),
                                    ],
                                  )).expand(flex: 3),
                              widget.headline[cuPos].isBookmark
                                  ? IconButton(
                                      color: Colors.blue,
                                      icon: const Icon(Icons.bookmark_sharp),
                                      onPressed: () {
                                        setState(() {
                                          widget.headline[cuPos]
                                                  .isBookmark =
                                              !widget.headline[cuPos]
                                                  .isBookmark;
                                        });
                                        toasty(
                                            context, 'Removed from Bookmark');
                                      })
                                  : IconButton(
                                      icon: const Icon(
                                          Icons.bookmark_border_sharp),
                                      onPressed: () {
                                        setState(() {
                                          widget.headline[cuPos]
                                                  .isBookmark =
                                              !widget.headline[cuPos]
                                                  .isBookmark;
                                        });
                                        toasty(context, 'Added to Bookmark');
                                      }),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 8.0,
                        ),
                        Container(
                          padding: const EdgeInsets.all(0),
                          child: Text(
                            widget.headline[cuPos].title!,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 8.0,
                        ),
                        Container(
                          padding: const EdgeInsets.all(0),
                          child: Text(
                            widget.headline[cuPos].description!=null ? widget.headline[cuPos].description! : "No Description",
                            style: const TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 16.0,
                              color: Color.fromARGB(255, 73, 72, 72),
                            ),
                          ),
                        ),
                      ],
                    )),
              ],
            ).expand(flex: 999),
            const SizedBox(
              width: double.infinity,
              child: DecoratedBox(
                decoration: BoxDecoration(color: Colors.grey),
              ),
            ).expand(flex: 1),
            Container(
                width: double.infinity,
                height: 50.0,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            if (cuPos != 0) {
                              cuPos--;
                              print(cuPos);
                            }else{
                              cuPos = 0;
                            }
                          });

                        },
                        child:  Text(
                          'Previous',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14.0,
                            color: cuPos != 0 ? Colors.black : const Color.fromARGB(255, 137, 133, 133),
                          ),
                        ),
                      ).expand(flex: 1),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            if (cuPos < widget.headline.length) {
                              cuPos++;
                              print(cuPos);

                            }
                          });

                        },
                        child: Text(
                          'Next',
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14.0,
                            color: cuPos < widget.headline.length ?  Colors.black :const Color.fromARGB(255, 137, 133, 133),
                          ),
                        ),
                      ).expand(flex: 1),
                    ],
                  ),
                )).expand(flex: 70),
          ],
        ),
      ),
    );
  }
}
