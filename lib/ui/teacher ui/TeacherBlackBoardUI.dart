import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:slate_constants/slate_constants.dart';
import 'package:slate_entity_models/slate_entity_models.dart';
import 'package:slate_ui_features/slate_ui_features.dart';

import 'package:slate/globals/globals.dart' as glb;


class TeacherBlackBoardUI extends StatefulWidget{

  final ClassRoom classRoom;
  TeacherBlackBoardUI({Key key , @required this.classRoom }):super(key:key);

  @override
  State<StatefulWidget> createState() {
    return _TeacherBlackBoardUI();
  }
}

class _TeacherBlackBoardUI extends State<TeacherBlackBoardUI> {

  Widget blackBoard (BuildContext context , ClassRoom classRoom) {

    return ListView(children: [

      NewPostsFeature(classRoom: classRoom, teacher: glb.teacher),

      Padding(padding: EdgeInsets.only(top: H(3)) ,
          child: PostsFeature(classRoom: classRoom, schoolID: glb.teacher.schoolID))

    ],);
  }

  @override
  Widget build(BuildContext context) {
    return blackBoard(context, widget.classRoom);
  }
}