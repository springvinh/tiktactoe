import 'dart:ui';

import 'package:caro/controllers/GameController.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';

class GameBoard extends StatefulWidget {

  final String uid;
  final String username;

  GameBoard({Key key, @required this.uid, @required this.username}) : super(key: key);

  @override
  _GameBoardState createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {

  int roomId;

  void initState() {
    super.initState();
    Get.lazyPut<GameController>(() => GameController());
    Get.find<GameController>().configDatabaseGame(widget.uid, widget.username);
    roomId =  Get.find<GameController>().roomId.value;

  }

  void dispose() {
    // print('dis');
    super.dispose();
  }

  Widget build(BuildContext context) {

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: Text('$roomId', style: TextStyle(color: Colors.black),),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(left: 24.0, right: 24.0, top: 24.0, bottom: 24.0),
              color: Colors.white,
              child: StreamBuilder(
                stream: Get.find<GameController>().database.child('Room/$roomId/player').onValue,
                builder: (context, snapshot) {

                  if(!snapshot.hasData) {
                    return Container();
                  }

                  Map<dynamic, dynamic> players = snapshot.data.snapshot.value;
                  print(players);

                  return Row(
                    children: [
                      Column(
                        children: [
                          Image.asset('assets/images/icons8-multiply-96.png', scale: 2.0,),
                          SizedBox(height: 15.0),
                          Text(players['player1']['username'], style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold),)
                        ],
                      ),
                      Spacer(),
                      Row(
                        children: [
                          Text(players['player1']['score'].toString(), style: TextStyle(fontSize: 56.0, fontWeight: FontWeight.bold, color: Colors.red),),
                          Container(
                            height: 25.0,
                            width: 1.0,
                            margin: EdgeInsets.only(left: 25.0, right: 25.0),
                            color: Colors.black,
                          ),
                          Text(players['player2']['score'].toString(), style: TextStyle(fontSize: 56.0, fontWeight: FontWeight.bold, color: Colors.blue)),
                        ],
                      ),
                      Spacer(),
                      Column(
                        children: [
                          Image.asset('assets/images/icons8-circle-96.png', scale: 2.0,),
                          SizedBox(height: 15.0),
                          Text(players['player2']['username'] == null ? 'NULL' : players['player2']['username'], style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold),)
                        ],
                      )
                    ],
                  );
                }
              )
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(left: 24.0, right: 24.0, bottom: 24.0),
                color: Colors.white,
                child: Center(
                  child: NotificationListener<OverscrollIndicatorNotification>(
                    onNotification: (overscroll) {
                      overscroll.disallowGlow();
                    },
                    child: StreamBuilder(
                      stream: Get.find<GameController>().database.child('Room/$roomId').onValue,
                      builder: (context, snapshot) {

                        if(!snapshot.hasData) {
                          return Container();
                        }


                        Map<dynamic, dynamic> roomData = snapshot.data.snapshot.value;
                        List<dynamic> cells = roomData['gameboard'];
                        // print(roomData['player']['player2']);

                        return GridView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 20*20,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 20),
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () async {

                                Get.find<GameController>().updateCellState(roomData, index);
                                
                              },
                              child: Container(
                                margin: EdgeInsets.all(1.0),
                                color: Color.fromARGB(10, 0, 0, 0),
                                child: Center(
                                  // child: cells[index]['state'] == 0 ? null : cells[index]['state'] == 1 ? Text('$index', style: TextStyle(color: Colors.red),) : Text('$index', style: TextStyle(color: Colors.blue),),
                                  child: cells[index]['state'] == 0 ? null : cells[index]['state'] == 1 ? Image.asset('assets/images/icons8-multiply-96.png', scale: 4.0,) : Image.asset('assets/images/icons8-circle-96.png', scale: 4.0,),
                                ),
                              ),
                            );
                          },
                        );
                      }
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      )
    );
  }
}