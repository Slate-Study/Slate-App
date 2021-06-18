import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'ui/login/Initialise.dart';
import 'package:slate_notifications/slate_notifications.dart';
import 'notify service/notify_service.dart';

Future<void> onBackgroundMessageHandler (RemoteMessage message) async {

  print("background message triggered");
  await Firebase.initializeApp();

  if(message.data!= null)
  {
    flutterLocalNotificationsPlugin.show(
        message.data.hashCode,
        message.data["title"],
        message.data["body"],
        notifyDetails,
        payload: message.data["subject"]
    );
  }
}

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  NotifyService().init();

  FirebaseMessaging.onBackgroundMessage(onBackgroundMessageHandler);

  FirebaseMessaging.onMessage.listen( (RemoteMessage message){
    print("Open Message Received : "+ message.data["subject"]);
  });

  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  static final navigatorKey = new GlobalKey<NavigatorState>();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return CupertinoApp(

      navigatorKey: navigatorKey,

      localizationsDelegates: <LocalizationsDelegate<dynamic>>[
        DefaultMaterialLocalizations.delegate,
        DefaultWidgetsLocalizations.delegate,
        DefaultCupertinoLocalizations.delegate,
      ],

      title: "Slate",
      home: FirebaseInitialise(),
    );

  }
}