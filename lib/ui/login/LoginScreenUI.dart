import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:slate_constants/slate_constants.dart';
import 'package:slate/ui/login/CheckUserUI.dart';
import 'package:slate_login/slate_login.dart';

class LoginUI extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _LoginUI();
  }
}

class _LoginUI extends State<LoginUI>{

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  String _email = "";
  String _password = "";


  Widget loginUi(BuildContext context){
    return CupertinoPageScaffold(
        child: Container(width: W(100), height: H(200),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center ,
              children: [

                //Padding(padding: EdgeInsets.only(bottom: H(5)) , child: appIcon(context),),

                Padding(padding: EdgeInsets.only(bottom: H(7)) , child: welcomeText(context),),

                Padding(padding: EdgeInsets.only(bottom: H(4)) , child: _emailField(context),),

                Padding(padding: EdgeInsets.only(bottom: H(5)) , child: _passwordField(context),),

                Padding(padding: EdgeInsets.only(bottom: H(4)) , child: _signInButton(context),),

                Padding(padding: EdgeInsets.only(bottom: H(2)) , child: forgotButton(context),),

              ],)
        ));
  }

  Widget welcomeText (BuildContext context) {
    return Container(child: Column(crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text("Welcome !" , style: GoogleFonts.varela(fontSize: W(8)),),
        Padding(padding: EdgeInsets.only(top: H(0.5)) ,
          child: Text("sign in to Slate with your school account" , style: GoogleFonts.varela(fontSize: W(3.5)),))
      ],),);
  }

  Widget appIcon(BuildContext context) {
    return Container(
        height: H(17), width: W(18),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(W(3)),
            image: DecorationImage(image: AssetImage('assets/icon.png') , fit: BoxFit.cover)
        ));
  }

  Widget _emailField(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(W(2)),
      child: Container(
          height: H(12),
          decoration: writeDecoration,
          child: Row(mainAxisSize: MainAxisSize.min,
            children: [

              Padding(padding: EdgeInsets.only(right: W(1.5) , left: W(1.5)) ,
                child: Icon(Icons.person , color: Colors.black,), ),

              Padding(padding: EdgeInsets.only(right: W(2)) ,
                child: Container(
                    width: W(65) , height: H(9),
                    child: CupertinoTextField(
                      keyboardType: TextInputType.emailAddress,
                      controller: email,
                      placeholder: "email",
                    ))
              )
            ],))
    );
  }

  Widget _passwordField(BuildContext context){
    return ClipRRect(
        borderRadius: BorderRadius.circular(W(2)),
        child: Container(
          height: H(12),
          decoration: writeDecoration,
          child: Row(mainAxisSize: MainAxisSize.min,
            children: [

              Padding(padding: EdgeInsets.only(right: W(1.5) , left: W(1.5)) ,
                child: Icon(Icons.lock , color: Colors.black,), ),

              Padding(padding: EdgeInsets.only(right: W(2)) ,
                child: Container(
                    width: W(65) , height: H(9),
                    child: CupertinoTextField(
                      obscureText: true,
                      keyboardType: TextInputType.visiblePassword,
                      controller: password,
                      placeholder: "password",
                    ))
              )
          ],),
      ));
  }

  Widget _signInButton(BuildContext context){
    return Container(width: W(35), height: H(8),
        child: ElevatedButton(child: Text("Sign In" , style: GoogleFonts.varela(color: Colors.black)),

          style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>( CupertinoColors.systemBlue )),

          onPressed: () async {
            _email = email.text;
            _password = password.text;

            if(_email != "" && _password != "")
            {
              User _user = ( await loginFunction(_email, _password, context) ); print(_user.uid);
              Navigator.pushAndRemoveUntil(context, CupertinoPageRoute(
                  builder: (context) => checkUserUi(context) ), (route) => false);
            }

            setState(() {
              email.clear();
              password.clear();
            });
          },
        )
    );
  }

  Widget forgotButton(context){
    return GestureDetector(
        onTap: () {
          showDialog( context: context,
              barrierDismissible: false,
              builder: (context) => checkReset(context)
          );
        },
        child: Container(child: Text("Forgot Password ?" ,
          style: TextStyle(color: Colors.blueAccent , fontSize: W(3.5),
              decoration: TextDecoration.underline),
        ),)
    );
  }

  Widget checkReset (context) {
    return AlertDialog(
      title: Text("Forgot Password"),
      content: Column(mainAxisSize: MainAxisSize.min,children: [
        Container(width: W(72) , child: Text("Enter registered mail-Id to reset password") ) ,
        _emailField(context)
      ],),
      actions: [
        Padding(padding: EdgeInsets.only(right: W(4))  ,
          child: ElevatedButton(
              child: Text("Reset"),
              onPressed: (){
                _email = email.text;
                if(_email != null && _email != "")
                {
                  resetPasswordWithEmail(context , _email);
                  showDialog( context: context,
                      barrierDismissible: false,
                      builder: (context) => resetMail(context)
                  );
                }
              }),) ,

        Padding(padding: EdgeInsets.only(right: W(4))  ,
          child: ElevatedButton(
              child: Text("Cancel"),
              onPressed: (){
                Navigator.pop(context);
              }),)
      ],);
  }

  Widget resetMail (context) {
    return AlertDialog(
      title: Text("Password Reset"),
      content: Container(width: W(72) , child: Text("Please reset your password via the email sent to your registered mail-Id and login using new password") ),
      actions: [
        Padding(padding: EdgeInsets.only(right: W(4))  ,
          child: ElevatedButton(
              child: Text("Ok"),
              onPressed: (){
                Navigator.pushAndRemoveUntil(context, CupertinoPageRoute(
                    builder: (context) =>  LoginUI() ) , (route) => false );
              }),)
      ],);
  }


  @override
  Widget build(BuildContext context) {
    SC().init(context);
    return loginUi(context);
  }
}

