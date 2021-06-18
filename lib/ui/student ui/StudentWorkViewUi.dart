import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:slate_constants/slate_constants.dart';
import 'package:slate_entity_models/slate_entity_models.dart';
import 'package:slate_element_models/slate_element_models.dart';
import 'package:slate_ui_elements/slate_ui_elements.dart';
import 'package:slate_ui_features/slate_ui_features.dart';

import 'package:slate/globals/globals.dart' as glb;

class StudentWorkViewUI extends StatefulWidget{

  final WorkStudent workStudent;
  final ClassRoom classRoom;
  StudentWorkViewUI({Key key , @required this.workStudent , @required this.classRoom }):super(key: key);


  @override
  State<StatefulWidget> createState() {
    //  implement createState
    return _StudentWorkViewUI();
  }
}

class _StudentWorkViewUI extends State<StudentWorkViewUI> {

  Widget workViewUI (BuildContext context , WorkStudent workStudent){

    return Scaffold(
      backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: BackButton(color: CupertinoColors.activeBlue,),
          title: Text("# "+widget.classRoom.className,
              style: GoogleFonts.varelaRound(color: Colors.black , fontSize: W(3.5) )),
        ),
        body: SingleChildScrollView(physics: ClampingScrollPhysics(),
          child: Column(children: [

            Padding(padding: EdgeInsets.only(top: H(5) , bottom: H(2)) ,
                child: workTitle(context, workStudent.work) ) ,

            Padding(padding: EdgeInsets.only(top: H(1) , bottom: H(3)) ,
                child: workContent(context, workStudent.work) ) ,

            Padding(padding: EdgeInsets.only(left: W(6) , right: W(6)),
              child: Container(color: Colors.black, height: H(0.2),),),

            Padding(padding: EdgeInsets.only(top: H(5) , bottom: H(1)) ,
                child: SubmissionStudentFeature(classRoom: widget.classRoom,
                    student: glb.student, workStudent: workStudent) ),

          ],),)
    );
  }

  @override
  Widget build(BuildContext context) {
    //  implement build
    return workViewUI(context, widget.workStudent);
  }

}

