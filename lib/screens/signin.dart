import 'package:caro/controllers/AuthController.dart';
import 'package:caro/screens/signup.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignIn extends GetWidget<AuthController> {

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 46.0, horizontal: 24.0),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                const SizedBox(height: 46.0,),
                const FlutterLogo(size: 100.0),
                const SizedBox(height: 80.0,),
                Container(
                  color: Color(0xfff5f5f5),
                  child: TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(
                      fontWeight: FontWeight.bold
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(width: 2.0, color: Colors.blue)                        
                      ),
                      contentPadding: EdgeInsets.only(left: 20.0, right: 20.0, top: 12.0, bottom: 12.0),
                      labelText: 'Email',
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 14.0
                      )
                    ),
                  ),
                ),
                SizedBox(height: 12.0),
                Container(
                  color: Color(0xfff5f5f5),
                  child: TextField(
                    controller: passwordController,
                    obscureText: true,
                    style: TextStyle(
                      fontWeight: FontWeight.bold
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(width: 2.0, color: Colors.blue)                        
                      ),
                      contentPadding: EdgeInsets.only(left: 20.0, right: 20.0, top: 12.0, bottom: 12.0),
                      labelText: 'Password',
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 14.0
                      )
                    ),
                  ),
                ),
                SizedBox(height: 12.0),
                FlatButton(
                  color: Colors.blue,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 15.0),
                    width: double.infinity,
                    child: Center(
                      child: Text('Sign In', style: TextStyle(color: Colors.white),)
                    ),
                  ),
                  onPressed: () {
                    controller.signIn(emailController.text, passwordController.text);
                  },
                ),
                SizedBox(height: 24.0),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Don\'t have an account? ', style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.bold),),
                    InkWell(
                      child: Text('Sign up.', style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.bold, color: Colors.blue),),
                      onTap: () {
                        Get.to(SignUp());
                      },
                    )
                  ],
                )
              ],
            )
          ),
        ),
      ),
    );
  }
}
