import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:slate_constants/slate_constants.dart';
import 'package:slate_entity_models/slate_entity_models.dart';
import 'package:slate_element_models/slate_element_models.dart';
import 'package:slate_data/slate_data.dart';
import 'package:slate_ui_elements/slate_ui_elements.dart';

import 'package:slate/globals/globals.dart' as glb;
import 'package:slate/ui/student ui/StudentWorkViewUI.dart';


class StudentWorkUI extends StatefulWidget{

  final ClassRoom classRoom;
  StudentWorkUI({Key key ,  @required this.classRoom }):super(key: key);

  @override
  State<StatefulWidget> createState() {
    //  implement createState
    return _StudentWorkUI();
  }
}

class _StudentWorkUI extends State<StudentWorkUI> {

  Widget workUI (BuildContext context , ClassRoom classRoom)
  {
    return ListView(children: [

      Padding(padding: EdgeInsets.only(top: H(3)) ,
          child: getWorks(context, classRoom))

    ],);
  }

  Widget getWorks(BuildContext context , ClassRoom classRoom) {

    return StreamBuilder(
      stream: workStream(context, classRoom, glb.student.schoolID),

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
            WorkStudent workStudent = WorkStudent(snapshot.data.docs[index], glb.student);
            return workSelector(context, workStudent , classRoom);
          },);
      },);
  }


  Widget workSelector (BuildContext context , WorkStudent workStudent , ClassRoom classRoom) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, CupertinoPageRoute(
            builder: (context) => StudentWorkViewUI(workStudent: workStudent, classRoom: classRoom)  ) );
      },

      child: workCard(context, workStudent.work),
    );
  }

  @override
  Widget build(BuildContext context) {
    //  implement build
    return workUI(context, widget.classRoom);
  }
}