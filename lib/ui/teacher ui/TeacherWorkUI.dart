import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:slate_constants/slate_constants.dart';
import 'package:slate_entity_models/slate_entity_models.dart';
import 'package:slate_element_models/slate_element_models.dart';
import 'package:slate_data/slate_data.dart';
import 'package:slate_ui_elements/slate_ui_elements.dart';

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
          child: newAssignment(context , classRoom))

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

  Widget newAssignment (BuildContext context , ClassRoom classRoom){

    return FloatingActionButton.extended(
        onPressed: () {
          showDialog( context: context,
              barrierDismissible: true,
              builder: (context) => newAssignmentCreation(context , classRoom)
          );
        },
        label: Text('Create', style: GoogleFonts.varelaRound(),),
        icon: Icon(CupertinoIcons.plus_app),
        backgroundColor: Color(0xe61a233a)
    );
  }

  Widget newAssignmentCreation (BuildContext context , ClassRoom cr) {

    TextEditingController title = TextEditingController();
    TextEditingController content = TextEditingController();

    String _title; String _content;

    return AlertDialog(

      title: Text("Create New Assignment" , style: GoogleFonts.varela(),),

      content: Container(width: W(72) , child: Column(mainAxisSize: MainAxisSize.min ,children: [

        Padding(padding: EdgeInsets.only(top: H(3) , bottom: H(3)) , child: Container(height: H(8),
            child: CupertinoTextField( controller: title, placeholder: "Task title" ))),

        Container( child: CupertinoTextField(
          controller: content, placeholder: "Task description" , maxLines: null,
        )),

      ])),

      actions: [
        Padding(padding: EdgeInsets.only(top: H(3) , bottom: H(3)) , child: Container(height: H(8), width: W(22),
            child: ElevatedButton(child: Text("Create" , style: GoogleFonts.varela(color: Colors.black),) ,
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>( CupertinoColors.activeBlue )),
              onPressed: () async {

                _title = title.text; _content = content.text;

                if(_title != "" && _content != "")
                {
                  WorkTeacher nWork = WorkTeacher.createWork(_title, _content, cr.students);
                  createWork(nWork, cr, glb.teacher);

                  Navigator.of(context, rootNavigator: true).pop('dialog');
                }
                else
                {
                  Navigator.of(context, rootNavigator: true).pop('dialog');
                }
              },)),)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return workUI(context, widget.classRoom);
  }
}