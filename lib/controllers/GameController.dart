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
          'player1': {'uid': uid, 'username': username},
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
        // database
        //     .child('Room/$roomId/')
        //     .update({'switchTurn': roomData['switchTurn'] + 1});
        // database.child('Room/$roomId/gameboard/$index/').update({'state': 1});



        database.child('Room/$roomId/').update({
          'switchTurn': roomData['switchTurn'] + 1,
          'gameboard': {
            '$index': {
              'state': 1
            }
          }
        });
      } else {

        database.child('Room/$roomId/').update({
          'switchTurn': roomData['switchTurn'] + 1,
          // 'gameboard': {
          //   '$index': {
          //     'state': 2
          //   }
          // }
        });

        // database
        //     .child('Room/$roomId/')
        //     .update({'switchTurn': roomData['switchTurn'] + 1});
        // database.child('Room/$roomId/gameboard/$index/').update({'state': 2});
      }
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
