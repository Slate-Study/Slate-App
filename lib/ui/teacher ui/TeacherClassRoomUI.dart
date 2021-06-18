import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';

import 'package:slate_constants/slate_constants.dart';

import 'package:slate/ui/teacher ui/TeacherBlackBoardUI.dart';
import 'package:slate/ui/teacher ui/TeacherChatUI.dart';
import 'package:slate/ui/teacher ui/TeacherWorkUI.dart';

import 'package:slate_entity_models/slate_entity_models.dart';



class TeacherClassRoomUI extends StatefulWidget{

  final ClassRoom classRoom;
  TeacherClassRoomUI({Key key , @required this.classRoom }):super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TeacherClassRoomUI();
  }
}

class _TeacherClassRoomUI extends State<TeacherClassRoomUI> with TickerProviderStateMixin {

  TabController tabController;

  @override
  void initState(){
    super.initState();
    tabController = TabController(length: 3, vsync: this);
    tabController.addListener(() {
      FocusScope.of(context).unfocus();
    });
  }

  Widget classRoomUI (BuildContext context , ClassRoom classRoom){

    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        leading: BackButton(color: CupertinoColors.activeBlue,),

        title: Text("# "+ classRoom.className ,
          style: GoogleFonts.varelaRound(color: Colors.black , fontSize: W(3.5) ),),

        bottom: TabBar(controller: tabController,tabs: [
          Tab(icon: Icon(Ionicons.chatbubbles , color: Color(0xA31a233a), size: W(5),),),
          Tab(icon: Icon(Ionicons.library , color: Color(0xA31a233a), size: W(5),),),
          Tab(icon: Icon(Ionicons.book , color: Color(0xA31a233a), size: W(5),),)
        ]),
      ),

      body: TabBarView(controller: tabController,
        children: [
          TeacherChatUI(classRoom: classRoom),
          TeacherBlackBoardUI(classRoom: classRoom),
          TeacherWorkUI(classRoom: classRoom),
        ],),
    );
  }


  @override
  Widget build(BuildContext context) {
    return classRoomUI(context, widget.classRoom);
  }
}
