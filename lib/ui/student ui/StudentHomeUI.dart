import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:slate_entity_models/slate_entity_models.dart';
import 'package:slate_ui_elements/slate_ui_elements.dart';
import 'package:slate_data/slate_data.dart';
import 'package:slate_constants/slate_constants.dart';

import 'package:slate/globals/globals.dart' as glb;
import 'package:slate/ui/student ui/StudentClassRoomUI.dart';
import 'package:slate/ui/student ui/StudentUserUI.dart';

class StudentHomePage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _StudentHomePage();
  }
}

class _StudentHomePage extends State<StudentHomePage>{

  int _currentIndex = 0;

  Widget homePage (BuildContext context){
    return Scaffold(

        appBar: AppBar(
          title: Text(glb.student.schoolName , style: GoogleFonts.varelaRound(color: Colors.white,fontSize: W(3.5)),),
          backgroundColor: Color(0xff1a233a),
          brightness: Brightness.light,
        ),

        body: ListView(
          children: [

            Padding(padding: EdgeInsets.only(top: H(18) , left: W(5) , right: W(3)),
              child: Text("Class Rooms" , style: GoogleFonts.varelaRound(),),),

            Padding(padding: EdgeInsets.only(top: H(8) , left: (2)),
              child: classRoomList(context),),

            Padding(padding: EdgeInsets.only(top: H(4) , left: W(4) , right: W(20)),
              child: Container(color: Colors.black, height: H(0.3),),),


          ],
        )
    );
  }

  Widget buildBottomNavigationBar() {
    return CustomNavigationBar(
      iconSize: 30.0,
      selectedColor: Color(0xff1a233a),
      strokeColor: Color(0x801a233a),
      unSelectedColor: Color(0xffacacac),
      backgroundColor: Colors.white,
      items: [
        CustomNavigationBarItem(
          icon: Icon(Icons.home),
        ),
        CustomNavigationBarItem(
          icon: Icon(Icons.account_circle),
        ),
      ],
      currentIndex: _currentIndex,
      onTap: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
    );
  }

  Widget classRoomList (context){
    return StreamBuilder(
      stream: classRoomStream(context,glb.student.schoolID , glb.student.subjectList),
      builder: (context , snapshot){
        if (!snapshot.hasData)
        {
          return CupertinoActivityIndicator();
        }
        return ListView.builder(
          itemCount: snapshot.data.docs.length,
          physics: phy, padding: ei, scrollDirection: ax, shrinkWrap: swrap,
          itemBuilder: (BuildContext context, index) {

            ClassRoom cr = ClassRoom.student(snapshot.data.docs[index]);
            return classSelector(context, cr);
          },);
      },);
  }

  Widget classSelector (BuildContext context , ClassRoom classRoom) {
    return Padding(padding: EdgeInsets.only(top: H(2.5)) ,
      child: TextButton(
        style: TextButton.styleFrom(primary: CupertinoColors.systemGrey,),
        onPressed: () {
          Navigator.push(context, CupertinoPageRoute(
              builder: (context) =>  StudentClassRoomUI(classRoom: classRoom) ));
        },
        child: classRoomDoor(context, classRoom.className),
      ));
  }

  @override
  Widget build(BuildContext context) {

    SC().init(context);

    Widget child;
    switch(_currentIndex){
      case 0:
        child = homePage(context);
        break;
      case 1:
        child = StudentUserUI();
        break;
    }

    return Scaffold(
      bottomNavigationBar: buildBottomNavigationBar(),
      body: child,
    );

  }
}