import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:slate_constants/slate_constants.dart';
import 'package:slate_entity_models/slate_entity_models.dart';
import 'package:slate_ui_features/slate_ui_features.dart';

import 'package:slate/globals/globals.dart' as glb;


class TeacherChatUI extends StatefulWidget{

  final ClassRoom classRoom;
  TeacherChatUI({Key key ,  @required this.classRoom }):super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TeacherChatUI();
  }
}

class _TeacherChatUI extends State<TeacherChatUI>{


  Widget chatUI (BuildContext context , ClassRoom classRoom) {

    return Padding( padding: EdgeInsets.only(left: W(3) , right: W(3)),
      child: Column(children: [

        ChatMessages_UI(classRoom: classRoom, userID: glb.teacher.teacherUid,
            schoolID: glb.teacher.schoolID),

        ChatNewMessages(classRoom: classRoom, schoolID: glb.teacher.schoolID,
            userID: glb.teacher.teacherUid, name: glb.teacher.name)

      ],),
    );
  }

  @override
  Widget build(BuildContext context) {
    return chatUI(context, widget.classRoom);
  }
}