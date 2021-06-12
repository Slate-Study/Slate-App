import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:slate_constants/slate_constants.dart';

import 'package:slate/ui/student ui/StudentBlackBoardUI.dart';
import 'package:slate/ui/student ui/StudentChatUI.dart';
import 'package:slate/ui/student ui/StudentWorkUI.dart';

import 'package:slate_entity_models/slate_entity_models.dart';



class StudentClassRoomUI extends StatefulWidget{

  final ClassRoom classRoom;
  StudentClassRoomUI({Key key , @required this.classRoom }):super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _StudentClassRoomUI();
  }
}

class _StudentClassRoomUI extends State<StudentClassRoomUI> {

  Widget classRoomUI (BuildContext context , ClassRoom classRoom){

    return DefaultTabController(length: 3,
        child: Scaffold(

          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,

            leading: BackButton(color: CupertinoColors.activeBlue,),

            title: Text("# "+ classRoom.className ,
              style: GoogleFonts.varelaRound(color: Colors.black , fontSize: W(3.5) ),),

            bottom: TabBar(tabs: [
              Tab(icon: Icon(CupertinoIcons.chat_bubble_2_fill , color: Color(0xA31a233a),size: W(6.5),),),
              Tab(icon: Icon(CupertinoIcons.rectangle_fill , color: Color(0xA31a233a), size: W(5),),),
              Tab(icon: Icon(CupertinoIcons.tray_2_fill , color: Color(0xA31a233a), size: W(5),),)
            ]),

          ),

          body: TabBarView(
            children: [
              StudentChatUI(classRoom: classRoom),
              StudentBlackBoardUI(classRoom: classRoom),
              StudentWorkUI(classRoom: classRoom)
            ],),


        ));

  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return classRoomUI(context, widget.classRoom);
  }
}
