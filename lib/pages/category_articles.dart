import 'dart:convert';
import 'dart:io';
import 'package:e_tamilnews/pages/single_article.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;
import '../common/constants.dart';
import '../models/Article.dart';
import '../widgets/articleBox.dart';
class CategoryArticles extends StatefulWidget {
  final int id;
  final String name;
  CategoryArticles(this.id, this.name, {Key? key}) : super(key: key);
  @override
  _CategoryArticlesState createState() => _CategoryArticlesState();
}

class _CategoryArticlesState extends State<CategoryArticles> {
  List<dynamic> categoryArticles = [];
  Rxn<Future<List<dynamic>>?> _futureCategoryArticles= Rxn();
  ScrollController? _controller;
  int page = 1;
  bool _infiniteStop = false;

  @override
  void initState() {
    super.initState();
    _futureCategoryArticles.value = fetchCategoryArticles(1);
    _controller =
        ScrollController(initialScrollOffset: 0.0, keepScrollOffset: true);
    _controller!.addListener(_scrollListener);
    _infiniteStop = false;
  }

  @override
  void dispose() {
    super.dispose();
    _controller!.dispose();
  }

  Future<List<dynamic>> fetchCategoryArticles(int page) async {
    try {
      var response = await http.get(Uri.parse(
          "$WORDPRESS_URL/wp-json/wp/v2/posts?categories[]=${widget.id}&page=$page&_embed"));

      if (this.mounted) {
        if (response.statusCode == 200) {
          setState(() {
            categoryArticles.addAll(json
                .decode(response.body)
                .map((m) => Article.fromJson(m))
                .toList());
            if (categoryArticles.length % 10 != 0) {
              _infiniteStop = true;
            }
          });

          return categoryArticles;
        }
        setState(() {
          _infiniteStop = true;
        });
      }
    } on SocketException {
      throw 'No Internet connection';
    }
    return categoryArticles;
  }

  _scrollListener() {
    var isEnd = _controller!.offset >= _controller!.position.maxScrollExtent &&
        !_controller!.position.outOfRange;
    if (isEnd) {
      setState(() {
        page += 1;
        _futureCategoryArticles = fetchCategoryArticles(page) as Rxn<Future<List>?>;
      });
    }
  }

  var isLoaded = false;
  BannerAd? bannerAd;
  InterstitialAd? interstitialAd;
  var clickcount = 0;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

    bannerAd=BannerAd(size:AdSize.banner,
        adUnitId:BannerAd_ID,
        listener:BannerAdListener(
            onAdLoaded:(ad){
              setState(() {
                isLoaded=true;
              });
              print("Banner Loaded");
            },
            onAdFailedToLoad:(ad, error) {
              ad.dispose();
            }),
        request: const AdRequest()
    );
    bannerAd!.load();

    InterstitialAd.load(
      adUnitId:InterstitialAd_ID,
      request:const AdRequest( ),
      adLoadCallback:InterstitialAdLoadCallback(
        onAdLoaded: (ad){
          setState(() {
            isLoaded=true;
            this.interstitialAd=ad;

          });
        },
        onAdFailedToLoad: (error){
        },
      ),
    );
  }

  void showInterstitial()async{
    interstitialAd?.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (InterstitialAd ad) =>
          ad.dispose(),
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        Navigator.of(context).pop();
        ad.dispose();
      },
    );
    interstitialAd?.show();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(widget.name,
            textAlign: TextAlign.left,
            style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
                fontFamily: 'Poppins')),
        elevation: 5,
        backgroundColor: Colors.red[400],
      ),
      body: Container(
        decoration: const BoxDecoration(color: Colors.white),
        child: SingleChildScrollView(
            controller: _controller,
            scrollDirection: Axis.vertical,
            child: Column(children: <Widget>[
              Obx(()=>FutureBuilder<List<dynamic>>(
                future: _futureCategoryArticles.value,
                builder: (context, articleSnapshot) {
                  if (articleSnapshot.hasData) {
                    if (articleSnapshot.data!.isEmpty) return Container();
                    return Column(
                      children: <Widget>[
                        Column(
                            children: articleSnapshot.data!.map((item) {
                              final heroId = "${item.id}-categorypost";
                              print(item.id);
                              return InkWell(
                                onTap: () {
                                  setState(() {
                                    clickcount = clickcount +1 ;
                                    if (clickcount > 2) {
                                      showInterstitial();
                                      clickcount = 0;
                                    }
                                  });
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SingleArticle(item, heroId),
                                    ),
                                  );
                                },
                                child: articleBox(context, item, heroId),
                              );
                            }).toList()),
                        !_infiniteStop
                            ? Container(
                               child: CircularProgressIndicator(),
                              )
                            : Container()
                      ],
                    );
                  } else if (articleSnapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
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
                      alignment: Alignment.center,
                      width: 300,
                      height: 150
                  );
                },
              )),
              isLoaded?SizedBox(
                height: 50,
                child: AdWidget(ad: bannerAd!,),):const SizedBox(),
            ])),
      ),
    );
  }

  Widget categoryPosts(Future<List<dynamic>> categoryArticles) {
    return FutureBuilder<List<dynamic>>(
      future: categoryArticles,
      builder: (context, articleSnapshot) {
        if (articleSnapshot.hasData) {
          if (articleSnapshot.data!.isEmpty) return Container();
          return Column(
            children: <Widget>[
              Column(
                  children: articleSnapshot.data!.map((item) {
                final heroId = "${item.id}-categorypost";
                print(item.id);
                return InkWell(
                  onTap: () {
                    setState(() {
                      clickcount = clickcount +1 ;
                      if (clickcount > 2) {
                        showInterstitial();
                        clickcount = 0;
                      }
                    });
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SingleArticle(item, heroId),
                      ),
                    );
                  },
                  child: articleBox(context, item, heroId),
                );
              }).toList()),
              // !_infiniteStop
              //     ? Container(
              //         alignment: Alignment.center,
              //         height: 30,
              //       )
              //     : Container()
            ],
          );
        } else if (articleSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
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
            alignment: Alignment.center,
            width: 300,
            height: 150
        );
      },
    );
  }
}
