// ignore_for_file: prefer_typing_uninitialized_variables, avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pusher_beams/pusher_beams.dart';
import 'package:qixer_seller/services/common_service.dart';
import 'package:qixer_seller/services/profile_service.dart';
import 'package:qixer_seller/utils/others_helper.dart';
import 'package:qixer_seller/utils/responsive.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PushNotificationService with ChangeNotifier {
  bool pusherCredentialLoaded = false;

  //get pusher credential
  //======================>

  var apiKey;
  var secret;
  var pusherToken;
  var pusherApiUrl;
  var pusherInstance;
  var pusherCluster;

  Future<bool> fetchPusherCredential({context}) async {
    var connection = await checkConnection();
    if (!connection) return false;
    if (pusherCredentialLoaded == true) return false;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var header = {
      //if header type is application/json then the data should be in jsonEncode method
      "Accept": "application/json",
      // "Content-Type": "application/json"
      "Authorization": "Bearer $token",
    };

    var response = await http.get(
        Uri.parse("$baseApi/user/chat/pusher/credentials"),
        headers: header);

    if (response.statusCode == 201) {
      final jsonData = jsonDecode(response.body);
      pusherCredentialLoaded = true;
      apiKey = jsonData['pusher_app_key'];
      secret = jsonData['pusher_app_secret'];
      pusherToken = jsonData['pusher_app_push_notification_auth_token'];
      pusherApiUrl = jsonData['pusher_app_push_notification_auth_url'];
      pusherCluster = jsonData['pusher_app_cluster'];
      pusherInstance = jsonData['pusher_app_push_notification_instanceId'];

      notifyListeners();
      try {
        if (pusherInstance != null) {
          await PusherBeams.instance.start(pusherInstance);
        }
      } catch (e) {}
      return true;
    } else {
      print(response.body);
      return false;
    }
  }

  sendNotification(BuildContext context, {required buyerId, required msg}) {
    //Send notification to seller
    var username = Provider.of<ProfileService>(context, listen: false)
            .profileDetails
            .name ??
        '';
    sendNotificationToBuyer(context,
        buyerId: buyerId,
        title: asProvider.getString("New chat message") + ": $username",
        body: '$msg');
  }

  sendNotificationToBuyer(BuildContext context,
      {required buyerId,
      required title,
      required body,
      type = "notification"}) async {
    var pUrl = Provider.of<PushNotificationService>(context, listen: false)
        .pusherApiUrl;

    var pToken = Provider.of<PushNotificationService>(context, listen: false)
        .pusherToken;

    var senderId =
        Provider.of<ProfileService>(context, listen: false).profileDetails.id;
    print("sender id:$senderId");

    var header = {
      //if header type is application/json then the data should be in jsonEncode method
      // "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": "Bearer $pToken",
    };

    var data = jsonEncode({
      "interests": ["debug-buyer$buyerId"],
      "fcm": {
        "notification": {
          "title": "$title",
          "body": "$body",
        },
        "data": {"sender-id": '$senderId', "type": '$type'}
      }
    });
    print(data);

    var response =
        await http.post(Uri.parse("$pUrl"), headers: header, body: data);

    if (response.statusCode == 200) {
      print('send notification to seller success');
    } else {
      print('send notification to seller failed');
      print(response.body);
    }
  }
}
