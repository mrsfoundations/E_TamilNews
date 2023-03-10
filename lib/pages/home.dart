import 'package:flutter/material.dart';
import '../common/constants.dart';
import '../pages/articles.dart';
import '../pages/search.dart';
import '../pages/settings.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  int _selectedIndex = 0;
  final List<Widget> _widgetOptions = [
    Articles(),
    Search(),
    Settings(),
  ];

  @override
  void initState() {
    super.initState();
  }

  var isLoaded = false;
  BannerAd? bannerAd;

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
        request: AdRequest()
    );
    bannerAd!.load();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Expanded(child: _widgetOptions.elementAt(_selectedIndex)),
            isLoaded?Container(
              height: 50,
              child: AdWidget(ad: bannerAd!,
              ),):SizedBox(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.white,
          selectedLabelStyle:
          TextStyle(fontWeight: FontWeight.w500, fontFamily: "Soleil"),
          unselectedLabelStyle: TextStyle(fontFamily: "Soleil"),
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Categories'),
            BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Profile'),
          ],
          currentIndex: _selectedIndex,
          fixedColor: Colors.red,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
