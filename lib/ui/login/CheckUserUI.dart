import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:slate_login/slate_login.dart';
import 'package:slate_entity_models/slate_entity_models.dart';
import 'package:slate_notifications/slate_notifications.dart';

import 'package:slate/ui/login/LoginScreenUI.dart';
import 'package:slate/ui/student ui/StudentHomeUI.dart';
import 'package:slate/ui/teacher ui/TeacherHomeUI.dart';

import 'package:slate/globals/globals.dart' as glb;

Widget checkUserUi (BuildContext context) {

  String uID = checkLogin(context);
  if(uID != "X")
  {
    return redirectUser(context, uID);
  }
  else
  {
    return LoginUI();
  }
}

Widget redirectUser (BuildContext context , String id) {
  return FutureBuilder(
    future: getUserType(id),
    builder: (context , AsyncSnapshot<num> ut){
      if(ut.data == 0) {
        glb.student = Student.identify(id);
        return createStudent(context);
      }
      else if (ut.data == 1) {
        glb.teacher = Teacher.identify(id);
        return createTeacher(context);
      }
      else
        {
          return CupertinoPageScaffold(child: Center(
              child: CupertinoActivityIndicator() ));
        }

    },
  );
}


Widget createStudent (BuildContext context) {
  return FutureBuilder(
    future: getStudentBasicData(glb.student.studentUid),
    builder: (context , AsyncSnapshot<DocumentSnapshot> doc1) {

      if(doc1.data!= null)
        {
          glb.student.basicData(doc1.data);
          return FutureBuilder(
            future: getStudentFullData(glb.student),
            builder: (context , AsyncSnapshot<DocumentSnapshot> doc2){
              if(doc2.data != null)
                {
                  glb.student.fullData(doc2.data);
                  subscribeToTopic(glb.student.subjectList);
                  glb.isTeacher = false;
                  return StudentHomePage();
                }
              else
                {
                  return CupertinoPageScaffold(child: Center(
                      child: CupertinoActivityIndicator() ));
                }
            },
          );
        }
      else
        {
          return CupertinoPageScaffold(child: Center(
              child: CupertinoActivityIndicator() ));
        }
      },
  );
}


Widget createTeacher (BuildContext context) {

  return FutureBuilder(
    future: getTeacherBasicData(glb.teacher.teacherUid),
    builder: (context , AsyncSnapshot<DocumentSnapshot> doc1) {
      if(doc1.data != null)
        {
          glb.teacher.basicData(doc1.data);
          return FutureBuilder(
            future: getTeacherFullData(glb.teacher),
            builder: (context , AsyncSnapshot<DocumentSnapshot> doc2){
              if(doc2.data != null)
                {
                  glb.teacher.fullData(doc2.data);
                  subscribeToTopic(glb.teacher.subjectList);
                  glb.isTeacher = true;
                  return TeacherHomePage();
                }
              else
                {
                  return CupertinoPageScaffold(child: Center(
                      child: CupertinoActivityIndicator() ));
                }
            },
          );
        }
      else
        {
          return CupertinoPageScaffold(child: Center(
              child: CupertinoActivityIndicator() ));
        }
    },
  );
}