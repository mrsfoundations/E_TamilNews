import 'dart:async';
import 'dart:convert';
import 'dart:io' show SocketException;
import 'package:e_tamilnews/pages/Terms_Conditions.dart';
import 'package:e_tamilnews/pages/search.dart';
import 'package:e_tamilnews/pages/settings.dart';
import 'package:e_tamilnews/pages/single_article.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_carousel_slider/flutter_custom_carousel_slider.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../common/constants.dart';
import '../models/Article.dart';
import '../widgets/articleBox.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/articleBoxFeatured.dart';
import 'PrivacyPolicy.dart';
import 'notification_page.dart';

class Articles extends StatefulWidget {
  @override
  _ArticlesState createState() => _ArticlesState();
}

class _ArticlesState extends State<Articles> {
  List<dynamic> featuredArticles = [];
  Rx<List<dynamic>> latestArticles = Rx([]);

  Rxn<Future<List<dynamic>>?> _futureLastestArticles = Rxn();
  Future<List<dynamic>>? _futureFeaturedArticles;
  ScrollController? _controller;
  int page = 1;
  bool _infiniteStop = false;

  @override
  void initState() {
    super.initState();
    OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
    OneSignal.shared.setAppId("644c12e5-c265-455c-bc47-8279a305d646");

    OneSignal.shared.setNotificationOpenedHandler((openedResult) {
      var data = openedResult.notification.additionalData!;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NotificationScreen(data),
        ),
      );
    });
    // OnRefIndicator(page);
    _futureLastestArticles.value = fetchLatestArticles(1);
    _futureFeaturedArticles = fetchFeaturedArticles(1);
    _controller =
        ScrollController(initialScrollOffset: 0.0, keepScrollOffset: true);
    _controller!.addListener(_scrollListener);
    _infiniteStop = false;
  }

  bool isLoaded = false;
  InterstitialAd? interstitialAd;
  var clickcount = 0;

  adsInserter(value) {
    if (value.length > 1) {
      value.insert(
        value.length - 1,
        BannerAd(
          adUnitId: BannerAd_ID,
          size: AdSize.banner,
          request: AdRequest(),
          listener: BannerAdListener(),
        )..load(),
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller!.dispose();
  }

  Future<List<dynamic>> fetchLatestArticles(int page) async {
    try {
      var response = await http
          .get(Uri.parse('$WORDPRESS_URL/wp-json/wp/v2/posts/?_embed'));
      print('$WORDPRESS_URL/wp-json/wp/v2/posts/?_embed');
      if (this.mounted) {
        if (response.statusCode == 200) {
          latestArticles.value = (json
              .decode(response.body)
              .map((m) => Article.fromJson(m))
              .toList());

          if (latestArticles.value.length % 10 != 0) {
            _infiniteStop = true;
          }
          // itemList.value = latestArticles.value
          //     .map((item) => CarouselItem(
          //   image: NetworkImage(
          //     item.image,
          //   ),
          //   onImageTap: (i) {
          //     final heroId = item.id.toString();
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) => SingleArticle(item, heroId),
          //       ),
          //     );
          //     print(heroId);
          //   },
          // ))
          //     .toList();

          // print(itemList.length);
          setState(() {});
          return latestArticles.value;
        }
        setState(() {
          _infiniteStop = true;
        });
      }
    } on SocketException {
      throw 'No Internet connection';
    }
    return latestArticles.value;
  }

  // OnRefIndicator(int page) async {
  //   try {
  //     var response = await http
  //         .get(Uri.parse('$WORDPRESS_URL/wp-json/wp/v2/posts/?_embed'));
  //     if (this.mounted) {
  //       if (response.statusCode == 200) {
  //         latestArticles.value = (json
  //             .decode(response.body)
  //             .map((m) => Article.fromJson(m))
  //             .toList());
  //         print("skjbdskjn");
  //         print(latestArticles.value.length);
  //
  //         // if (latestArticles.length % 10 != 0) {
  //         //   _infiniteStop = true;
  //         // }
  //         itemList.value = latestArticles.value.map((item) {
  //           return CarouselItem(
  //             image: NetworkImage(
  //               item.image,
  //             ),
  //             onImageTap: (i) {
  //               final heroId = item.id.toString();
  //               Navigator.push(
  //                 context,
  //                 MaterialPageRoute(
  //                   builder: (context) => SingleArticle(item, heroId),
  //                 ),
  //               );
  //               print(item.link);
  //             },
  //           );
  //         }).toList();
  //
  //         // print(itemList.length);
  //         setState(() {});
  //       }
  //     }
  //   } on SocketException {
  //     throw 'No Internet connection';
  //   }
  // }

  Future<List<dynamic>> fetchFeaturedArticles(int page) async {
    try {
      var response = await http
          .get(Uri.parse("$WORDPRESS_URL/wp-json/wp/v2/posts/?categories[]=$FEATURED_ID&_embed"));

      if (this.mounted) {
        if (response.statusCode == 200) {
          setState(() {
            featuredArticles.addAll(json
                .decode(response.body)
                .map((m) => Article.fromJson(m))
                .toList());
          });

          return featuredArticles;
        } else {
          setState(() {
            _infiniteStop = true;
          });
        }
      }
    } on SocketException {
      throw 'No Internet connection';
    }
    return featuredArticles;
  }

  _scrollListener() {
    var isEnd = _controller!.offset >= _controller!.position.maxScrollExtent &&
        !_controller!.position.outOfRange;
    if (isEnd) {
      setState(() {
        page += 1;
        _futureLastestArticles.value = fetchLatestArticles(page);
      });
    }
  }

  Rx<List<CarouselItem>> itemList = Rx([]);

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    InterstitialAd.load(
      adUnitId: InterstitialAd_ID,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          setState(() {
            isLoaded = true;
            this.interstitialAd = ad;
          });
          print("Ad");
        },
        onAdFailedToLoad: (error) {
          print("Interstitial Ad");
        },
      ),
    );
  }

  void showInterstitial() async {
    interstitialAd?.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) => print('Ad Showed'),
      onAdDismissedFullScreenContent: (InterstitialAd ad) => ad.dispose(),
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        Navigator.of(context).pop();
        ad.dispose();
      },
      onAdImpression: (InterstitialAd ad) => print('Impression'),
    );
    interstitialAd?.show();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          children: [
            Image.asset(
              'assets/etamil (1).png',
              fit: BoxFit.contain,
              height: 30,
            ),
          ],
        ),
        backgroundColor: Colors.red[400],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: Colors.red[400]),
              currentAccountPictureSize: Size.square(180),
              currentAccountPicture: Padding(
                padding: const EdgeInsets.fromLTRB(95, 0, 0, 110),
                child: CircleAvatar(
                  backgroundImage: AssetImage("assets/EtamilLogo.jpeg"),
                ),
              ),
              accountName: Padding(
                padding: const EdgeInsets.fromLTRB(80, 0, 0, 0),
                child: Text(
                  "ETamilNews",
                  style: TextStyle(fontSize: 24),
                ),
              ),
              accountEmail: Padding(
                padding: const EdgeInsets.fromLTRB(83, 0, 0, 0),
                child: Row(
                  children: [
                    GestureDetector(
                      child: Image.asset(
                        'assets/facebook.png',
                        fit: BoxFit.contain,
                        height: 30,
                      ),
                      onTap: () {
                        launchFB(
                            Url: "https://www.facebook.com/etamilnewslive");
                      },
                    ),
                    SizedBox(width: 2),
                    GestureDetector(
                      child: Image.asset(
                        'assets/twitter (1).png',
                        fit: BoxFit.contain,
                        height: 35,
                      ),
                      onTap: () {
                        launchTwitter(
                            Url: "https://twitter.com/etamilnewslive");
                      },
                    ),
                    SizedBox(width: 2),
                    GestureDetector(
                      child: Image.asset(
                        'assets/youtube.png',
                        fit: BoxFit.contain,
                        height: 30,
                      ),
                      onTap: _launchURL,
                    ),
                  ],
                ),
              ),
            ), //circleAvatar

            // ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text("Home"),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Articles()));
              },
            ),
            ListTile(
              leading: Icon(Icons.search),
              title: Text("Categories"),
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Search()));
              },
            ),
            ListTile(
              leading: Icon(Icons.menu),
              title: Text("Profile"),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Settings()));
              },
            ),
            ListTile(
              leading: Image.asset(
                'assets/Whatsapp_icon.png',
                height: 25,
              ),
              title: Text("What's App"),
              onTap: () {
                launchWhatsapp(number: "+919790055058", message: "Hi");
              },
            ),
            ListTile(
              leading: Image.asset(
                'assets/Youtubeicon.png',
                width: 25,
              ),
              title: Text("Youtube"),
              onTap: _launchURL,
            ),
            ListTile(
              leading: Image.asset(
                'assets/privacy-policy.png',
                width: 25,
              ),
              title: Text("Privacy Policy"),
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => PrivacyPolicy()));
              },
            ),
            ListTile(
              leading: Image.asset(
                'assets/terms-and-conditions.png',
                width: 25,
              ),
              title: Text("Terms & Conditions"),
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Terms_Conditions()));
              },
            ),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(color: Colors.white70),
        child: Column(
          children: <Widget>[
            featuredPost(_futureFeaturedArticles as Future<List<dynamic>>),
            SizedBox(height: 35),
            Obx(
              () => FutureBuilder<List<dynamic>>(
                future: _futureLastestArticles.value,
                builder: (context, articleSnapshot) {
                  if (articleSnapshot.hasData) {
                    print(articleSnapshot.data);
                    if (articleSnapshot.data!.isEmpty) return Container();
                    return Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          // Container(
                          //     child: CustomCarouselSlider(
                          //       height: 180,
                          //       items: itemList.value,
                          //       showSubBackground: false,
                          //       width: MediaQuery.of(context).size.width * 9,
                          //       autoplay: true,
                          //     )),
                          // const SizedBox(
                          //   height: 35,
                          // ),
                          Expanded(
                            child: RefreshIndicator(
                              onRefresh: () async {
                                // await OnRefIndicator(page);
                                _futureLastestArticles.value =
                                    fetchLatestArticles(1);
                              },
                              child: Builder(builder: (context) {
                                 adsInserter(articleSnapshot.data);
                                return ListView(
                                    children: articleSnapshot.data!.map((item) {
                                  if (item is BannerAd) {
                                    return Container(
                                      height: 50,
                                      child: AdWidget(
                                        ad: item,
                                      ),
                                    );
                                  }
                                  final heroId = item.id.toString();
                                  return InkWell(
                                      onTap: () {
                                        setState(() {
                                          clickcount = clickcount + 1;
                                          if (clickcount > 2) {
                                            showInterstitial();
                                            clickcount = 0;
                                          }
                                        });
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                SingleArticle(item, heroId),
                                          ),
                                        );
                                      },
                                      child: articleBox(context, item, heroId));
                                }).toList());
                              }),
                            ),
                          ),
                          // !_infiniteStop ? Container() : Container()
                        ],
                      ),
                    );
                  } else if (articleSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(child: CircularProgressIndicator()),
                      ],
                    );
                  } else if (articleSnapshot.hasError) {
                    return Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.fromLTRB(0, 60, 0, 0),
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: Column(
                        children: <Widget>[
                          Image.asset(
                            "assets/no-internet.png",
                            width: 250,
                          ),
                          Text("No Internet Connection."),
                        ],
                      ),
                    );
                  }
                  return Container(
                      alignment: Alignment.center, width: 300, height: 150);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget featuredPost(Future<List<dynamic>> featuredArticles) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: FutureBuilder<List<dynamic>>(
        future: featuredArticles,
        builder: (context, articleSnapshot) {
          if (articleSnapshot.hasData) {
            if (articleSnapshot.data!.length == 0) return Container();
            return Row(
                children: articleSnapshot.data!.map((item) {
              final heroId = item.id.toString() + "-featured";
              return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SingleArticle(item, heroId),
                      ),
                    );
                  },
                  child: articleBoxFeatured(context, item, heroId));
            }).toList());
          } else if (articleSnapshot.hasError) {
            return Container(
              alignment: Alignment.center,
              margin: EdgeInsets.fromLTRB(0, 60, 0, 0),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: <Widget>[
                  Image.asset(
                    "assets/no-internet.png",
                    width: 250,
                  ),
                  Text("No Internet Connection."),
                  TextButton.icon(
                    icon: Icon(Icons.refresh),
                    label: Text("Reload"),
                    onPressed: () {
                      _futureLastestArticles =
                          fetchLatestArticles(1) as Rxn<Future<List>?>;
                      _futureFeaturedArticles = fetchFeaturedArticles(1);
                    },
                  )
                ],
              ),
            );
          }
          return Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            height: 280,
          );
        },
      ),
    );
  }
}

void launchWhatsapp({@required number, @required message}) async {
  String url = "whatsapp://send?phone=$number&text=$message";
  await launchUrlString(url) ? (url) : print("can't open whatsapp");
}

void launchFB({required String Url}) async {
  var url = Uri.parse("https://www.facebook.com/etamilnewslive");
  if (await canLaunchUrl(url)) {
    await launchUrl(url);
  } else {
    throw "Could't Launch $url";
  }
}

void launchInsta({required String Url}) async {
  var url = Uri.parse("https://www.instagram.com/etamilnewslive/");
  if (await canLaunchUrl(url)) {
    await launchUrl(url);
  } else {
    throw "Could't Launch $url";
  }
}

void launchTwitter({required String Url}) async {
  var url = Uri.parse("https://twitter.com/etamilnewslive");
  if (await canLaunchUrl(url)) {
    await launchUrl(url);
  } else {
    throw "Could't Launch $url";
  }
}

void _launchURL() async {
  const url = 'https://www.youtube.com/channel/UCoJyIjwgBfoBbdfqhe5Kjug';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
