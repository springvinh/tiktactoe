import 'package:caro/controllers/AuthController.dart';
import 'package:caro/models/UserModel.dart';
import 'package:caro/screens/gameboard.dart';
import 'package:caro/screens/joinGameboard.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Home extends GetWidget<AuthController> {

  TextEditingController roomIdController = TextEditingController();

  final database = FirebaseDatabase.instance.reference();

  UserModel userModel;

  Home({Key key, this.userModel}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {

    // TODO: implement build
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.only(left: 24.0, top: 24.0, right: 24.0),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Hello ', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),),
                    Text(userModel.username, style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold, color: Colors.blue),),
                  ],
                ),
              ),
              SizedBox(height: 24.0),
              ClipRRect(
                borderRadius: BorderRadius.circular(5.0),
                child: Container(
                  height: 50.0,
                  color: Color(0xfff5f5f5),
                  child: TextField(
                    controller: roomIdController,
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                      fontWeight: FontWeight.bold
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      suffixIcon: Material(
                        color: Color(0xfff5f5f5),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100.0),
                          child: InkWell(
                            child: Icon(Icons.arrow_forward),
                            onTap: () async {
                              int roomId;

                              roomIdController.text == '' ? roomId = 89374958734 : roomId = int.parse(roomIdController.text);
                              print(roomId);
                              
                              await database.child('Room/$roomId').once().then((value) => {
                                
                                value.value == null ? 
                                  showSnackBar('Room does not exist.')
                                  : value.value['player']['player2']['username'] != null || value.value['player']['player1']['uid'] == userModel.uid ?
                                    showSnackBar('Can\'t join this room.')
                                    : Get.to(JoinGameBoard(uid: userModel.uid, username: userModel.username, roomId: int.parse(roomIdController.text)))

                              });
          
                            },
                          )
                        ),
                      ),
                      contentPadding: EdgeInsets.only(left: 20.0, right: 20.0, top: 15.0, bottom: 0),
                      hintText: 'Enter RoomID',
                      hintStyle: TextStyle(
                        color: Color(0xffdddddd)
                      )
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24.0),
              Expanded(
                child: NotificationListener<OverscrollIndicatorNotification>(
                  // ignore: missing_return
                  onNotification: (overscroll) {
                    overscroll.disallowGlow();
                  },
                  child: StreamBuilder(
                    stream: database.child('RoomList').onValue,
                    builder: (context, snapshot) {
                
                      if(snapshot.hasData) {

                        Map<dynamic, dynamic> roomList = snapshot.data.snapshot.value;
                        List roomKeys = [];
                        
                        if(roomList != null) roomList.forEach((key, value) {

                          roomKeys.add(key);

                        });

                        return snapshot.data.snapshot.value == null ? SizedBox() : ListView.builder(
                          itemCount: snapshot.data.snapshot.value.length == null ? 0 : snapshot.data.snapshot.value.length,
                          itemBuilder: (context, index) {
                            return Material(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(5.0),
                                child: Container(
                                  margin: EdgeInsets.only(bottom: 12.0),
                                  color: Color(0xfff5f5f5),
                                  child: InkWell(
                                    onTap: () {
                                      
                                      roomList[roomKeys[index]]['roomOwner'] == userModel.uid ?
                                      showSnackBar('Can\'t join this room.')
                                      : Get.to(JoinGameBoard(uid: userModel.uid, username: userModel.username, roomId: int.parse(roomKeys[index])));
                                    },
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 60.0,
                                          height: 60.0,
                                          margin: EdgeInsets.only(right: 12.0),
                                          child: Center(child: Text('$index', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),)),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(5.0),
                                            color: Colors.blue
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('${roomList[roomKeys[index]]['roomName']}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                                            SizedBox(height: 5.0,),
                                            Text('ID: ${roomKeys[index]}', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300),),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );

                      }

                      return Container();

                    }
                  ),
                ),
              )
            ],
          )
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.add),
        label: Text('Create room'),
        onPressed: () {
          Get.to(GameBoard(uid: userModel.uid, username: userModel.username,));
        },
      ),
    );
  }
}