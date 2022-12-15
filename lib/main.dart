import 'package:e_tamilnews/pages/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import '../pages/authentication/email/login.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
// import 'firebase_options.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';

// final auth = FirebaseAuth.instance;

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(
  //     options: DefaultFirebaseOptions.currentPlatform,);
  // MobileAds.instance.initialize();
      runApp(OneSignalScreen());
}
class OneSignalScreen extends StatefulWidget {
  const OneSignalScreen({Key? key}) : super(key: key);

  @override
  _OneSignalScreenState createState() => _OneSignalScreenState();
}

class _OneSignalScreenState extends State<OneSignalScreen> {
  // @override
  // void initState(){
  //   super.initState();
  //   initPlateformState();
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(

      ),
       home: AnimatedSplashScreen(
          splashIconSize: 100,
          duration: 1500,
          splash:"assets/etamil (1).png",
          nextScreen: MyHomePage(),
          splashTransition: SplashTransition.fadeTransition,
          backgroundColor: Colors.redAccent),
    );
  }
}
//   Future<void> initPlateformState()async{
//     OneSignal.shared.setAppId(oneSignalAppId);
//   }




