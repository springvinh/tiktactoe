import 'package:caro/models/CellModel.dart';
import 'PlayerModel.dart';

class RoomModel {

  PlayerModel phayer1;
  PlayerModel player2;
  List<CellModel> gameboard;
  bool isPlaying;
  int turn;
  int roomId;

}