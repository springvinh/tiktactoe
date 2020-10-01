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
      body: SafeArea(
        child: Column(
          children: [
            Container(
              child: SizedBox(
                height: 200.0,
              ),
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
                                // if(roomData['turn'] % 2 == 0) {

                                //   Get.find<GameController>().database.child('Room/$roomId/gameboard/$index/').update({
                                //     'state': 1
                                //   }).then((value) => {
                                    
                                //     Get.find<GameController>().database.child('Room/$roomId/').update({
                                //       'turn': roomData['turn'] + 1
                                //     })

                                //   });

                                // } else {

                                //   Get.find<GameController>().database.child('Room/$roomId/gameboard/$index/').update({
                                //     'state': 2
                                //   }).then((value) => {
                                    
                                //     Get.find<GameController>().database.child('Room/$roomId/').update({
                                //       'turn': roomData['turn'] + 1
                                //     })

                                //   });

                                // }


                                // int x = (index % 20);
                                // int y = (index / 20).floor();
                                // print(x);
                                // print(y);
                                // setState(() {
                                //   // cells[index] = true;
                                // });
                              },
                              child: Container(
                                margin: EdgeInsets.all(1.0),
                                color: Color.fromARGB(10, 0, 0, 0),
                                // color: cells[index]['state'] == 0 ? Color.fromARGB(10, 0, 0, 0) : cells[index]['state'] == 1 ? Colors.red : Colors.blue,
                                child: Center(
                                  child: cells[index]['state'] == 0 ? null : cells[index]['state'] == 1 ? Text('X', style: TextStyle(color: Colors.red),) : Text('O', style: TextStyle(color: Colors.blue)),
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