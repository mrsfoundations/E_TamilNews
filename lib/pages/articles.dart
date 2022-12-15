import 'dart:async';
import 'dart:convert';
import 'dart:io' show SocketException;
import 'package:e_tamilnews/pages/settings.dart';
import 'package:e_tamilnews/pages/single_article.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_carousel_slider/flutter_custom_carousel_slider.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../common/constants.dart';
import '../models/Article.dart';
import '../widgets/articleBox.dart';
import '../widgets/articleBoxFeatured.dart';
import 'authentication/email/login.dart';
import 'package:url_launcher/url_launcher.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  runApp(Articles());
}

class Articles extends StatefulWidget {
  @override
  _ArticlesState createState() => _ArticlesState();
}

class _ArticlesState extends State<Articles> {
  // List<dynamic> featuredArticles = [];
  List<dynamic> latestArticles = [];

  Future<List<dynamic>>? _futureLastestArticles;
  // Future<List<dynamic>>? _futureFeaturedArticles;
  ScrollController? _controller;
  int page = 1;
  bool _infiniteStop = false;
  


  @override
  void initState() {
    super.initState();
    OnRefIndicator(page);
    _futureLastestArticles = fetchLatestArticles(1);
    // _futureFeaturedArticles = fetchFeaturedArticles(1);
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
          adUnitId: "ca-app-pub-3940256099942544/6300978111",
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
      var response = await http.get(Uri.parse(
          '$WORDPRESS_URL/wp-json/wp/v2/posts/?_embed'));
      print('$WORDPRESS_URL/wp-json/wp/v2/posts/?_embed');
      if (this.mounted) {
        if (response.statusCode == 200) {
          latestArticles.addAll(json
              .decode(response.body)
              .map((m) => Article.fromJson(m))
              .toList());

          if (latestArticles.length % 10 != 0) {
            _infiniteStop = true;
          }
          latestArticles.forEach((item) {
            itemList.add(
              CarouselItem(
                image: NetworkImage(
                  item.image,
                ),
                onImageTap: (i) {
                  final heroId = item.id.toString();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SingleArticle(item, heroId),
                    ),
                  );
                  print(heroId);
                },
              ),
            );
          });

          // print(itemList.length);
          setState(() {});
          return latestArticles;
        }
        setState(() {
          _infiniteStop = true;
        });
      }
    } on SocketException {
      throw 'No Internet connection';
    }
    return latestArticles;
  }

  OnRefIndicator(int page) async {
    try {
      var response = await http.get(Uri.parse(
          '$WORDPRESS_URL/wp-json/wp/v2/posts/?_embed'));
      if (this.mounted) {
        if (response.statusCode == 200) {
          latestArticles = (json
              .decode(response.body)
              .map((m) => Article.fromJson(m))
              .toList());

          if (latestArticles.length % 10 != 0) {
            _infiniteStop = true;
          }
          itemList = latestArticles.map((item) {
            return CarouselItem(
              image: NetworkImage(
                item.image,
              ),
              onImageTap: (i) {
                final heroId = item.id.toString();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>  SingleArticle(item, heroId),
                  ),
                );
                print(item.link);
              },
            );
          }).toList();

          // print(itemList.length);
          setState(() {});
        }
      }
    } on SocketException {
      throw 'No Internet connection';
    }
  }

  // Future<List<dynamic>> fetchFeaturedArticles(int page) async {
  //   try {
  //     var response = await http.get(
  //         Uri.parse("$WORDPRESS_URL/wp-json/wp/v2/posts?categories[]=7&page=$page&per_page=10&_fields=id,date,title,content,slug,link"));
  //
  //     if (this.mounted) {
  //       if (response.statusCode == 200) {
  //         setState(() {
  //           featuredArticles.addAll(json
  //               .decode(response.body)
  //               .map((m) => Article.fromJson(m))
  //               .toList());
  //         });
  //
  //         return featuredArticles;
  //       } else {
  //         setState(() {
  //           _infiniteStop = true;
  //         });
  //       }
  //     }
  //   } on SocketException {
  //     throw 'No Internet connection';
  //   }
  //   return featuredArticles;
  // }

  _scrollListener() {
    var isEnd = _controller!.offset >= _controller!.position.maxScrollExtent &&
        !_controller!.position.outOfRange;
    if (isEnd) {
      setState(() {
        page += 1;
        _futureLastestArticles = fetchLatestArticles(page);
      });
    }
  }

  List<CarouselItem> itemList = [];

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    InterstitialAd.load(
      adUnitId:"ca-app-pub-3940256099942544/1033173712",
      request:AdRequest(),
      adLoadCallback:InterstitialAdLoadCallback(
        onAdLoaded: (ad){
          setState(() {
            isLoaded=true;
            this.interstitialAd=ad;

          });
          print("Ad");
        },
        onAdFailedToLoad: (error){
          print("Interstitial Ad");
        },
      ),
    );
  }
  void showInterstitial()async{
    interstitialAd?.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) =>
          print('Ad Showed'),
      onAdDismissedFullScreenContent: (InterstitialAd ad) =>
          ad.dispose(),
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
        title: Text("Etamilnews"),
        elevation: 5,
        backgroundColor: Colors.red,
      ),
      body: Container(
        decoration: BoxDecoration(color: Colors.white70),
        child: Column(
          children: <Widget>[
            latestPosts(_futureLastestArticles as Future<List<dynamic>>)
          ],
        ),
      ),
      //Drawer
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          children: <Widget>[
            DrawerHeader(
              child:Text("Etamilnews",
                style:TextStyle(fontSize: 25),
              ),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text("Profile"),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Settings()));
              },
            ),
            ListTile(
              leading:  Image.asset('assets/Whatsapp_icon.png',height: 25,),
              title: Text("What's App"),
              onTap: () {
                launchWhatsapp(number: "+919790055058", message: "Hi");
              },
            ),
            ListTile(
              leading:  Image.asset('assets/Youtubeicon.png',width: 25,),
              title: Text("Youtube"),
              onTap: () {
                launchYoutube(
                    Url:
                        "https://www.youtube.com/channel/UCoJyIjwgBfoBbdfqhe5Kjug");
              },
            ),
            ListTile(
              leading: Icon(Icons.share),
              title: Text("Share This App"),
              onTap: () {
                Share.share(
                    'https://github.com/mrsfoundations/Flutter-for-Wordpress-App');
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text("Logout"),
              onTap: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget latestPosts(Future<List<dynamic>> latestArticles) {
    return FutureBuilder<List<dynamic>>(
      future: latestArticles,
      builder: (context, articleSnapshot) {
        if (articleSnapshot.hasData) {
          if (articleSnapshot.data!.length == 0) return Container();
          return Expanded(
            flex: 2,
            child: Column(
              children:[
                Container(
                child: CustomCarouselSlider(
                  height: 150,
                  items: itemList,
                  showSubBackground: false,
                  width: MediaQuery.of(context).size.width * 9,
                  autoplay: true,
                )),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                    await OnRefIndicator(page);
                    },
                    child: Builder(
                      builder: (context) {
                        // adsInserter(articleSnapshot.data);
                        return ListView(
                            children: articleSnapshot.data!.map((item) {
                              // if (item is BannerAd) {
                              //   return Container(
                              //     height: 50,
                              //     child: AdWidget(
                              //       ad: item,
                              //     ),
                              //   );
                              // }
                              final heroId = item.id.toString();
                              return InkWell(
                                onTap: () {
                                  setState(() {
                                    // clickcount = clickcount +1 ;
                                    // if (clickcount > 2) {
                                    //   showInterstitial();
                                    //   clickcount = 0;
                                    // }
                                  });
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SingleArticle(item, heroId),
                                    ),
                                  );
                                },
                                child: articleBox(context, item, heroId));

                            }).toList());
                      }
                    ),
                  ),
                ),
                !_infiniteStop ? Container() : Container()
              ],
            ),
          );
        } else if (articleSnapshot.connectionState == ConnectionState.waiting) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(child: CircularProgressIndicator()),
            ],
          );
        } else if (articleSnapshot.hasError) {
          return Container();
        }
        return Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width,
          height: 150,
        );
      },
    );
  }
  // Widget featuredPost(Future<List<dynamic>> featuredArticles) {
  //   return SingleChildScrollView(
  //     scrollDirection: Axis.horizontal,
  //     child: FutureBuilder<List<dynamic>>(
  //       future: featuredArticles,
  //       builder: (context, articleSnapshot) {
  //         if (articleSnapshot.hasData) {
  //           if (articleSnapshot.data!.length == 0) return Container();
  //           return Row(
  //               children: articleSnapshot.data!.map((item) {
  //                 final heroId = item.id.toString() + "-featured";
  //                 return InkWell(
  //                     onTap: () {
  //                       Navigator.push(
  //                         context,
  //                         MaterialPageRoute(
  //                           builder: (context) => SingleArticle(item, heroId),
  //                         ),
  //                       );
  //                     },
  //                     child: articleBoxFeatured(context, item, heroId)
  //                 );
  //               }).toList());
  //         } else if (articleSnapshot.hasError) {
  //            return Container(
  //           //   alignment: Alignment.center,
  //           //   margin: EdgeInsets.fromLTRB(0, 60, 0, 0),
  //           //   width: MediaQuery.of(context).size.width,
  //           //   height: MediaQuery.of(context).size.height,
  //           //   child: Column(
  //           //     children: <Widget>[
  //           //       Image.asset(
  //           //         "assets/no-internet.png",
  //           //         width: 250,
  //           //       ),
  //           //       Text("No Internet Connection."),
  //           //       TextButton.icon(
  //           //         icon: Icon(Icons.refresh),
  //           //         label: Text("Reload"),
  //           //         onPressed: () {
  //           //           _futureLastestArticles = fetchLatestArticles(1);
  //           //           _futureFeaturedArticles = fetchFeaturedArticles(1);
  //           //         },
  //           //       )
  //           //     ],
  //           //   ),
  //           );
  //         }
  //         return Container(
  //           alignment: Alignment.center,
  //           width: MediaQuery.of(context).size.width,
  //           height: 280,
  //
  //         );
  //       },
  //     ),
  //   );
  // }
}

void launchWhatsapp({@required number, @required message}) async {
  String url = "whatsapp://send?phone=$number&text=$message";
  await launchUrlString(url) ? (url) : print("can't open whatsapp");
}

void launchYoutube({required String Url}) async {
  var url = Uri.parse(
      "https://www.youtube.com/channel/UCoJyIjwgBfoBbdfqhe5Kjug");
  if (await canLaunchUrl(url)) {
    await launchUrl(url);
  } else {
    throw "Could't Launch $url";
  }
}
