import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:e_tamilnews/pages/settings.dart';
import 'package:e_tamilnews/pages/single_Article.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../common/constants.dart';
import '../models/Article.dart';
import '../models/category_article.dart';
import '../widgets/articleBox.dart';
import '../widgets/searchBoxes.dart';
import 'authentication/email/login.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  String _searchText = "";
  List<dynamic> searchedArticles = [];
  List<dynamic> categoriesArticles = [];
  Future<List<dynamic>>? _futureSearchedArticles;
  ScrollController? _controller;
  final TextEditingController _textFieldController =
      new TextEditingController();

  int page = 1;
  bool _infiniteStop = false;

  @override
  void initState() {
    super.initState();
    _futureSearchedArticles =
        fetchSearchedArticles(_searchText, _searchText == "", page, false);
    _controller =
        ScrollController(initialScrollOffset: 0.0, keepScrollOffset: true);
    _controller!.addListener(_scrollListener);
    _infiniteStop = false;
    cat();
  }

  Future<List<dynamic>> fetchSearchedArticles(
      String searchText, bool empty, int page, bool scrollUpdate) async {
    try {
      if (empty) {
        return searchedArticles;
      }

      var response = await http.get(
          Uri.parse("$WORDPRESS_URL/wp-json/wp/v2/posts?search=$searchText&page=$page&_embed"));

      if (this.mounted) {
        if (response.statusCode == 200) {
          setState(() {
            if (scrollUpdate) {
              searchedArticles.addAll(json
                  .decode(response.body)
                  .map((m) => Article.fromJson(m))
                  .toList());
            } else {
              searchedArticles = json
                  .decode(response.body)
                  .map((m) => Article.fromJson(m))
                  .toList();
            }

            if (searchedArticles.length % 10 != 0) {
              _infiniteStop = true;
            }
          });

          return searchedArticles;
        }
        setState(() {
          _infiniteStop = true;
        });
      }
    } on SocketException {
      throw 'No Internet connection';
    }
    return searchedArticles;
  }

  _scrollListener() {
    var isEnd = _controller!.offset >= _controller!.position.maxScrollExtent &&
        !_controller!.position.outOfRange;
    if (isEnd) {
      setState(() {
        page += 1;
        _futureSearchedArticles =
            fetchSearchedArticles(_searchText, _searchText == "", page, true);
      });
    }
  }

  bool isLoaded = false;
  InterstitialAd? interstitialAd;
  var clickcount = 0;

  @override
  void dispose() {
    super.dispose();
    _textFieldController.dispose();
    _controller!.dispose();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    InterstitialAd.load(
      adUnitId:"ca-app-pub-3940256099942544/1033173712",
      request:AdRequest( ),
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

  cat() async {
    var response = await http.get(Uri.parse(
        "https://etamilnews.com/wp-json/wp/v2/categories"));
    print(jsonDecode(response.body));
    // if (response.statusCode == 200) {
      setState(() {
        categoriesArticles.addAll(json
            .decode(response.body)
            .map((m) => CategoryArticle.fromJson(m))
            .toList());
        print("");
      });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Categories',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                fontFamily: 'Poppins')),
        elevation: 5,
        backgroundColor: Colors.red,
      ),
      body: SingleChildScrollView(
        controller: _controller,
        scrollDirection: Axis.vertical,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 6,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
                  child: TextField(
                      controller: _textFieldController,
                      decoration: InputDecoration(
                        labelText: 'Search news',
                        suffixIcon: _searchText == ""
                            ? Icon(Icons.search)
                            : IconButton(
                                icon: Icon(Icons.close),
                                onPressed: () {
                                  _textFieldController.clear();
                                  setState(() {
                                    _searchText = "";
                                    _futureSearchedArticles =
                                        fetchSearchedArticles(_searchText,
                                            _searchText == "", page, false);
                                  });
                                },
                              ),
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                      onChanged: (text) {
                        setState(() {
                          _searchText = text;
                          page = 1;
                          _futureSearchedArticles = fetchSearchedArticles(
                              _searchText, _searchText == "", page, false);
                        });
                      }),
                ),
              ),
            ),
            searchPosts(_futureSearchedArticles as Future<List<dynamic>>),
          ],
        ),
      ),
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

  Widget searchPosts(Future<List<dynamic>> articles) {
    return FutureBuilder<List<dynamic>>(
      future: articles,
      builder: (context, articleSnapshot) {
        if (articleSnapshot.hasData) {
          if (articleSnapshot.data!.length == 0) {
            return Column(
              children: <Widget>[
                searchBoxes(context,categoriesArticles),
              ],
            );
          }
          return Column(
            children: <Widget>[
              Column(
                  children: articleSnapshot.data!.map((item) {
                final heroId = item.id.toString() + "-searched";
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
                  child: articleBox(context, item, heroId,));
              }).toList()),
              !_infiniteStop
                  ? Container(
                      alignment: Alignment.center,
                      height: 30,
                          )
                  : Container()
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
                TextButton.icon(
                  icon: Icon(Icons.refresh),
                  label: Text("Reload"),
                  onPressed: () {
                    _futureSearchedArticles = fetchSearchedArticles(
                        _searchText, _searchText == "", page, false);
                  },
                )
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
      throw"Could't Launch $url";
    }
  }
}
