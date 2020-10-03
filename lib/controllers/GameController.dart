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
        'switchTurn': 0,
        'playerTurn': uid,
        'isPlaying': true
      });
    } catch (error) {
      Get.back();
      showSnackBar(error.message);
    }
  }

  void updateCellState(Map<dynamic, dynamic> roomData, int index) {
    if (roomData['gameboard'][index]['state'] == 0 &&
        roomData['isPlaying'] == true) {
          
      if (roomData['switchTurn'] % 2 == 0) {
        
        database.child('Room/$roomId/').update({'switchTurn': roomData['switchTurn'] + 1}).then((value) => {
          database.child('Room/$roomId/gameboard/$index/').update({'state': 1}).then((value) => {
            columnCheck(roomData, index, roomData['gameboard'][index]['column'], roomData['gameboard'][index]['row'], 1)
          })
        });

      } else {

        database.child('Room/$roomId/').update({'switchTurn': roomData['switchTurn'] + 1}).then((value) => {
          database.child('Room/$roomId/gameboard/$index/').update({'state': 2}).then((value) => {
            columnCheck(roomData, index, roomData['gameboard'][index]['column'], roomData['gameboard'][index]['row'], 2)
          })
        });

      }
    }
  }


  void columnCheck(Map<dynamic, dynamic> roomData, int index, int column, int row, int value) {
    
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
