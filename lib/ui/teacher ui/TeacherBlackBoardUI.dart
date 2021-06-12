import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flushbar/flushbar.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:slate_constants/slate_constants.dart';
import 'package:slate_data/slate_data.dart';
import 'package:slate_file_services/slate_file_services.dart';
import 'package:slate_ui_elements/slate_ui_elements.dart';
import 'package:slate_element_models/slate_element_models.dart';
import 'package:slate_entity_models/slate_entity_models.dart';

import 'package:slate/globals/globals.dart' as glb;


class TeacherBlackBoardUI extends StatefulWidget{

  final ClassRoom classRoom;
  TeacherBlackBoardUI({Key key , @required this.classRoom }):super(key:key);

  @override
  State<StatefulWidget> createState() {
    return _TeacherBlackBoardUI();
  }
}

class _TeacherBlackBoardUI extends State<TeacherBlackBoardUI> {

  PlatformFile file;
  FilePickerResult result;
  String fName = " ";
  num fType;
  TextEditingController newTextPost = TextEditingController();
  String _newTextPost;
  double _progress = 0;

  Widget blackBoard (BuildContext context , ClassRoom classRoom) {

    return ListView(children: [

      Padding(padding: EdgeInsets.only(top: H(3) , bottom: H(1.5) , left: W(4) , right: W(4)) ,
          child: addPost(context, classRoom)),

      Padding(padding: EdgeInsets.only(left: W(6),right: W(6) , bottom: H(0.2)),
          child: Container(height: H(4),
            child: FittedBox(fit: BoxFit.scaleDown,child: SizedBox(
            child: Text(fName),)
          ),)),

      Padding(padding: EdgeInsets.only(left: W(5) , right: W(5) , bottom: H(1)),
        child: LinearProgressIndicator(backgroundColor: Colors.grey[50],
          value: _progress,),),

      Padding(padding: EdgeInsets.only(top: H(3)) ,
          child: getPosts(context, classRoom))

    ],);
  }

  Widget addPost(BuildContext context , ClassRoom classRoom ){

    return ClipRRect(
      borderRadius: BorderRadius.circular(W(2)),

      child: Container(
          margin: EdgeInsets.only(left: W(1), right: W(1) , bottom: H(2) , top: H(2)),
          decoration: writeDecoration,

        child: Column(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment:CrossAxisAlignment.center,children: [

          Row(crossAxisAlignment: CrossAxisAlignment.start,children: [

            Padding(padding: EdgeInsets.only(left: W(1) , right: W(1) , top: H(1)),
                child: Container(width: W(10) , height: H(10) ,child: Material(color: Colors.white ,child: IconButton(icon: Icon(CupertinoIcons.add) , iconSize: W(8),
                    color: Color(0xd91a233a),
                    onPressed: ( ){
                      showDialog( context: context,
                          barrierDismissible: true,
                          builder: (context) => selectFileType(context, classRoom)
                      );
                    }),),
                )) ,

            Expanded(child: Padding( padding: EdgeInsets.only(top: H(3) , bottom: H(3)),
                child: Container(
                    child: CupertinoTextField(controller: newTextPost , maxLines: null, placeholder: "write # ${classRoom.className}",
                      decoration: BoxDecoration( border: Border.all(color: Color(0xd91a233a) , width: W(0.2)) ,
                          borderRadius: BorderRadius.circular(W(1))),
                    ) ))) ,

            Padding(padding: EdgeInsets.only(left: W(2) , top: H(3) , right: W(2.5)) ,
              child: Container(height: H(8.5) , width: W(20) ,child: ElevatedButton(child: Text("Write") ,
                style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>( CupertinoColors.activeBlue )),
                onPressed: (){
                  setState(() {
                    _newTextPost = newTextPost.text;
                    onCreate();
                    newTextPost.clear(); fName = ""; result = null;
                    FocusScope.of(context).unfocus();
                  });
                },),),)

          ],),

        ],)
      ));
  }

  Widget selectFileType (BuildContext context , ClassRoom classRoom){
    return AlertDialog(

      content: Padding(padding: EdgeInsets.only(top: H(4),bottom: H(4)) ,child: Row(children: [
        Padding(padding: EdgeInsets.only(left: W(1) , right: W(2.5)) ,
            child: Material(color: Colors.white ,child: IconButton(iconSize: W(14),
                icon: Icon(CupertinoIcons.photo ), onPressed: (){

                  _openFileExplorer('jpg');
                  Navigator.of(context, rootNavigator: true).pop('dialog');

                }),)) ,

        Padding(padding: EdgeInsets.only(left: W(2.5) , right: W(2.5)) ,
            child: Material(color: Colors.white ,child: IconButton(iconSize: W(14),
                icon: Icon(CupertinoIcons.videocam_circle_fill), onPressed: (){

                  _openFileExplorer('mp4');
                  Navigator.of(context, rootNavigator: true).pop('dialog');

                }),)) ,

        Padding(padding: EdgeInsets.only(left: W(2.5) , right: W(1)) ,
            child: Material(color: Colors.white ,child: IconButton(iconSize: W(14),
                icon: Icon(CupertinoIcons.arrow_up_doc), onPressed: (){

                  _openFileExplorer('pdf');
                  Navigator.of(context, rootNavigator: true).pop('dialog');

                }),)) ,

      ],),),);
  }

  Widget getPosts(BuildContext context , ClassRoom classRoom) {

    return StreamBuilder(
      stream: postsStream(context, classRoom, glb.teacher.schoolID),

      builder: (context , snapshot){

        if (!snapshot.hasData || snapshot.data == null)
        {
          return CupertinoActivityIndicator();
        }

        if(snapshot.data.docs.length == 0)
        {
          return Center(
              child: Text("No posts yet" ,
                style: GoogleFonts.varelaRound(color: CupertinoColors.inactiveGray),));
        }

        return ListView.builder(

          itemCount: snapshot.data.docs.length,
          physics: phy, padding: ei, scrollDirection: ax, shrinkWrap: swrap,
          itemBuilder: (BuildContext context, index) {

            return postType(context, snapshot.data.docs[index]);

          },
        );
      },
    );
  }

  Widget postType (BuildContext context , DocumentSnapshot doc) {

    int x;
    Map _data = doc.data();
    if(_data["postFile"] != null)
    {
      List f = _data["postFile"].split(".");
      String ext = f[f.length - 1];

      if (ext == "jpg" || ext == "jpeg" || ext == "png")
      {
        x = 2;
      }
      else if (ext == "mp4")
      {
        x = 3;
      }
      else if(ext == "pdf")
      {
        x = 4;
      }
    }
    else
    {
      x = 1;
    }

    switch (x)
    {
      case 1 :
        PostText p1 = PostText(doc);
        return textPost(context, p1);

      case 2:
        PostFile p2 = PostFile(doc);
        return imagePost(context, p2);

      case 3:
        PostFile p3 = PostFile(doc);
        return videoPost(context, p3);

      case 4:
        PostFile p4 = PostFile(doc);
        return pdfPost(context, p4);

      default:
        PostText pX = PostText(doc);
        return textPost(context, pX);
    }
  }


  void onCreate () async {

    String folder , docPath , fileName;
    List extensions;
    PlatformFile fileX;
    DateTime dt = DateTime.now();
    String _fName;
    bool uL = true;

    if(result != null)
    {
      fileX = result.files.first;
      fileName = fileX.name;
      extensions = fileName.split('.');
      _fName = dt.day.toString().padLeft(2,'0') + dt.month.toString().padLeft(2,'0') + dt.hour.toString().padLeft(2,'0')
          + dt.minute.toString().padLeft(2,'0') + fileName;

      if(extensions.last == "jpg" || extensions.last == "jpeg" || extensions.last == "png") {
        folder = "images";
        docPath = "/" + glb.teacher.schoolID + "/" + widget.classRoom.classID +
            "/" + "posts" + "/" + folder + "/" + _fName;
      }

      else if(extensions.last == "mp4") {
        folder = "videos";
        docPath = "/" + glb.teacher.schoolID + "/" + widget.classRoom.classID +
            "/" + "posts" + "/" + folder + "/" + _fName;
      }

      else if(extensions.last == "pdf") {
        folder = "docs";
        docPath = "/" + glb.teacher.schoolID + "/" + widget.classRoom.classID +
            "/" + "posts" + "/" + folder + "/" + _fName;
      }
      else{
        uL = false;
      }

      if(_newTextPost != "" && _newTextPost != null)
      {

        if(uL)
        {
          UploadTask ut =  postFileUpload(result.files.first, widget.classRoom, folder , _fName , glb.teacher);

          ut.snapshotEvents.listen((event) {
            setState(() {
              _progress = event.bytesTransferred.toDouble() /
                  event.totalBytes.toDouble();
              if(_progress == 1.0)
              {
                _progress = 0;
              }
            });
          });

          ut.whenComplete(() {
            PostFile newPostFile = PostFile.newPost(_newTextPost, docPath, glb.teacher);
            createFilePost(widget.classRoom, newPostFile, glb.teacher);
          });

        }
        else
        {
          Flushbar(
            message: "Invalid file format",
            duration:  Duration(seconds: 1),
            icon: Icon(CupertinoIcons.textbox),
          )..show(context);
        }

      }
      else
      {
        print("here X");
        Flushbar(
          message: "Post text is empty",
          duration:  Duration(seconds: 1),
          icon: Icon(CupertinoIcons.textbox),
        )..show(context);
      }

    }
    else
    {
      if(_newTextPost != "" && _newTextPost != null)
      {
        PostText newPostText = PostText.newPost(_newTextPost, glb.teacher);
        createTextPost(widget.classRoom, newPostText , glb.teacher);
      }
      else
      {
        print("here Y");
        Flushbar(
          message: "Post text is empty",
          duration:  Duration(seconds: 1),
          icon: Icon(CupertinoIcons.textbox),
        )..show(context);
      }
    }
  }


  void _openFileExplorer(String fT) async {

    result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: [fT],
    );

    if(result != null)
    {
      file = result.files.first;
      setState(() {
        fName = file.name;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return blackBoard(context, widget.classRoom);
  }
}