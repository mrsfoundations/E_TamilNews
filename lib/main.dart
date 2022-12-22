import 'package:e_tamilnews/pages/home.dart';
import 'package:e_tamilnews/pages/notification_page.dart';
import 'package:e_tamilnews/pages/settings.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'firebase_options.dart';
//import 'package:firebase_messaging/firebase_messaging.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
      );
   MobileAds.instance.initialize();
  // FirebaseMessaging messaging = FirebaseMessaging.instance;
  //
  // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //   print('Got a message whilst in the foreground!');
  //   print('Message data: ${message.data}');
  //
  //   if (message.notification != null) {
  //     print('Message also contained a notification: ${message.notification}');
  //   }
  // });
      runApp(OneSignalScreen());
}
class OneSignalScreen extends StatefulWidget {
  const OneSignalScreen({Key? key}) : super(key: key);

  @override
  _OneSignalScreenState createState() => _OneSignalScreenState();
}

class _OneSignalScreenState extends State<OneSignalScreen> {
  onInitApp(){
    OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
    OneSignal.shared.setAppId("644c12e5-c265-455c-bc47-8279a305d646");
    OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
      print("Accepted Permissions:$accepted");
    });

    OneSignal.shared.setNotificationWillShowInForegroundHandler((OSNotificationReceivedEvent event) {
      event.complete(event.notification);
    });

    OneSignal.shared
        .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      print(result.notification.additionalData?['user_id']);
      setState(() {
        var data =result.notification.additionalData!;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NotificationScreen(data),
          ),
        );
      });
      });
  }
  @override
  void initState(){
    super.initState();
    onInitApp();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
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




