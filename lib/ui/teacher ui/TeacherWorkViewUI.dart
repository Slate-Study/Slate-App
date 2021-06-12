import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:slate_constants/slate_constants.dart';
import 'package:slate_entity_models/slate_entity_models.dart';
import 'package:slate_element_models/slate_element_models.dart';
import 'package:slate_data/slate_data.dart';
import 'package:slate_ui_elements/slate_ui_elements.dart';

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

          Expanded(child: ListView(padding: EdgeInsets.zero, children: [

            Padding(padding: EdgeInsets.only(left: W(6) , right: W(4) , top: H(5)) ,
                child: submittedStudents(context, workTeacher) ),

            Padding(padding: EdgeInsets.only(left: W(6) , right: W(4) , top: H(2)) ,
                child: notSubmittedStudents(context, workTeacher) ),

          ],))
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

  Widget submittedStudents (BuildContext context , WorkTeacher workTeacher){

    return Column(crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Padding(padding: EdgeInsets.only(bottom: H(2)) ,
            child: Text("Submitted : " , style: GoogleFonts.varela(fontWeight: FontWeight.bold),)),

        Row(children: [

          Padding(padding: EdgeInsets.only(right: W(5)) ,
              child: Container(width: W(18),height: H(8),
                child: Text("Roll No." , style: TextStyle(fontSize: W(2.7)),),) ),

          Expanded(child: Container(height: H(8),
            child: Text("Name" , style: TextStyle(fontSize: W(2.7)) ),) ),

          Padding(padding: EdgeInsets.only(left: W(2),right: W(6)) ,
              child: Container(width: W(18),height: H(8),
                child: Text("Submission" , style: TextStyle(fontSize: W(2.7))),) )

        ],),

        submittedStudentsBuilder(context, workTeacher)

      ],);
  }

  Widget submittedStudentsBuilder (BuildContext context , WorkTeacher w){

    return ListView.builder(

      itemCount: w.studentsSub.length,
      physics: phy, padding: ei, scrollDirection: ax, shrinkWrap: swrap,

      itemBuilder: (BuildContext context ,int index) {
        String sID = w.studentsSub.keys.elementAt(index);
        StudentSubmission studentS = w.studentsSub[sID];

        if(studentS.isSubmitted == true)
        {
          return FutureBuilder(
            future: getStudentData(sID, glb.teacher),
            builder: (context , AsyncSnapshot<List> _stData) {
              if(_stData.data != null)
              {
                List stData = _stData.data;
                return Row(crossAxisAlignment: CrossAxisAlignment.start ,children: [

                  Padding(padding: EdgeInsets.only(right: W(5)) ,
                      child: Container(width: W(18),height: H(8),alignment: Alignment.centerLeft,
                        child: Text(stData[0] , style: TextStyle(fontSize: W(3.2)),),) ),

                  Expanded(child: Container(height: H(8), alignment: Alignment.centerLeft,
                    child: Text(stData[1] , style: TextStyle(fontSize: W(3.2)) ),) ),

                  Padding(padding: EdgeInsets.only(left: W(2),right: W(6)) ,
                      child: Container(width: W(18),height: H(8),alignment: Alignment.centerLeft,
                        child: Material(color: Colors.white,
                          child: IconButton(icon: Icon(CupertinoIcons.doc_text_fill),
                            color: CupertinoColors.systemBlue,
                            onPressed: (){

                              Navigator.of(context, rootNavigator: true).push(CupertinoPageRoute(
                                  builder: (context) => submittedDoc(context, studentS )));

                            },),
                        ) ,) )
                ],);
              }
              else
              {
                return CupertinoActivityIndicator();
              }
            });
        }
        else
        {
          return Container(width: 0 , height: 0,);
        }
      });
  }


  Widget notSubmittedStudents (BuildContext context , WorkTeacher workTeacher){

    return Column(crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Padding(padding: EdgeInsets.only(bottom: H(2)) ,
            child: Text("Yet to Submit : " , style: GoogleFonts.varela(fontWeight: FontWeight.bold),)),

        Row(children: [

          Padding(padding: EdgeInsets.only(right: W(5)) ,
              child: Container(width: W(18),height: H(8),
                child: Text("Roll No." , style: TextStyle(fontSize: W(2.7)),),) ),

          Expanded(child: Container(height: H(8),
            child: Text("Name" , style: TextStyle(fontSize: W(2.7)) ),) ),

        ],),

        notSubmittedStudentsBuilder(context, workTeacher)
      ],);
  }

  Widget notSubmittedStudentsBuilder (BuildContext context , WorkTeacher w){

    return ListView.builder(

      itemCount: w.studentsSub.length,
      physics: phy, padding: ei, scrollDirection: ax, shrinkWrap: swrap,

      itemBuilder: (BuildContext context ,int index) {
        String sID = w.studentsSub.keys.elementAt(index);
        StudentSubmission studentS =w.studentsSub[sID];

        if(studentS.isSubmitted == false)
        {
          return FutureBuilder(
            future: getStudentData(sID, glb.teacher),
            builder: (context , AsyncSnapshot<List> _stData) {
              if(_stData.data != null)
              {
                List stData = _stData.data;
                return Row(crossAxisAlignment: CrossAxisAlignment.start ,children: [

                  Padding(padding: EdgeInsets.only(right: W(5)) ,
                      child: Container(width: W(18),height: H(8),alignment: Alignment.centerLeft,
                        child: Text(stData[0] , style: TextStyle(fontSize: W(3.2)),),) ),

                  Expanded(child: Container(height: H(8), alignment: Alignment.centerLeft,
                    child: Text(stData[1] , style: TextStyle(fontSize: W(3.2)) ),) ),

                ],);
              }
              else
              {
                return CupertinoActivityIndicator();
              }
            },);
        }
        else
        {
          return Container(width: 0 , height: 0,);
        }
      },);
  }

  Widget submittedDoc (BuildContext context , StudentSubmission std){

    List f = std.subFile.split(".");
    String ext = f[f.length - 1];

    if(ext == "pdf")
    {
      return submittedPDF(context, std.subFile);
    }
    else if (ext == "jpg" || ext == "jpeg" || ext == "png")
    {
      return submittedImage(context, std.subFile);
    }
    else
    {
      return CupertinoPageScaffold(child: Center(child: Text("Invalid File format") ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return workViewUI(context, widget.workTeacher);
  }

}