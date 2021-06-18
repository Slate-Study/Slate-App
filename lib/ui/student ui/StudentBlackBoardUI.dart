import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:slate_constants/slate_constants.dart';
import 'package:slate_entity_models/slate_entity_models.dart';

import 'package:slate/globals/globals.dart' as glb;
import 'package:slate_ui_features/slate_ui_features.dart';


class StudentBlackBoardUI extends StatefulWidget{

  final ClassRoom classRoom;
  StudentBlackBoardUI({Key key , @required this.classRoom }):super(key:key);

  @override
  State<StatefulWidget> createState() {
    return _StudentBlackBoardUI();
  }
}

class _StudentBlackBoardUI extends State<StudentBlackBoardUI> {

  Widget blackBoard (BuildContext context , ClassRoom classRoom) {

    return ListView(children: [
      Padding(padding: EdgeInsets.only(top: H(3)) ,
          child: PostsFeature(classRoom: classRoom, schoolID: glb.student.schoolID))
    ],);
  }

  @override
  Widget build(BuildContext context) {
    return blackBoard(context, widget.classRoom);
  }

}