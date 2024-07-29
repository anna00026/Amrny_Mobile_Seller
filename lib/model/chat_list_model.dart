// To parse this JSON data, do
//
//     final chatListModel = chatListModelFromJson(jsonString);

import 'dart:convert';

ChatListModel chatListModelFromJson(String str) =>
    ChatListModel.fromJson(json.decode(str));

String chatListModelToJson(ChatListModel data) => json.encode(data.toJson());

class ChatListModel {
  ChatListModel({
    required this.chatBuyerLists,
    required this.buyerImage,
  });

  List<ChatBuyerList> chatBuyerLists;
  List<dynamic> buyerImage;

  factory ChatListModel.fromJson(Map<String, dynamic> json) => ChatListModel(
        chatBuyerLists: List<ChatBuyerList>.from(
            json["chat_buyer_lists"].map((x) => ChatBuyerList.fromJson(x))),
        buyerImage: List<dynamic>.from(json["buyer_image"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "chat_buyer_lists":
            List<dynamic>.from(chatBuyerLists.map((x) => x.toJson())),
        "buyer_image": List<dynamic>.from(buyerImage.map((x) => x)),
      };
}

class BuyerImageClass {
  BuyerImageClass({
    this.imageId,
    this.path,
    this.imgUrl,
    this.imgAlt,
  });

  int? imageId;
  String? path;
  String? imgUrl;
  dynamic imgAlt;

  factory BuyerImageClass.fromJson(Map<String, dynamic> json) =>
      BuyerImageClass(
        imageId: json["image_id"],
        path: json["path"],
        imgUrl: json["img_url"],
        imgAlt: json["img_alt"],
      );

  Map<String, dynamic> toJson() => {
        "image_id": imageId,
        "path": path,
        "img_url": imgUrl,
        "img_alt": imgAlt,
      };
}

class ChatBuyerList {
  ChatBuyerList({
    this.buyerId,
    this.dateTimeStr,
    this.dateHumanReadable,
    this.imageUrl,
    this.senderProfileImage,
    this.buyerList,
  });

  int? buyerId;
  String? dateTimeStr;
  dynamic dateHumanReadable;
  String? imageUrl;
  dynamic senderProfileImage;
  BuyerList? buyerList;

  factory ChatBuyerList.fromJson(Map<String, dynamic> json) => ChatBuyerList(
        buyerId: json["buyer_id"],
        dateTimeStr: json["date_time_str"],
        dateHumanReadable: json["date_human_readable"],
        imageUrl: json["image_url"],
        senderProfileImage: json["sender_profile_image"],
        buyerList: json["buyer_list"] != null
            ? BuyerList.fromJson(json["buyer_list"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "buyer_id": buyerId,
        "date_time_str": dateTimeStr,
        "date_human_readable": dateHumanReadable,
        "image_url": imageUrl,
        "sender_profile_image": senderProfileImage,
        "buyer_list": buyerList?.toJson(),
      };
}

class BuyerList {
  BuyerList({
    this.id,
    this.name,
    this.email,
    this.username,
    this.phone,
    this.image,
    this.profileBackground,
    this.serviceCity,
    this.serviceArea,
    this.userType,
    this.userStatus,
    this.termsCondition,
    this.address,
    this.state,
    this.about,
    this.postCode,
    this.countryId,
    this.emailVerified,
    this.emailVerifyToken,
    this.facebookId,
    this.googleId,
    this.countryCode,
    this.createdAt,
    this.updatedAt,
    this.fbUrl,
    this.twUrl,
    this.goUrl,
    this.liUrl,
    this.yoUrl,
    this.inUrl,
    this.twiUrl,
    this.piUrl,
    this.drUrl,
    this.reUrl,
  });

  int? id;
  String? name;
  String? email;
  String? username;
  String? phone;
  String? image;
  String? profileBackground;
  String? serviceCity;
  String? serviceArea;
  int? userType;
  int? userStatus;
  int? termsCondition;
  String? address;
  String? state;
  dynamic about;
  String? postCode;
  int? countryId;
  int? emailVerified;
  String? emailVerifyToken;
  dynamic facebookId;
  dynamic googleId;
  String? countryCode;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic fbUrl;
  dynamic twUrl;
  dynamic goUrl;
  dynamic liUrl;
  dynamic yoUrl;
  dynamic inUrl;
  dynamic twiUrl;
  dynamic piUrl;
  dynamic drUrl;
  dynamic reUrl;

  factory BuyerList.fromJson(Map<String, dynamic> json) => BuyerList(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        username: json["username"],
        phone: json["phone"],
        image: json["image"],
        profileBackground: json["profile_background"],
        serviceCity: json["service_city"],
        serviceArea: json["service_area"],
        userType: json["user_type"],
        userStatus: json["user_status"],
        termsCondition: json["terms_condition"],
        address: json["address"],
        state: json["state"],
        about: json["about"],
        postCode: json["post_code"],
        countryId: json["country_id"],
        emailVerified: json["email_verified"],
        emailVerifyToken: json["email_verify_token"],
        facebookId: json["facebook_id"],
        googleId: json["google_id"],
        countryCode: json["country_code"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        fbUrl: json["fb_url"],
        twUrl: json["tw_url"],
        goUrl: json["go_url"],
        liUrl: json["li_url"],
        yoUrl: json["yo_url"],
        inUrl: json["in_url"],
        twiUrl: json["twi_url"],
        piUrl: json["pi_url"],
        drUrl: json["dr_url"],
        reUrl: json["re_url"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "username": username,
        "phone": phone,
        "image": image,
        "profile_background": profileBackground,
        "service_city": serviceCity,
        "service_area": serviceArea,
        "user_type": userType,
        "user_status": userStatus,
        "terms_condition": termsCondition,
        "address": address,
        "state": state,
        "about": about,
        "post_code": postCode,
        "country_id": countryId,
        "email_verified": emailVerified,
        "email_verify_token": emailVerifyToken,
        "facebook_id": facebookId,
        "google_id": googleId,
        "country_code": countryCode,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "fb_url": fbUrl,
        "tw_url": twUrl,
        "go_url": goUrl,
        "li_url": liUrl,
        "yo_url": yoUrl,
        "in_url": inUrl,
        "twi_url": twiUrl,
        "pi_url": piUrl,
        "dr_url": drUrl,
        "re_url": reUrl,
      };
}
