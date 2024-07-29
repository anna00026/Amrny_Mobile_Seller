import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:qixer_seller/model/chat_list_model.dart';
import 'package:qixer_seller/services/common_service.dart';
import 'package:qixer_seller/utils/others_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatListService with ChangeNotifier {
  var chatList = [];
  List chatListImage = [];
  List storeChatList = [];
  List storeChatListImage = [];

  bool isLoading = false;

  setLoadingStatus(bool status) {
    isLoading = status;
    notifyListeners();
  }

  setLoadedChatList() {
    chatList = storeChatList;
    chatListImage = storeChatListImage;
    notifyListeners();
  }

  fetchChatList(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    var header = {
      //if header type is application/json then the data should be in jsonEncode method
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };

    var connection = await checkConnection();
    if (!connection) {
      return;
    }

    setLoadingStatus(true);

    var response = await http.get(Uri.parse("$baseApi/seller/chat/buyer-lists"),
        headers: header);

    setLoadingStatus(false);

    chatList = [];
    chatListImage = [];
    storeChatList = [];
    storeChatListImage = [];

    if (response.statusCode == 201 &&
        jsonDecode(response.body)['buyer_image'].isNotEmpty) {
      final data = ChatListModel.fromJson(jsonDecode(response.body));

      chatList = data.chatBuyerLists;
      chatListImage = jsonDecode(response.body)['buyer_image'];
      storeChatList = chatList;
      storeChatListImage = chatListImage;

      print('chat list image $chatListImage');

      notifyListeners();

      return true;
    } else {
      print("chat list error ${response.body}");
      return false;
    }
  }

  ///Search user
  ///===============>
  searchUser(String searchString) {
    chatList = [];
    chatListImage = [];

    for (int i = 0; i < storeChatList.length; i++) {
      if ((storeChatList[i].buyerList.name.toLowerCase())
          .contains(searchString.toLowerCase())) {
        chatList.add(storeChatList[i]);

        if (storeChatListImage[i] is List) {
          //if api returned empty array then in image we insert empty array
          //because, in frontend we validate image based on the empty array
          chatListImage.add([]);
        } else {
          chatListImage.add(storeChatListImage[i]);
        }
      }
    }
    notifyListeners();
  }
}
