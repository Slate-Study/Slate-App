import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:slate_login/slate_login.dart';
import 'package:slate_notifications/slate_notifications.dart';
import 'package:slate_constants/slate_constants.dart';

import 'package:slate/ui/login/LoginScreenUI.dart';
import 'package:slate/globals/globals.dart' as glb;


class TeacherUserUI extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _TeacherUserUI();
  }
}

class _TeacherUserUI extends State<TeacherUserUI> {

  Widget userUi (BuildContext context) {
    return CupertinoPageScaffold(

        child: Container( height: H(200), width: W(100),

            child: Column(children: [

              topPage(context),
              bottomPage(context)

            ],)
        ));
  }

  Widget topPage(BuildContext context) {
    return Container(
      height: H(70) , width: W(100)  , color: Colors.pinkAccent,
      child: userDetails(context),
    );
  }


  Widget bottomPage (BuildContext context) {
    return Container(
        width: W(100) ,color: CupertinoColors.white,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start ,children: [

          Padding(padding: EdgeInsets.only(left: W(8) , top: H(8)),
            child: signOutButton(context),
          ),

          Padding(padding: EdgeInsets.only(left: W(8) , top: H(4)),
            child: resetButton(context),
          ),

        ],));
  }

  Widget userDetails (context) {

    return Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start,

      children: [

        Padding(padding: EdgeInsets.only(left: W(5) , right: W(5) , top: H(24) ,bottom: H(6.5)) ,
            child: Text(glb.teacher.name , style: GoogleFonts.varelaRound(fontWeight: FontWeight.bold , fontSize: W(6)) ,
            )),

        Padding(padding: EdgeInsets.only(left: W(5) , right: W(5) , bottom: H(2)) ,
            child: Text(glb.teacher.schoolName , style: GoogleFonts.varelaRound( fontSize: W(3.5) )
            )),


      ],);

  }

  Widget signOutButton (BuildContext context) {
    return Container( width: W(30), height: H(8),
      child: ElevatedButton(
        style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>( CupertinoColors.activeBlue )),
        child: Text("Sign Out" , style: GoogleFonts.varela(color: Colors.black),),
        onPressed: () async {
          unSubscribeFromTopic(glb.teacher.subjectList);
          glb.teacher.destroy();
          await logoutFunction();

          Navigator.pushAndRemoveUntil(context, CupertinoPageRoute(
              builder: (context) =>  LoginUI() ) , (route) => false );

        },
      ),);
  }

  Widget resetButton(context){
    return GestureDetector(
      onTap: () {
        showDialog( context: context,
            barrierDismissible: false,
            builder: (context) => checkReset(context)
        );
      },
      child: Text("Reset Password" ,
        style: TextStyle(color: Colors.blueAccent , fontSize: W(3.5),
            decoration: TextDecoration.underline),
      ),);
  }


  Widget checkReset (context) {
    return AlertDialog(
      title: Text("Password Reset"),
      content: Container(width: W(72) , child: Text("Do you want to reset your password") ),
      actions: [
        Padding(padding: EdgeInsets.only(right: W(4))  ,
          child: ElevatedButton(
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>( CupertinoColors.activeBlue )),
              child: Text("Yes" , style: GoogleFonts.varela(),),
              onPressed: (){
                resetPassword(context);
                showDialog( context: context,
                    barrierDismissible: false,
                    builder: (context) => passwordResetMail(context)
                );
              }),) ,

        Padding(padding: EdgeInsets.only(right: W(4))  ,
          child: ElevatedButton(
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>( CupertinoColors.activeBlue )),
              child: Text("No" , style: GoogleFonts.varela(),),
              onPressed: (){
                Navigator.pop(context);
              }),)
      ],
    );
  }

  Widget passwordResetMail (context) {
    return AlertDialog(
      title: Text("Password Reset Email Sent"),
      content: Container(width: W(72) , child: Text("Please reset your password via the email sent to your registered mail-ID") ),
      actions: [
        Padding(padding: EdgeInsets.only(right: W(4))  ,
          child: ElevatedButton(
              child: Text("Ok"),
              onPressed: (){
                Navigator.pushAndRemoveUntil(context, CupertinoPageRoute(
                    builder: (context) =>  LoginUI() ) , (route) => false );
              }),)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return userUi(context);
  }
}