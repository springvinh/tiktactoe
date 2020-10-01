import 'package:caro/controllers/AuthController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUp extends GetWidget<AuthController> {

  TextEditingController usernameController = TextEditingController();
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
                    controller: usernameController,
                    style: TextStyle(
                      fontWeight: FontWeight.bold
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(width: 2.0, color: Colors.blue)                        
                      ),
                      contentPadding: EdgeInsets.only(left: 20.0, right: 20.0, top: 12.0, bottom: 12.0),
                      labelText: 'Username',
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
                      child: Text('Sign Up', style: TextStyle(color: Colors.white),)
                    ),
                  ),
                  onPressed: () {
                    controller.createUser(usernameController.text, emailController.text, passwordController.text);
                  },
                )
              ],
            )
          ),
        ),
      ),
    );
  }
}
