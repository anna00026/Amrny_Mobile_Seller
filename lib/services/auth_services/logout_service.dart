import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pusher_beams/pusher_beams.dart';
import 'package:qixer_seller/main.dart';
import 'package:qixer_seller/services/push_notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/others_helper.dart';
import '../common_service.dart';

class LogoutService with ChangeNotifier {
  bool isloading = false;

  setLoadingTrue() {
    isloading = true;
    notifyListeners();
  }

  setLoadingFalse() {
    isloading = false;
    notifyListeners();
  }

  logout(BuildContext context) async {
    var connection = await checkConnection();
    if (connection) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');

      var header = {
        //if header type is application/json then the data should be in jsonEncode method
        "Accept": "application/json",
        // "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      };

      setLoadingTrue();
      var response = await http.post(
        Uri.parse('$baseApi/user/logout'),
        headers: header,
      );
      setLoadingFalse();
      if (response.statusCode == 201) {
        notifyListeners();
        var pusherInstance =
            await Provider.of<PushNotificationService>(context, listen: false)
                .pusherInstance;

        if (pusherInstance == null) {
          try {
            await PusherBeams.instance.clearAllState();
          } catch (e) {}
        }

//pop sidebar
        Navigator.pushAndRemoveUntil<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
            builder: (BuildContext context) => const MyApp(),
          ),
          (route) => false,
        );

        // clear profile data =====>
        // Future.delayed(const Duration(microseconds: 5500), () {
        //   Provider.of<ProfileService>(context, listen: false)
        //       .setEverythingToDefault();
        // });

        clear();
      } else {
        print(response.body);
        OthersHelper().showToast('Something went wrong', Colors.black);
      }
    }
  }

  //clear saved email, pass and token
  clear() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}
