import 'package:caro/models/UserModel.dart';
import 'package:caro/screens/home.dart';
import 'package:caro/screens/signin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Root extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // return (Get.find<AuthController>().user) != null ? Home() : SignIn();
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.active) {
          User user = snapshot.data;

          if(user == null) {
            return SignIn();
          }

          String username = user.displayName;
          String uid = user.uid;
          String email = user.email;

          UserModel userModel = UserModel(
            uid: uid,
            username: username,
            email: email
          );


          return Home(userModel: userModel);
        }
        return Container(
          child: Center(
            child: CircularProgressIndicator(),
          )
        );
      },
    );
  }
}