import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:slate_constants/slate_constants.dart';
import 'package:slate_entity_models/slate_entity_models.dart';
import 'package:slate_ui_features/slate_ui_features.dart';

import 'package:slate/globals/globals.dart' as glb;


class StudentChatUI extends StatefulWidget{

  final ClassRoom classRoom;
  StudentChatUI({Key key ,  @required this.classRoom }):super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _StudentChatUI();
  }
}

class _StudentChatUI extends State<StudentChatUI>{

  Widget chatUI (BuildContext context , ClassRoom classRoom) {

    return Padding( padding: EdgeInsets.only(left: W(3) , right: W(3)),
      child: Column(children: [

        ChatMessages_UI(classRoom: classRoom, schoolID: glb.student.schoolID, userID: glb.student.studentUid),

        ChatNewMessages(classRoom: classRoom, schoolID: glb.student.schoolID,
          userID: glb.student.studentUid, name: glb.student.name),

      ],),
    );
  }

  Widget tagDropDown (BuildContext context, ClassRoom classRoom){
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return chatUI(context, widget.classRoom);
  }
}