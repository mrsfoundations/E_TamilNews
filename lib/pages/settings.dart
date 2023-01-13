import 'package:e_tamilnews/pages/search.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'PrivacyPolicy.dart';
import 'Terms_Conditions.dart';
import 'articles.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Profile',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    fontFamily: 'Poppins'),
              ),
            ),
            Image.asset(
              'assets/etamil (1).png',
              fit: BoxFit.contain,
              height: 30,
            ),
          ],
        ),
        backgroundColor:Colors.red[400],
      ),
      body: Container(
          decoration: BoxDecoration(color: Colors.white),
          child: Column(
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.fromLTRB(0, 20, 0, 10),
                child: Image(
                  image: AssetImage('assets/etamil (1).png'),
                  height: 50,
                ),
              ),
              SizedBox(height: 5,),
              Divider(
                height: 10,
              ),
              ListView(shrinkWrap: true, children: <Widget>[
                ListTile(
                  title: Text('Contact us'),
                  subtitle: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 295, 0),
                        child: GestureDetector(child: Image.asset("assets/Whatsapp_icon.png",height: 30,),
                          onTap: (){
                          launchWhatsapp(number: "+919790055058", message: "Hi");
                          },
                        ),
                      )
                    ],
                  ),
                ),
                Divider(
                  height: 10,
                ),
                ListTile(
                  title: Text('Social Meadia'),
                  subtitle: Row(
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
                Divider(
                  height: 5,
                ),
                InkWell(
                  onTap: () {
                    Share.share('https://etamilnews.com/');
                  },
                  child: ListTile(
                    title: Text('Share'),
                    subtitle:
                        Text("Spread the News with the EtamilNews"),
                  ),
                ),
                Divider(
                  height: 5,
                ),
                ListTile(
                  title: GestureDetector(child: Text("Privacy Policy"),
                    onTap:(){
                      Navigator.push(
                          context, MaterialPageRoute(builder: (context) => PrivacyPolicy()));
                    } ,),
                ),
                Divider(
                  height: 5,
                ),
                ListTile(
                  title: GestureDetector(child: Text("Terms & Conditions"),
                  onTap:(){
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context) => Terms_Conditions()));
                  } ,),
                ),
                Divider(
                  height: 5,
                ),
               GestureDetector(
                 child: ListTile(
                      title: Text('Connect with CloudsIndia'),
                      subtitle:
                      Text("We are ready to help you to create"),
                    ),
                 onTap: () {
                   launchCloudsindia(
                       Url: "https://cloudsindia.in/");
                 },
               ),
                Center(
                    child: Padding(
                  padding: const EdgeInsets.fromLTRB(50, 55, 50, 0),
                  child: GestureDetector(
                    child: Text("Developed and Maintained by CloudsIndia"),
                    onTap: () {
                      launchWhatsapp(number: "+919943094945", message: "Hi");
                    },
                  ),
                ))
              ]),
            ],
          )),
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
    );
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

void launchCloudsindia({required String Url}) async {
    var url = Uri.parse("https://cloudsindia.in/");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw "Could't Launch $url";
    }
  }

void launchYoutube({required String Url}) async {
    var url =
        Uri.parse("https://www.youtube.com/channel/UCoJyIjwgBfoBbdfqhe5Kjug");
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
}}
