import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:slate_data/slate_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:slate/ui/student ui/StudentClassRoomUI.dart';
import 'package:slate/ui/teacher ui/TeacherClassRoomUI.dart';
import 'package:slate_entity_models/slate_entity_models.dart';

import 'package:slate_notifications/slate_notifications.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:slate/globals/globals.dart' as glb;
import 'package:slate/main.dart';

class NotifyService {

  Future<void> init() async {

    final AndroidInitializationSettings androidInitializationSettings = AndroidInitializationSettings(
        'app_icon');

    final InitializationSettings initializationSettings = InitializationSettings(
        android: androidInitializationSettings,
        iOS: null,
        macOS: null
    );

    flutterLocalNotificationsPlugin.initialize(initializationSettings ,
        onSelectNotification: selectNotification);

  }

}

Future selectNotification(String payload) async {

  print("select notification : " + payload);

  if(glb.isTeacher == false)
    {
      MyApp.navigatorKey.currentState.push( CupertinoPageRoute(
          builder: (context) =>  navigateStudentClassRoom(payload) ));
    }
  else
    {
      MyApp.navigatorKey.currentState.push( CupertinoPageRoute(
          builder: (context) =>  navigateTeacherClassRoom(payload) ));
    }

}

Widget navigateStudentClassRoom (String classID){
  return FutureBuilder(
    future: getClassRoom(classID, glb.student.schoolID),
    builder: (context , AsyncSnapshot<DocumentSnapshot> doc ) {
      if(doc.data!= null)
        {
          ClassRoom cr = ClassRoom.student(doc.data);
          return StudentClassRoomUI(classRoom: cr);
        }
      else
        {
          return Scaffold(body: Center(child: CupertinoActivityIndicator() ) );
        }
    },
  );
}

Widget navigateTeacherClassRoom (String classID){
  return FutureBuilder(
    future: getClassRoom(classID, glb.teacher.schoolID),
    builder: (context , AsyncSnapshot<DocumentSnapshot> doc){
      if(doc.data != null)
        {
          ClassRoom cr = ClassRoom.instructor(doc.data);
          print(cr.className);
          return TeacherClassRoomUI(classRoom: cr);
        }
      else
        {
          return Scaffold(body: Center(child: CupertinoActivityIndicator() ));
        }
  },
  );
}