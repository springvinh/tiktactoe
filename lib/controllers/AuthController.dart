import 'package:caro/utils/root.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthController extends GetxController  {

  FirebaseAuth auth = FirebaseAuth.instance;
  Rx<User> firebaseUser = Rx<User>();

  String get user => auth.currentUser?.email;


  @override
  void onInit() {
    firebaseUser.bindStream(auth.authStateChanges());
  }
  

  void createUser(String username, String email, String password) async {
  
    try {
      // await Firebase.initializeApp();

      await auth.createUserWithEmailAndPassword(email: email, password: password);
      
      await auth.currentUser.updateProfile(displayName: username);

      Get.offAll(Root());

      Get.snackbar('Success', 'Account created successfully.',
        snackPosition: SnackPosition.BOTTOM,
        margin: EdgeInsets.all(24.0),
        borderRadius: 0.0,
        showProgressIndicator: true,
        backgroundColor: Color(0xffe0f2f1),
        progressIndicatorBackgroundColor: Color(0xffb2dfdb),
        progressIndicatorValueColor: AlwaysStoppedAnimation<Color>(Color((0xff009688)))
      );

    } catch (error) {
      String errorMessage = error.message;

      showSnackBar(errorMessage);

    }

  }

  void signIn(String email, String password) async {

    try {

      await auth.signInWithEmailAndPassword(email: email, password: password);

    } catch(error) {

      String errorMessage = error.message;

      showSnackBar(errorMessage);

    }

  }

  void signOut() async {

    try {

      await auth.signOut();

    } catch(error) {

      String errorMessage = error.message;

      showSnackBar(errorMessage);

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
    progressIndicatorValueColor: AlwaysStoppedAnimation<Color>(Color((0xfff44336)))
  );

}