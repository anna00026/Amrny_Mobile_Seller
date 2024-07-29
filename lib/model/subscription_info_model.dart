// To parse this JSON data, do
//
//     final subscriptionInfoModel = subscriptionInfoModelFromJson(jsonString);

import 'dart:convert';

SubscriptionInfoModel subscriptionInfoModelFromJson(String str) =>
    SubscriptionInfoModel.fromJson(json.decode(str));

String subscriptionInfoModelToJson(SubscriptionInfoModel data) =>
    json.encode(data.toJson());

class SubscriptionInfoModel {
  SubscriptionInfoModel({
    required this.subscriptionInfo,
  });

  SubscriptionInfo subscriptionInfo;

  factory SubscriptionInfoModel.fromJson(Map<String, dynamic> json) =>
      SubscriptionInfoModel(
        subscriptionInfo: SubscriptionInfo.fromJson(json["subscription_info"]),
      );

  Map<String, dynamic> toJson() => {
        "subscription_info": subscriptionInfo.toJson(),
      };
}

class SubscriptionInfo {
  SubscriptionInfo({
    this.id,
    this.subscriptionId,
    this.sellerId,
    this.type,
    this.connect,
    this.price,
    this.initialConnect,
    this.initialPrice,
    this.total,
    this.status,
    this.expireDate,
    this.paymentGateway,
    this.paymentStatus,
    this.transactionId,
    this.manualPaymentImage,
    this.note,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  int? subscriptionId;
  int? sellerId;
  String? type;
  int? connect;
  int? price;
  int? initialConnect;
  int? initialPrice;
  int? total;
  int? status;
  DateTime? expireDate;
  String? paymentGateway;
  String? paymentStatus;
  String? transactionId;
  String? manualPaymentImage;
  dynamic note;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory SubscriptionInfo.fromJson(Map<String, dynamic> json) =>
      SubscriptionInfo(
        id: json["id"],
        subscriptionId: json["subscription_id"],
        sellerId: json["seller_id"],
        type: json["type"],
        connect: json["connect"],
        price: json["price"],
        initialConnect: json["initial_connect"],
        initialPrice: json["initial_price"],
        total: json["total"],
        status: json["status"],
        expireDate: DateTime.parse(json["expire_date"]),
        paymentGateway: json["payment_gateway"],
        paymentStatus: json["payment_status"],
        transactionId: json["transaction_id"],
        manualPaymentImage: json["manual_payment_image"],
        note: json["note"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "subscription_id": subscriptionId,
        "seller_id": sellerId,
        "type": type,
        "connect": connect,
        "price": price,
        "initial_connect": initialConnect,
        "initial_price": initialPrice,
        "total": total,
        "status": status,
        "expire_date": expireDate?.toIso8601String(),
        "payment_gateway": paymentGateway,
        "payment_status": paymentStatus,
        "transaction_id": transactionId,
        "manual_payment_image": manualPaymentImage,
        "note": note,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
