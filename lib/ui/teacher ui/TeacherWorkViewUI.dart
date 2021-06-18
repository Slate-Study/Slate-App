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

class TeacherWorkViewUI extends StatefulWidget{

  final WorkTeacher workTeacher;
  final ClassRoom classRoom;
  TeacherWorkViewUI({Key key , @required this.workTeacher , @required this.classRoom }):super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TeacherWorkViewUI();
  }
}

class _TeacherWorkViewUI extends State<TeacherWorkViewUI> {

  Widget workViewUI (BuildContext context , WorkTeacher workTeacher){

    return Scaffold(
      backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: BackButton(color: CupertinoColors.activeBlue,),
          title: Text("# " + widget.classRoom.className,
              style: GoogleFonts.varelaRound(color: Colors.black , fontSize: W(3.5) )),
        ),
        body : Column(children: [

          Padding(padding: EdgeInsets.only(top: H(5) , bottom: H(2)) ,
              child: Row(children: [
                Expanded(child: workTitle(context, workTeacher.work) ),
                statusChanger(context , workTeacher)
              ],) ) ,

          Padding(padding: EdgeInsets.only(top: H(1) , bottom: H(3)) ,
              child: workContent(context, workTeacher.work) ) ,

          Padding(padding: EdgeInsets.only(left: W(6) , right: W(6)),
            child: Container(color: Colors.black, height: H(0.2),),),

          SubmissionTeacherFeature(classRoom: widget.classRoom,
              teacher: glb.teacher, workTeacher: workTeacher)

        ],)
    );
  }

  Widget statusChanger (BuildContext context , WorkTeacher workTeacher)
  {
    return Padding(padding: EdgeInsets.only(right: W(5)) ,
      child: Material(color: CupertinoColors.white,
        child: Switch(
            value: workTeacher.work.isActive,
            onChanged: (value)
            {
              setState(() {
                workTeacher.work.isActive = value;
                updateWorkStatus(widget.classRoom, workTeacher, glb.teacher);
              });
            }
        ),),);
  }

  @override
  Widget build(BuildContext context) {
    return workViewUI(context, widget.workTeacher);
  }

}