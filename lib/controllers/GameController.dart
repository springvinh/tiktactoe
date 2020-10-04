import 'dart:math';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GameController extends GetxController {
  final database = FirebaseDatabase.instance.reference();
  final roomId = Random().nextInt(999999).obs;

  void configDatabaseGame(String uid, String username) async {
    final matrixSize = 20;

    var cells = List<dynamic>.generate(
        matrixSize * matrixSize,
        (index) => {
              'state': 0,
              'index': index,
              'row': (index % matrixSize),
              'column': (index / matrixSize).floor()
            });

    try {

      final database = FirebaseDatabase.instance.reference();

      database.child('Room/$roomId').set({
        'player': {
          'player1': {'uid': uid, 'username': username, 'score': 0},
          'player2': {'score': 0},
        },
        'gameboard': cells,
        'playerTurn': uid,
        'switchTurn': 0,
        'isPlaying': false
      });

      database.child('RoomList/$roomId').set({
          'roomName': 'Room $username',
          'roomOwner': uid,
          'roomID': int.parse('$roomId')
      });

    } catch (error) {
      Get.back();
      showSnackBar(error.message);
    }
  }

  void joinGame(String uid, String username, int joinId) async {

    try {

      database.child('Room/$joinId/player/player2').update({
        'uid': uid,
        'username': username
      }).then((value) => {
        database.child('Room/$joinId').update({
          'isPlaying': true
        })
      });

      database.child('RoomList/$joinId').remove();

    } catch(error) {
      Get.back();
      showSnackBar(error.message);
    }

  }

  void updateCellState(Map<dynamic, dynamic> roomData, int index, int roomId, String uid) {

    if (roomData['gameboard'][index]['state'] == 0 &&
        roomData['isPlaying'] == true) {

      if(roomData['playerTurn'] == uid) {

        if (roomData['switchTurn'] % 2 == 0) {
        
          database.child('Room/$roomId/').update({'switchTurn': roomData['switchTurn'] + 1, 'playerTurn': roomData['player']['player2']['uid']}).then((value) => {
            database.child('Room/$roomId/gameboard/$index/').update({'state': 1}).then((value) => {
              columnCheck(roomData, roomId, index, roomData['gameboard'][index]['column'], roomData['gameboard'][index]['row'], 1),
              rowCheck(roomData, roomId, index, roomData['gameboard'][index]['column'], roomData['gameboard'][index]['row'], 1),
              topLeftToBottomRightCheck(roomData, roomId, index, 1),
              bottomLeftToTopRightCheck(roomData, roomId, index, 1)
            })
          });

        } else {

          database.child('Room/$roomId/').update({'switchTurn': roomData['switchTurn'] + 1, 'playerTurn': roomData['player']['player1']['uid']}).then((value) => {
            database.child('Room/$roomId/gameboard/$index/').update({'state': 2}).then((value) => {
              columnCheck(roomData, roomId, index, roomData['gameboard'][index]['column'], roomData['gameboard'][index]['row'], 2),
              rowCheck(roomData, roomId, index, roomData['gameboard'][index]['column'], roomData['gameboard'][index]['row'], 2),
              topLeftToBottomRightCheck(roomData, roomId, index, 2),
              bottomLeftToTopRightCheck(roomData, roomId, index, 2)
            })
          });

        }

      } else {

        showSnackBar('errorMessage');

      }
        

      // print(roomData['gameboard'][index]['column'].toString() + ' ' + roomData['gameboard'][index]['row'].toString() + ' ' + index.toString());
    }
  }


  void columnCheck(Map<dynamic, dynamic> roomData, int roomId, int index, int column, int row, int value) {
    
    int start = row;
    int end = row;
    int startIndex = index;
    int count = 0;

    if(start - 4 <= 0) {

      for(int i = row; i > 0; i--) {

        startIndex = startIndex - 1;
      } 

    } else {
      startIndex = startIndex - 4;
    }

    start - 4 < 0 ? start = 0 : start = start - 4;
    end + 4 > 19 ? end = 19 : end = end + 4;

    for(int i = start; i <= end; i ++) {

      if(roomData['gameboard'][startIndex]['state'] == value) {

        count = count + 1;

        if(count == 4) {
          database.child('Room/$roomId/player/player$value/').update({
            'score': roomData['player']['player$value']['score'] + 1
          });
        }

      } else {

        count = 0;

      }

      startIndex = startIndex + 1;

    }

  }


  void rowCheck(Map<dynamic, dynamic> roomData, int roomId, int index, int column, int row, int value) {
    
    int start = column;
    int end = column;
    int startIndex = index;
    int count = 0;

    if(start - 4 <= 0) {

      for(int i = column; i > 0; i--) {

        startIndex = startIndex - 20;

      } 

    } else {

      startIndex = startIndex - (20 * 4);

    }
    // print(startIndex);
    start - 4 < 0 ? start = 0 : start = start - 4;
    end + 4 > 19 ? end = 19 : end = end + 4;

    for(int i = start; i <= end; i ++) {

      if(roomData['gameboard'][startIndex]['state'] == value) {

        count = count + 1;
        
        if(count == 4) {
          database.child('Room/$roomId/player/player$value/').update({
            'score': roomData['player']['player$value']['score'] + 1
          });
        }

      } else {

        count = 0;

      }

      startIndex = startIndex + 20;

    }


  }

  void topLeftToBottomRightCheck(Map<dynamic, dynamic> roomData, int roomId, int index, int value) {

    List<int> indexList = [];
    int startIndex = index;
    int endIndex = index;
    int count = 0;

    indexList.add(startIndex);

    for(int i = 0; i < 4; i++) {

      if((startIndex / 20).floor() == 0 || (startIndex % 20) == 0) break;

      startIndex = startIndex - 21;
      indexList.add(startIndex);

      if((startIndex % 20) == 0 || (startIndex / 20).floor() == 0) break;

    }

    for(int i = 0; i < 4; i++) {

      if((endIndex % 20) == 19 || (endIndex / 20).floor() == 19) break;

      endIndex = endIndex + 21;
      indexList.add(endIndex);

      if((endIndex % 20) == 19 || (endIndex / 20).floor() == 19) break;

    }

    indexList.sort();
    
    indexList.forEach((val) {

      roomData['gameboard'][val]['state'] == value ? count++ : count = 0;

      if(count == 4) database.child('Room/$roomId/player/player$value/').update({
        'score': roomData['player']['player$value']['score'] + 1
      });

    });



  }
  

  void bottomLeftToTopRightCheck(Map<dynamic, dynamic> roomData, int roomId, int index, int value) {

    List<int> indexList = [];
    int startIndex = index;
    int endIndex = index;
    int count = 0;

    indexList.add(startIndex);

    for(int i = 0; i < 4; i++) {

      if((endIndex % 20) == 0 || (startIndex / 20).floor() == 19) break;

      endIndex = endIndex + 19;
      indexList.add(endIndex);

      if((endIndex % 20) == 19 || (endIndex / 20).floor() == 19) break;

    }

    for(int i = 0; i < 4; i++) {
      
      if((startIndex / 20).floor() == 0 || (startIndex % 20) == 19) break;

      startIndex = startIndex - 19;
      indexList.add(startIndex);

      if((startIndex % 20) == 0 || (startIndex / 20).floor() == 0) break;

    }

    indexList.sort();
    
    indexList.forEach((val) {

      roomData['gameboard'][val]['state'] == value ? count++ : count = 0;

      if(count == 4) database.child('Room/$roomId/player/player$value/').update({
        'score': roomData['player']['player$value']['score'] + 1
      });

    });



  }


}

void showSnackBar(String errorMessage) {
  Get.snackbar('Error', errorMessage,
      snackPosition: SnackPosition.BOTTOM,
      margin: EdgeInsets.all(24.0),
      borderRadius: 0.0,
      showProgressIndicator: true,
      backgroundColor: Color(0xffffebee),
      progressIndicatorBackgroundColor: Color(0xffffcdd2),
      progressIndicatorValueColor:
          AlwaysStoppedAnimation<Color>(Color((0xfff44336))));
}
