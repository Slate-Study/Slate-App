import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:slate_constants/slate_constants.dart';
import 'package:slate_entity_models/slate_entity_models.dart';
import 'package:slate_element_models/slate_element_models.dart';
import 'package:slate_data/slate_data.dart';
import 'package:slate_ui_elements/slate_ui_elements.dart';
import 'package:slate_ui_features/slate_ui_features.dart';

import 'package:slate/globals/globals.dart' as glb;
import 'package:slate/ui/teacher ui/TeacherWorkViewUI.dart';


class TeacherWorkUI extends StatefulWidget{

  final ClassRoom classRoom;
  TeacherWorkUI({Key key ,  @required this.classRoom }):super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TeacherWorkUI();
  }
}

class _TeacherWorkUI extends State<TeacherWorkUI> {

  Widget workUI (BuildContext context , ClassRoom classRoom)
  {
    return Stack(children: [

      ListView(children: [

        Padding(padding: EdgeInsets.only(top: H(3)) ,
            child: getWorks(context, classRoom))

      ],),

      Padding(padding: EdgeInsets.only(top: H(150) , left: W(64)) ,
          child: NewWorkFeature(classRoom: classRoom, teacher: glb.teacher))

    ],);
  }

  Widget getWorks(BuildContext context , ClassRoom classRoom) {

    return StreamBuilder(
      stream: workStream(context, classRoom, glb.teacher.schoolID),

      builder: (context , snapshot){

        if (!snapshot.hasData || snapshot.data == null)
        {
          return CupertinoActivityIndicator();
        }

        if(snapshot.data.docs.length == 0)
        {
          return Center(
            child: Text("No works assigned" ,
              style: GoogleFonts.varelaRound(color: CupertinoColors.inactiveGray),));
        }

        return ListView.builder(
          itemCount: snapshot.data.docs.length,
          physics: phy, padding: ei, scrollDirection: ax, shrinkWrap: swrap,
          itemBuilder: (BuildContext context, index) {
            WorkTeacher workTeacher = WorkTeacher(snapshot.data.docs[index]);
            return workSelector(context, workTeacher , classRoom);
          },);
      },);
  }


  Widget workSelector (BuildContext context , WorkTeacher workTeacher , ClassRoom classRoom) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, CupertinoPageRoute(
            builder: (context) =>  TeacherWorkViewUI(workTeacher: workTeacher, classRoom: classRoom) ) );
      },
      child: workCard(context, workTeacher.work),
    );
  }

  @override
  Widget build(BuildContext context) {
    return workUI(context, widget.classRoom);
  }
}