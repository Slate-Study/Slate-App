import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:flushbar/flushbar.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:slate_constants/slate_constants.dart';
import 'package:slate_entity_models/slate_entity_models.dart';
import 'package:slate_element_models/slate_element_models.dart';
import 'package:slate_data/slate_data.dart';
import 'package:slate_ui_elements/slate_ui_elements.dart';

import 'package:slate/globals/globals.dart' as glb;


class TeacherChatUI extends StatefulWidget{

  final ClassRoom classRoom;
  TeacherChatUI({Key key ,  @required this.classRoom }):super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TeacherChatUI();
  }
}

class _TeacherChatUI extends State<TeacherChatUI>{

  TextEditingController newMessage = new TextEditingController();

  Widget chatUI (BuildContext context , ClassRoom classRoom) {

    return Padding( padding: EdgeInsets.only(left: W(3) , right: W(3)),
      child: Column(children: [

        Expanded(child: ListView(
          padding: EdgeInsets.only(bottom: H(3) , top: H(5)),
          reverse: true,
          children: [
            chatStream(context, classRoom)
          ],
        )),

        ClipRRect(
            borderRadius: BorderRadius.circular(W(2)),
            child: Container(
              margin: EdgeInsets.only(left: W(0.5), right: W(0.5) , bottom: H(2.5) , top: H(2)),
              decoration: writeDecoration,
              child: newMessages(context , classRoom),
            )
        ),

      ],),
    );
  }

  Widget chatStream(BuildContext context , ClassRoom classRoom)
  {
    return StreamBuilder(
      stream: messageStream(context, classRoom, glb.teacher.schoolID),
      builder: (context , snapshot){
        if (!snapshot.hasData || snapshot.data == null)
        {
          return CupertinoActivityIndicator();
        }
        if(snapshot.data.docs.length == 0)
        {
          return Center(
              child: Text("Send your first message" ,
                style: GoogleFonts.varelaRound(color: CupertinoColors.inactiveGray),));
        }
        return ListView.builder(
          itemCount: snapshot.data.docs.length,
          physics: phy, scrollDirection: ax, shrinkWrap: swrap,
          itemBuilder: (BuildContext context, index) {

            Message m1 = Message(snapshot.data.docs[index] , glb.teacher.teacherUid);
            return chatMessageBubble(context, m1);

          },);
      },);
  }


  Widget newMessages(BuildContext context , ClassRoom classRoom){

    return Row(children: [

      Padding(padding: EdgeInsets.only(left: W(5) , right: W(2) , top: H(2) , bottom: H(2)),
        child: Container(
          width: W(72),
          decoration: BoxDecoration(border: Border.all(color: Color(0xd91a233a) , width: W(0.2)),
              borderRadius: BorderRadius.circular(W(1))),
          child: CupertinoTextField(
            maxLines: null,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(W(4))),
            controller: newMessage,
            placeholder: "Message  # ${classRoom.className}",
          ),
        ),
      ),

      Material(
        color: CupertinoColors.white,
        child: IconButton(
            padding: EdgeInsets.zero, color: CupertinoColors.activeBlue, iconSize: W(8), icon: Icon(Icons.send_rounded),
            onPressed: (){
              onSendPressed(context,classRoom);
            }
        ),
      )
    ],);
  }

  void onSendPressed(BuildContext context , ClassRoom classRoom) {
    String _newMessage = newMessage.text;
    if(_newMessage.isNotEmpty && _newMessage != "" && _newMessage != null)
    {
      sendMessage(context, _newMessage , classRoom);
      setState(() {
        newMessage.clear();
        _newMessage = "";
      });
    }
    else
    {
      Flushbar(
        message: "Empty message",
        duration:  Duration(seconds: 1),
        icon: Icon(CupertinoIcons.textbox),
      )..show(context);
    }
  }

  void sendMessage ( BuildContext context , String mText , ClassRoom classRoom){
    Message mNew = Message.newMessage(glb.teacher.teacherUid , glb.teacher.name , mText , DateTime.now());
    publishMessage(mNew, classRoom, glb.teacher.schoolID);
  }


  @override
  Widget build(BuildContext context) {
    return chatUI(context, widget.classRoom);
  }
}