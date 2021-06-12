import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:slate_constants/slate_constants.dart';
import 'package:slate/ui/login/LoginScreenUI.dart';
import 'package:slate_login/slate_login.dart';

import 'package:slate/ui/login/CheckUserUI.dart';

class FirebaseInitialise extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _FirebaseInitialise();
  }
}

class _FirebaseInitialise extends State<FirebaseInitialise>{

  @override
  Widget build(BuildContext context) {

    // TODO: implement build
    return FutureBuilder(
      future: firebaseInitialize(),
      builder: (context , snapshot){

        if(snapshot.hasError) {
          return CupertinoPageScaffold(child: Center(child: Text("Connection Error"),));
        }

        else if(snapshot.connectionState == ConnectionState.done ) {

          return checkUserUi(context);
        }

        else{
          return CupertinoPageScaffold(child: Center(child: CupertinoActivityIndicator(),));
        }

      },
    );
  }

}