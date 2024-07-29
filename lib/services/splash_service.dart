import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qixer_seller/services/auth_services/login_service.dart';
import 'package:qixer_seller/view/auth/login/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashService {
  loginOrGoHome(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? keepLogin = prefs.getBool('keepLoggedIn');
    String? email = prefs.getString('email');
    if (keepLogin == null) {
      //that means user is opening the app for the first time.. so , show the intro/login
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pushReplacement<void, void>(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => const LoginPage(),
          ),
        );
      });
    } else if (keepLogin == false) {
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pushReplacement<void, void>(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => const LoginPage(),
          ),
        );
      });
    } else {
      //user logged in with his email and password. so,
      //Try to login with the saved email and password
      debugPrint('trying to log in with email pass');
      String? email = prefs.getString('email');
      String? pass = prefs.getString('pass');
      var result = await Provider.of<LoginService>(context, listen: false)
          .login(email, pass, context, true, isFromLoginPage: false);

      if (result == false) {
        //if login failed
        Navigator.pushReplacement<void, void>(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => const LoginPage(),
          ),
        );
      }
    }
  }
}
